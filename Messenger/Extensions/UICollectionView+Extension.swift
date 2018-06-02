//
//  UICollectionView+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable {

        self.register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable, T: NibLoadable {

        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)

        self.register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(_: T.Type, supplementaryViewOfKind: String) where T: Reusable {
        
        self.register(T.self, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UICollectionReusableView>(_: T.Type, supplementaryViewOfKind: String) where T: Reusable, T: NibLoadable {

        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)

        self.register(nib, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {

        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {

            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String, indexPath: IndexPath) -> T where T: Reusable {

        guard let reusableView = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {

            fatalError("Could not dequeue UICollectionReusableView with identifier: \(T.defaultReuseIdentifier)")
        }

        return reusableView
    }

    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0,
                       animations: { self.reloadData() },
                       completion: { _ in completion() }
        )
    }
}
