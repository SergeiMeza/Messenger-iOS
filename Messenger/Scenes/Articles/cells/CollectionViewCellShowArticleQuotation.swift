import UIKit
import RxCocoa
import RxSwift

class CollectionViewCellShowArticleQuotation: UICollectionViewCell, Reusable, NibLoadable {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        backgroundColor = UIColor.aquaHaze
    }
    
    @IBOutlet weak var quotationText: LinkableTextField!
    @IBOutlet weak var quotationLink: UILabel!
    
    var linkUrl: String?
    let tapGesture = UITapGestureRecognizer()
    
    func setQuotation(item: ArticleItem) {
        quotationLink.isUserInteractionEnabled = true
        let quotation = item.quotation
        quotationLink.addGestureRecognizer(tapGesture)
        
        tapGesture.addTarget(self, action: #selector(linkTapped(_:)))
        
        if let link = quotation?.url {
            linkUrl = link
        }
        quotationText.text = quotation?.text
        quotationText.lineBreakMode = .byCharWrapping
        quotationText.contentMode = .scaleToFill
        quotationText.numberOfLines = 0
        quotationLink.text = quotation?.url
        quotationLink.lineBreakMode = .byTruncatingTail
    }
    
    @objc func linkTapped(_ sender: UITapGestureRecognizer) {
        if let url: String = linkUrl {
            RxBus.shared.post(event: UrlLinkTapEvent(url: URL(string: url)!))
        }
    }
}
