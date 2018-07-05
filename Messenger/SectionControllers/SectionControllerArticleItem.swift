import IGListKit

class SectionControllerArticleItem: ListSectionController {
    
    private var item: ArticleItem?
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerWidth = collectionContext?.containerSize.width else { return .zero }
        return CGSize.init(width: containerWidth, height: 100)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let item = item, let context = collectionContext else {
            fatalError("item or context is null")
        }
        switch item.type {
        case .image:
            let cell: CollectionViewCellShowArticleImage = context.dequeueReusableCell(self, forIndex: index)
            cell.setImage(item: item)
            return cell
        case .text:
            let cell: CollectionViewCellShowArticleText = context.dequeueReusableCell(self, forIndex: index)
            cell.setText(item: item)
            return cell
        case .subTitle:
            let cell: CollectionViewCellShowArticleTitle = context.dequeueReusableCell(self, forIndex: index)
            cell.setSubTitle(item: item)
            return cell
        case .quotation:
            let cell: CollectionViewCellShowArticleQuotation = context.dequeueReusableCell(self, forIndex: index)
            cell.setQuotation(item: item)
            return cell
        case .linkImage:
            let cell: CollectionViewCellShowArticleLinkImage = context.dequeueReusableCell(self, forIndex: index)
            cell.setup(item: item)
            return cell
        case .subSubTitle:
            let cell: CollectionViewCellShowArticleSubtitle = context.dequeueReusableCell(self, forIndex: index)
            cell.setupTitle(item: item)
            return cell
        default:
            let cell: CollectionViewCellShowArticleText = context.dequeueReusableCell(self, forIndex: index)
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        item = object as? ArticleItem
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
}
