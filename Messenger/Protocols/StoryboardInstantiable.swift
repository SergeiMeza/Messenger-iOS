//
//  StoryboardInstantiable+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit


// MARK: - StoryboardInstantiable

protocol StoryboardInstantiable {}
extension UIViewController: StoryboardInstantiable {}
extension StoryboardInstantiable where Self: UIViewController {

    static func instantiate() -> Self {

        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("生成したいViewControllerと同じ名前のStorybaordが見つからないか、Initial ViewControllerに設定されていない可能性があります。")
        }

        return controller
    }
}
