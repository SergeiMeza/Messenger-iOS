import UIKit

class CollectionViewCellShowArticleTitle: UICollectionViewCell, Reusable, NibLoadable {
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var viewUnderLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subTitleLabel.font = .boldDefaultFont(ofSize: 18)
        subTitleLabel.textColor = .dark80
        viewUnderLine.backgroundColor = .themeColor
    }
    
    func setSubTitle(item: ArticleItem) {
        let title = item.subTitle
        subTitleLabel.text = title?.subTitle
    }
}
