//
//  ListCollectionContext+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import IGListKit

extension ListCollectionContext {

    func dequeueReusableCell<T: UICollectionViewCell>(_ sectionController: ListSectionController,
                                                      forIndex: Int)
                                                        -> T {
        guard let cell = dequeueReusableCell(of: T.self, for: sectionController, at: forIndex) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.self)")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ sectionController: ListSectionController,
                                                      forIndex: Int)
                                                        -> T where T: Reusable, T: NibLoadable {
        let bundle = Bundle(for: T.self)
        
        guard let cell = dequeueReusableCell(withNibName: T.defaultReuseIdentifier,
                                             bundle: bundle,
                                             for: sectionController,
                                             at: forIndex) as? T
            else {
                fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
            }
                                                            
        return cell
    }
}
