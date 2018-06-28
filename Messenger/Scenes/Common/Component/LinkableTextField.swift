import Foundation
import TTTAttributedLabel
import UIKit
import MessageUI
import RxSwift
import RxCocoa

class LinkableTextField: TTTAttributedLabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        delegate = self
        let attributes = [ kCTForegroundColorAttributeName as AnyHashable: UIColor.themeColor ]
        linkAttributes = attributes
        activeLinkAttributes = attributes
    }
    
    func highlightHashtags() {
        guard let text = self.text, let NSText = self.text as NSString? else { return }
        let hashtagExpression = try? NSRegularExpression(pattern: DeviceConst.hashtagPattern, options: [])
        let matches = hashtagExpression!.matches(in: text, options: [], range: NSRange(location: 0, length: NSText.length))
        
        for match in matches {
            let matchRange = match.range(at: 0)
            let hashtagString = NSText.substring(with: matchRange)
            let hashtagURLString = NSString(format: "hashtag:%@", hashtagString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            addLink(to: URL(string: hashtagURLString as String), with: matchRange)
        }
    }
    
    func highlightLink() {
        guard let text = self.text,
            let linkPattern = try? NSRegularExpression(pattern: DeviceConst.urlPattern, options: []) else { return }
        
        let NSText: NSString = text as NSString
        let matches = linkPattern.matches(in: text, options: [], range: NSRange(location: 0, length: NSText.length))
        for match in matches {
            let matchRange = match.range(at: 0)
            let urlString = NSText.substring(with: matchRange)
            guard let linkUrlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
            addLink(to: URL(string: NSString(format: "link:%@", linkUrlString) as String ), with: matchRange)
        }
    }
    
    func highlightEmailadress() {
        guard let text = self.text, let NSText = self.text as NSString? else { return }
        let adress = try? NSRegularExpression(pattern: DeviceConst.emailadressPattern, options: [])
        let matches = adress!.matches(in: text, options: [], range: NSRange(location: 0, length: NSText.length))
        
        for match in matches {
            let matchRange = match.range(at: 0)
            let adressString = NSText.substring(with: matchRange)
            addLink(to: URL(string: NSString(format: "mailAdress:%@", adressString) as String ), with: matchRange)
        }
    }
    
    func highlightUserLink() {
        
    }
}

extension LinkableTextField: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if let hashtagRange = url.absoluteString.range(of: "hashtag:"),
            let tagString = url.absoluteString[hashtagRange.upperBound...].removingPercentEncoding {
            RxBus.shared.post(event: HashTagTapEvent(hashTag: tagString))
        }
        if let linkRange = url.absoluteString.range(of: "link:"),
            let urlString = url.absoluteString[linkRange.upperBound...].removingPercentEncoding,
            let linkUrl = URL(string: urlString) {
            RxBus.shared.post(event: UrlLinkTapEvent(url: linkUrl))
        }
        if let adressRange = url.absoluteString.range(of: "mailAdress:") {
            let adressString = url.absoluteString[adressRange.upperBound...]
            RxBus.shared.post(event: MailAdressTapEvent(mailAdress: String(adressString)))
        }
    }
}
