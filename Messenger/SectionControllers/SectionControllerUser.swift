//
//  SectionControllerUser.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import IGListKit

class SectionControllerUsers: ListSectionController {
    
    private var users: [RealmUser]?
    
    override init() {
        super.init()
        minimumLineSpacing = 8
        minimumInteritemSpacing = 8
        inset = .init(top: 8, left: 8, bottom: 0, right: 8)
    }
    
    override func numberOfItems() -> Int {
        guard let users = users else { return 0 }
        return users.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerWidth = collectionContext?.containerSize.width else {
            return .zero
        }
        let numberOfCells = floor((containerWidth - inset.left - inset.right) / 250)
        let aspectRatio: CGFloat = (UIHelper.isIPad) ? 150/250 : 120/250
        let width = (containerWidth - inset.left - inset.right - (numberOfCells-1) * minimumInteritemSpacing) / numberOfCells
        return (UIHelper.isIPad) ? CGSize(width: width, height: width * aspectRatio) : CGSize(width: width, height: width * aspectRatio)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let users = users, let context = collectionContext else {
            fatalError("users or context is nil")
        }
        let cell: CollectionViewCellUser = context.dequeueReusableCell(self, forIndex: index)
        cell.bindData(item: users[index])
        return cell
    }
    
    override func didUpdate(to object: Any) {
        let object = object as? UserArray
        users = object?.users
    }
    
    override func didSelectItem(at index: Int) {
        guard let item = users?[index] else { return }
        let alertController = UIAlertController.init(title: "User selected", message: "you selected \(item.name)", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction.init(title: "OK", style: .cancel))
        
        viewController?.present(alertController, animated: true)
    }
}
