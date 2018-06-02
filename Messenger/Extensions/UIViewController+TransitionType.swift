//
//  UIViewController+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var isModal: Bool {
        if let navigationController = navigationController {
            if navigationController.viewControllers.first != self {
                return false
            }
        }
        
        if let _  = presentingViewController {
            return true
        }
        
        return false
    }
    
    func setupNavigationBarBackButton() {
        if isModal {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 40))
//            button.setImage(#imageLiteral(resourceName: "small_gray_cross"), for: .normal)
            button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
            let leftBarButton = UIBarButtonItem(customView: button)
            navigationItem.leftBarButtonItem = leftBarButton
        }
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
