//
//  CollectionViewCellUser.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

class CollectionViewCellUser: UICollectionViewCell, NibLoadable, Reusable {
    
    @IBOutlet weak var logLabel: UILabel!

    func bindData(item: RealmUser) {
        logLabel.text = "Name: \(item.name), Age: \(item.age), favoriteColor: \(item.favoriteColor)"
        contentView.backgroundColor = item.isWizard ? UIColor.green : UIColor.red
        
    }
}
