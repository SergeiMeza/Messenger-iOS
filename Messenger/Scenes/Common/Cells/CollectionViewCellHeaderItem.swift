//
//  CollectionViewCellHeader.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/28.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

class CollectionViewCellHeaderItem: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func bindData(item: Any) {
        
    }
}
