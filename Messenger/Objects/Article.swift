import UIKit
import IGListKit
import ObjectMapper
import RealmSwift

class Article: NSObject, Mappable, ListDiffable {
    var id: Int = 0
    var objectId = ""
    var title: String = ""
    var abstract: String = ""
    var updatedAt: String = ""
    var viewCount: Int = 0
    var thumbUrl: String = ""
    var authorName: String = ""
    var authorImage: String = ""
    var timestamp = 0.0
    var reverseTimestamp = 0.0
    
    var articleItems: [ArticleItem] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.objectId <- map["object_id"]
        self.title <- map["title"]
        self.abstract <- map["abstract"]
        self.updatedAt <- map["updated_at"]
        self.viewCount <- map["view_count"]
        self.thumbUrl <- map["thumb_url"]
        self.authorName <- map["author.name"]
        self.authorImage <- map["author.profile_img"]
        self.articleItems <- map["content"]
        self.timestamp <- map["timestamp"]
        self.reverseTimestamp <- map["reverse_timestamp"]
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return objectId as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Article else { return false }
        if self === object {
            return true
        } else if objectId == object.objectId {
            return true
        }
        return false
    }
}
