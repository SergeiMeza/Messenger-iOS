import UIKit

class TableViewCellShowArticleSubtitle: UITableViewCell, Reusable, NibLoadable {
    
    @IBOutlet weak var subSubTitleLabel: UILabel!
    @IBOutlet weak var viewLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewLine.backgroundColor = .themeColor
        subSubTitleLabel.font = .boldDefaultFont(ofSize: 16)
        subSubTitleLabel.textColor = .dark80
    }
    
    func setupTitle(item: ArticleItem) {
        guard let title = item.subSubTitle else { return }
        subSubTitleLabel.text = title.title
    }
}
