//
//  CollectionViewCellItem.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import GameKit

class CollectionViewCellItem: UICollectionViewCell, NibLoadable, Reusable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = DeviceConst.cellRadius
        contentView.layer.masksToBounds = true
        layer.cornerRadius = DeviceConst.cellRadius
        layer.applyCardShadow()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func bindData(item: RealmUser) {
        let generator = GKRandomDistribution.init(lowestValue: 0, highestValue: 100)
        titleLabel.text = "\(item.name), \(item.age)"
        detailLabel.text = "favorite color: \(item.favoriteColor), isWizard: \(item.isWizard)"
        contentView.backgroundColor = .white
        imageView.layer.cornerRadius = DeviceConst.cellRadius
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage.init(named: "profile_\(generator.nextInt() % 9)")
    }
}
