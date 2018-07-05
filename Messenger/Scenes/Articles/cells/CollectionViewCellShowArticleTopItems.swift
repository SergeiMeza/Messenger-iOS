import UIKit
import BonMot
import AlamofireImage

class CollectionViewCellShowArticleTopItems: UICollectionViewCell, Reusable, NibLoadable {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var abstractLabel: LinkableTextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.font = .mediumDefaultFont(ofSize: 13)
        dateLabel.textColor = .dark50
        authorNameLabel.font = .mediumDefaultFont(ofSize: 13)
        authorNameLabel.textColor = .dark50
        abstractLabel.font = .mediumDefaultFont(ofSize: 14)
        abstractLabel.textColor = .dark50
    }
    
    
    func setTopItems(article: Article) {
        thumbImageView.normalSetup(urlString: article.thumbUrl)
        authorImageView.roundSetup(urlString: article.authorImage, size: authorImageView.frame.size)
        
        if let date = article.updatedAt.dateFromISO8601 {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            dateLabel.text = formatter.string(from: date)
        }
        
        abstractLabel.text = article.abstract
        authorNameLabel.text = article.authorName
        
        let style = StringStyle.init(.font(.boldDefaultFont(ofSize: 20)),
                                     .color(.dark80),
                                     .maximumLineHeight(27.5),
                                     .minimumLineHeight(27.5))
        
        titleLabel.attributedText = article.title.styled(with: style)
    }
}
