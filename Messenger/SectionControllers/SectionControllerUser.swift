//
//  SectionControllerUser.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import IGListKit

class SectionControllerUser: ListSectionController {
    
    private var user: RealmUser?
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else {
            return .zero
        }
        return .init(width: width, height: 100)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let item = user, let context = collectionContext else {
            fatalError("user or context is nil")
        }
        let cell: CollectionViewCellUser = context.dequeueReusableCell(self, forIndex: index)
        cell.bindData(item: item)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        user = object as? RealmUser
    }
    
    override func didSelectItem(at index: Int) {
        guard let item = user else { return }
        let alertController = UIAlertController.init(title: "User selected", message: "you selected \(item.name)", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction.init(title: "OK", style: .cancel))
        
        viewController?.present(alertController, animated: true)
        
    }
}
