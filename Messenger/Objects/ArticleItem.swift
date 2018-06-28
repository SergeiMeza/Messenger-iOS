import UIKit
import ObjectMapper

struct ArticleItem: Mappable {
    var itemId: Int = 0
    private var typeString: String = ""
    var image: ArticleImage?
    var text: ArticleText?
    var subTitle: ArticleSubTitle?
    var quotation: ArticleQuotation?
    var subSubTitle: ArticleSubSubTitle?
    var linkImage: ArticleLinkImage?
    
    var type: ItemType {
        guard let type = ItemType(rawValue: typeString) else {
            return .undefined
        }
        return type
    }
    
    enum ItemType: String {
        case image = "image"
        case text = "text"
        case subTitle = "sub-title"
        case quotation = "quotation"
        case subSubTitle = "sub-sub-title"
        case linkImage = "link-image"
        case undefined = ""
    }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.itemId <- map["id"]
        self.typeString <- map["code"]
        switch self.typeString {
        case "sub-title":
            self.subTitle <- map["content"]
        case "text":
            self.text <- map["content"]
        case "quotation":
            self.quotation <- map["content"]
        case "image":
            self.image <- map["content"]
        case "link-image":
            self.linkImage <- map["content"]
        case "sub-sub-title":
            self.subSubTitle <- map["content"]
        default:
            return
        }
    }
    
    struct ArticleSubTitle: Mappable {
        var subTitle: String = ""
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.subTitle <- map["title"]
        }
    }
    
    struct ArticleText: Mappable {
        var text: String = ""
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.text <- map["text"]
        }
    }
    
    struct ArticleQuotation: Mappable {
        var text: String = ""
        var url: String = ""
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.text <- map["text"]
            self.url <- map["url"]
        }
    }
    
    struct ArticleImage: Mappable {
        var text: String = ""
        var imageUrl: String = ""
        var width: Int = 1
        var height: Int = 1
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.text <- map["text"]
            self.imageUrl <- map["image_url"]
            self.width <- map["width"]
            self.height <- map["height"]
        }
    }
    
    struct ArticleSubSubTitle: Mappable {
        var title: String = ""
        
        init?(map: Map) {}
        
        mutating func mapping(map: Map) {
            self.title <- map["title"]
        }
    }
    
    struct ArticleLinkImage: Mappable {
        var referenceUrl: String = ""
        var imageUrl: String = ""
        var width: Int = 1
        var height: Int = 1
        
        init?(map: Map) {}
        
        mutating func mapping(map: Map) {
            self.referenceUrl <- map["url"]
            self.imageUrl <- map["image_url"]
            self.width <- map["width"]
            self.height <- map["height"]
        }
    }
    
}
