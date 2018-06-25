//
//  CollectionViewCellChat.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/26.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import GameKit

class CollectionViewCellChat: UICollectionViewCell, NibLoadable, Reusable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func bindData(item: RealmChat) {
        let generator = GKRandomDistribution.init(lowestValue: 0, highestValue: 100)
        nameLabel.text = "\(item.name) \(item.timestamp)"
        contentView.backgroundColor = .white
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderColor = UIColor.themeColor.cgColor
        imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage.init(named: "profile_\(generator.nextInt() % 9)")
    }
}

