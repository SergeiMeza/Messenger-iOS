//
//  SectionControllerLoading.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import IGListKitSectionControllerUsers

class SectionControllerLoading: ListSectionController {
    
    private var isCompleted: Bool? = true
    
    override func numberOfItems() -> Int {
        if let isCompleted = isCompleted, isCompleted { return 0 }
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .init(width: collectionContext?.containerSize.width ?? 0, height: 100)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext else {
            fatalError("context is nil")
        }
        let cell: CollectionViewCellLoading = context.dequeueReusableCell(self, forIndex: index)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        isCompleted = object as? Bool
    }
}
