//
//  ViewControllerFaceDetection.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/06.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

class ViewControllerFaceDetection: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        guard let image = UIImage(named: "profile_0") else { return }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        view.addSubview(imageView)
        imageView.fillSuperview()
    }
    
    
}
