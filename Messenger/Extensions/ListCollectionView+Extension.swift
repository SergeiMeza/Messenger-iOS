//
//  ListCollectionView+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import RxCocoa
import RxSwift
import IGListKit

extension ListCollectionView {
    
    func createEndScrollingObservable() -> Observable<(cell: UICollectionViewCell, at: IndexPath)> {
        return rx.willDisplayCell.filter({ cell, index in cell is CollectionViewCellLoading })
    }
}
