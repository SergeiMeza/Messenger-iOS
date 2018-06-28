import UIKit
import IGListKit
import ObjectMapper
import RealmSwift

@objcMembers class Article: Object, Mappable, ListDiffable {
    dynamic var id: Int = 0
    dynamic var objectId = ""
    dynamic var title: String = ""
    dynamic var abstract: String = ""
    dynamic var updatedAt: String = ""
    dynamic var viewCount: Int = 0
    dynamic var thumbUrl: String = ""
    dynamic var authorName: String = ""
    dynamic var authorImage: String = ""
    dynamic var timestamp = 0.0
    dynamic var reverseTimestamp = 0.0
    
    var articleItems: [ArticleItem] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
//        print(log, map.JSON)
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
    
    override static func primaryKey() -> String? {
        return "objectId"
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
