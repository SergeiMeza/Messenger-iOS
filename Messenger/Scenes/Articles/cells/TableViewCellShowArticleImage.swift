import AlamofireImage
import UIKit
import SnapKit

class TableViewCellShowArticleImage: UITableViewCell, Reusable, NibLoadable {
    
    @IBOutlet weak var articleImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImageView.snp.removeConstraints()
        articleImageView.image = nil
    }
    
    func setImage(item: ArticleItem) {
        guard let image = item.image else { return }
        articleImageView.dynamicHeightSetup(urlString: image.imageUrl, size: CGSize(width: image.width, height: image.height))
    }
}
