import UIKit

class CollectionViewCellShowArticleText: UICollectionViewCell, Reusable, NibLoadable {
    
    @IBOutlet weak var articleTextLabel: LinkableTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        articleTextLabel.font = .mediumDefaultFont(ofSize: 14)
        articleTextLabel.textColor = .dark80
    }
    
    func setText(item: ArticleItem) {
        let text = item.text?.text ?? ""
        articleTextLabel.text = "\(text)\n"
        articleTextLabel.highlightLink()
    }
}
