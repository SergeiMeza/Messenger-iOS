import IGListKit

class SectionControllerArticles: ListSectionController {
    
    private var articles: [Article]?
    
    convenience init(insets: UIEdgeInsets) {
        self.init()
        minimumLineSpacing = 12
        minimumInteritemSpacing = 12
        inset = insets
    }
    
    override func numberOfItems() -> Int {
        guard let articles = articles else { return 0 }
        return articles.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerWidth = collectionContext?.containerSize.width else { return .zero }
        let numberOfCells = floor((containerWidth - inset.left - inset.right) / 320)
        let aspectRatio: CGFloat = (UIHelper.isIPad) ? 1/2.5 : 1/2.5
        let width = (containerWidth - inset.left - inset.right - (numberOfCells-1) * minimumInteritemSpacing) / numberOfCells
        return CGSize(width: width, height: width * aspectRatio)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let articles = articles, let context = collectionContext else {
            fatalError("articles or context is null")
        }
        let cell: CollectionViewCellArticle = context.dequeueReusableCell(self, forIndex: index)
        cell.setup(item: articles[index])
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    override func didUpdate(to object: Any) {
        let object = object as? ArticleArray
        articles = object?.articles
    }
    
    override func didSelectItem(at index: Int) {
//        guard let articles = articles else { return }
        let url = URL(string: "https://www.appcrunch.net/language.html")!
        let vc = SiteWebViewController.init(url: url, title: "Hello World")
        viewController?.navigationController?.pushViewController(vc, animated: true)
//        let vc = ViewControllerShowArticle.instantiate()
//        vc.articleId = articles[index].objectId
//        vc.hidesBottomBarWhenPushed = true
//        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
