import Foundation
import ObjectMapper

struct SearchSuggestion: Mappable {
    private(set) var keyword: String = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        keyword <- map["keyword"]
    }
    
}
