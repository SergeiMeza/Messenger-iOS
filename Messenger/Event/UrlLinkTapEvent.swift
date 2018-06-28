import Foundation
import RxCocoa
import RxSwift

struct UrlLinkTapEvent: BusEvent {
    let url: URL
}
