import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let searchHistory = DefaultsKey<[String]?>("searchHistory")
}

struct SearchHistory {
    private static let maxCount: Int = 5
    private(set) var keywords: [String] = [] {
        didSet {
            Defaults[.searchHistory] = keywords
        }
    }
    
    init() {
        if let searchHistoryKeywords = Defaults[.searchHistory] {
            keywords = searchHistoryKeywords
        }
    }
    
    mutating func add(keyword: String) {
        guard !keyword.isEmpty else { return }
        if let i = keywords.index(of: keyword) {
            keywords.remove(at: i)
        }
        keywords.insert(keyword, at: 0)
        keywords = keywords.prefix(SearchHistory.maxCount).map { $0 }
    }
    
    mutating func delete(at index: Int?) {
        if let deleteIndex = index, deleteIndex < keywords.count {
            keywords.remove(at: deleteIndex)
        } else {
            keywords.removeAll()
        }
    }
}
