
import Foundation
import IGListKit

class UserArray: NSObject, ListDiffable {
    let users: [RealmUser]
    
    init(users: [RealmUser]) {
        self.users = users
    }
    
    var id: String {
        if users.count > 0 {
            let index = max(5, min(5, users.count))
            let subarray = users[0...index]
            let customKey = subarray.reduce("") { "\($0)-\($1.objectId)" }
            return "UserArray-\(customKey)-\(users.count)"
        } else {
            return "UserArray-\(users.count)"
        }
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? UserArray else { return false }
        if object === self {
            return true
        } else if object.id == self.id {
            return true
        }
        return false
    }
}
