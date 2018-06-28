
import Foundation
import IGListKit

class ArticleArray: NSObject, ListDiffable {
    let articles: [Article]
    
    init(articles: [Article]) {
        self.articles = articles
    }
    
    var id: String {
        if articles.count > 0 {
            let index = max(10, min(10, articles.count))
            let subarray = articles[0...index]
            let customKey = subarray.reduce("") { "\($0)-\($1.objectId)" }
            return "UserArray-\(customKey)-\(articles.count)"
        } else {
            return "UserArray-\(articles.count)"
        }
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ArticleArray else { return false }
        if object === self {
            return true
        } else if object.id == self.id {
            return true
        }
        return false
    }
}
