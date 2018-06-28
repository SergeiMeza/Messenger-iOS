import RxSwift

protocol BusEvent {
    static var name: String { get }
}

extension BusEvent {
    static var name: String {
        return "\(self)"
    }
}

final class RxBus {
    
    public static let shared = RxBus()
    
    private typealias EventName = String
    private var subjects = [EventName: Any]()
    
    private init() {
        // No instances.
    }
    
    func asObservable<T: BusEvent>(event: T.Type) -> Observable<T> {
        if subjects[event.name] == nil {
            subjects[event.name] = PublishSubject<T>()
        }
        return subjects[event.name] as! PublishSubject<T>
    }
    
    func post<T: BusEvent>(event: T) {
        let eventName = "\(type(of: event))"
        (subjects[eventName] as? PublishSubject<T>)?.onNext(event)
    }
    
    func remove<T: BusEvent>(event: T.Type) {
        subjects.removeValue(forKey: event.name)
    }
}
