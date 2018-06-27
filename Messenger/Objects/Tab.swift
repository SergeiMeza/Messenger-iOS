//
//  Tab.swift
//  LIPS
//
//  Created by ShinokiRyosei on 2017/07/11.
//  Copyright © 2017年 AppBrew. All rights reserved.
//

import ObjectMapper

class Tab: NSObject, Mappable {
    var id: Int = 0
    var title: String = ""
    var codeString: String = ""
    var bannerTypeString: String = ""
    var supplementInfo: String = ""
    var isPrimary: Bool = false
    
    var type: TabType {
        guard let type = TabType(rawValue: codeString) else {
            return .default
        }
        return type
    }
    
    var bannerType: TabBannerType {
        guard let type = TabBannerType(rawValue: bannerTypeString) else {
            return .nothing
        }
        return type
    }
    
    enum TabType: String {
        case popular = "popular_teachers"
        case mySpace = "myspace"
        case discover = "timeline_posts"
        case latest = "latest_teachers"
        case skype = "skype_teachers"
        case event = "events"
        case article = "articles"
        case `default` = "default"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.title <- map["title"]
        self.codeString <- map["code"]
        self.bannerTypeString <- map["banner_type"]
        self.supplementInfo <- map["supplement_info"]
        self.isPrimary <- map["is_primary"]
    }
    
    func isEqualTo(_ tab: Tab) -> Bool {
        return title == tab.title && type == tab.type && supplementInfo == tab.supplementInfo
    }
}
