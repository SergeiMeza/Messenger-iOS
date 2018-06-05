//
//  CollectionViewCellUser.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import GameKit

class CollectionViewCellUser: UICollectionViewCell, NibLoadable, Reusable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!

    func bindData(item: RealmUser) {
        let generator = GKRandomDistribution.init(lowestValue: 0, highestValue: 100)
        nameLabel.text = "\(item.name), \(item.age)"
        detailsLabel.text = "favorite color: \(item.favoriteColor), isWizard: \(item.isWizard)"
        contentView.backgroundColor = .white
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderColor = UIColor.themeColor.cgColor
        imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage.init(named: "profile_\(generator.nextInt() % 9)")
    }
}
