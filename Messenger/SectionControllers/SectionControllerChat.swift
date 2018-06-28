
import IGListKit

class SectionControllerChat: ListSectionController {
    
    private var chat: RealmChat?
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else {
            return .zero
        }
        return .init(width: width, height: 100)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let item = chat, let context = collectionContext else {
            fatalError("chat or context is nil")
        }
        let cell: CollectionViewCellChat = context.dequeueReusableCell(self, forIndex: index)
        cell.bindData(item: item)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        chat = object as? RealmChat
    }
    
    override func didSelectItem(at index: Int) {
        guard let item = chat else { return }
        let alertController = UIAlertController.init(title: "Chat selected", message: "you selected \(item.name)", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction.init(title: "OK", style: .cancel))
        
        viewController?.present(alertController, animated: true)
    }
}
