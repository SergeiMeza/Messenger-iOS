import Foundation
import UIKit
import RxCocoa
import RxSwift

class TableViewCellShowArticleLinkImage: UITableViewCell, Reusable, NibLoadable {
    
    @IBOutlet weak var linkImageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        linkImageView.image = nil
    }
    
    func setup(item: ArticleItem) {
        guard let linkImage = item.linkImage else { return }
        linkImageView.dynamicHeightSetup(urlString: linkImage.imageUrl, size: CGSize(width: linkImage.width, height: linkImage.height))
        linkImageView.isUserInteractionEnabled = true
        
        guard let url = URL(string: linkImage.referenceUrl) else { return }
        
        let tapGesture = UITapGestureRecognizer()
        linkImageView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: {  _ in
                RxBus.shared.post(event: UrlLinkTapEvent(url: url))
            }).disposed(by: disposeBag)
    }
}


