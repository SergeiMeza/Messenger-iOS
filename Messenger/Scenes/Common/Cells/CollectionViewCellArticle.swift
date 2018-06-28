import UIKit
import BonMot

class CollectionViewCellArticle: UICollectionViewCell, NibLoadable, Reusable {
    
    // MARK: Private
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    private let textStyle: StringStyle =  StringStyle.init(
        .font(.regularDefaultFont(ofSize: 13)),
        .maximumLineHeight(18),
        .minimumLineHeight(18),
        .color(.dark80))
    
    // MARK: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.textColor = UIColor.dark80
        viewCountLabel.textColor = UIColor.dark50
        authorNameLabel.textColor = UIColor.dark50
        contentView.layer.cornerRadius = DeviceConst.cellRadius
        contentView.layer.masksToBounds = true
        layer.cornerRadius = DeviceConst.cellRadius
        layer.applyCardShadow()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        mainImageView.image = nil
//        authorImageView.image = nil
//        contentLabel.text = ""
//        viewCountLabel.text = ""
//        authorNameLabel.text = ""
    }
    
    func setup(item: Article) {
        contentLabel.attributedText = item.title.styled(with: textStyle)
        viewCountLabel.text = "\(item.viewCount)view"
        authorNameLabel.text = item.authorName
        
//        mainImageView.normalSetup(urlString: item.thumbUrl)
//        authorImageView.roundSetup(urlString: item.authorImage, size: authorImageView!.frame.size)
    }
}

