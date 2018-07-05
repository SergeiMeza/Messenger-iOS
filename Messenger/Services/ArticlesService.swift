
import Foundation
import Firebase
import ObjectMapper
import SwiftyJSON
import Moya
import GameKit
import RealmSwift

struct ArticlesService {
    
    func getArticles(paginate: Bool, lastValue: Any? = nil, completion: @escaping ((Result<(articles:[Article], lastValue: Any?)>)->Void)) {
        
        #if DEBUG
//        generateSampleArticles()
        #endif
        
        let path = DeviceConst.firebaseDatabaseRootURL.appendingPathComponent("ARTICLES")
        Service.queryDatabase(path: path, paginate: paginate, child: "reverse_timestamp", lastValue: lastValue) { result in
            switch result {
            case .success(let snapshot):
                guard let value = snapshot?.value as? [String: Any] else {
                    snapshot == nil ? completion(Result.success(([], nil))) : completion(Result.error(NetworkError(statusCode: 404)))
                    return
                }
                var articles = Mapper<Article>().mapArray(JSONArray: value.compactMap({ $0.value as? [String:Any] }))
                articles.sort { $0.timestamp > $1.timestamp }
                completion(Result.success((articles, articles.last?.reverseTimestamp)))
            case .error(let error):
                completion(Result.error(error))
            }
        }
    }
    
    func show(objectId: String, completion: ((Result<Article>) -> Void)? = nil) {
        
        #if DEBUG
        generateSampleArticle(objectId: objectId)
        #endif
        
     let path = DeviceConst.firebaseDatabaseRootURL.appendingPathComponent("ARTICLE/\(objectId)")
        Service.show(path: path) { (value: [String: Any]?, error: Error?) in
            if let error = error {
                completion?(Result.error(error))
                return
            }
            guard let value = value, let article = Mapper<Article>().map(JSON: value) else {
                completion?(Result.error(NetworkError(statusCode: 500)))
                return
            }
            completion?(Result.success(article))
        }
    }
    
    func generateSampleArticle(objectId: String) {
        let article = FirebaseObject.init(path: "ARTICLE")
        article.objectId = objectId
        let date = Date()
        article["timestamp"] = date.timestamp
        article["reverse_timestamp"] = -date.timestamp
        article["id"] = 1
        article["title"] = "【イヴ・サンローラン】どれにする？yslリップの人気ラインナップを全部見せ♡"
        article["abstract"] = "イヴ・サンローランのリップはいつも新製品が発売される度に、デパートに朝から行列ができるほど人気が高いですよね！\r\n\r\n使用感の良さやパッケージの可愛さなど、人気が高いのにもちゃんと理由があるんです♡\r\n\r\nイヴ・サンローランのリップの中でも、特に人気の高いラインナップを全てご紹介していきます♡"
        article["thumb_url"] = "https://s3-ap-northeast-1.amazonaws.com/lips-production/image/8ef564898cf7a48b47412ee4-1526277532.png"
        article["author"] = [
            "name": "Sergei Meza",
            "profile_img": "https://s3-ap-northeast-1.amazonaws.com/lips-production/image/image2017-12-10-199-374-143.png"
        ]
        article["content"] = [
            [
                "id": 13079,
                "code": "sub-title",
                "order": 0,
                "content": ["title": "人気のイヴ・サンローランのリップが欲しい♡"]
            ],
            [
                "id": 13080,
                "code": "image",
                "order": 1,
                "content": [
                    "text": "",
                    "image_url": "https://s3-ap-northeast-1.amazonaws.com/lips-production/admin/article_item13080-2018/05/14-31.png",
                    "width": 2436,
                    "height": 1624
                ]
            ],
            [
                "id": 13081,
                "code": "text",
                "order": 2,
                "content": [
                    "text": "イヴ・サンローランのリップといえば、とにかく見た目の可愛さや高級感があって持っているだけでもテンションが上がるアイテムですよね♡\n\nそして可愛さだけでなく発色や色持ちの良さ・塗り心地の良さなど、使用感もとっても優秀なんです！\n\nだからイヴ・サンローランのリップは、新製品が発売される度に発売日にはデパートに朝から長蛇の列が。\n今回はそんな大人気の秘密を探っていきましょう！"
                ]
            ]
        ]
        article.saveInBackground()
    }
    
    func generateSampleArticles() {
//        let randomGenerator = GKRandomDistribution.init(lowestValue: 0, highestValue: 4)
        for index in 1...100 {
            let article = FirebaseObject.init(path: "ARTICLES")
            article[DeviceConst.object_id] = FirebaseObject.autoId()
            let date = Date()
            article["timestamp"] = date.timestamp
            article["reverse_timestamp"] = -date.timestamp
            article["id"] = index
            article["title"] = "title_\(index)"
            article.saveInBackground()
        }
    }
}
