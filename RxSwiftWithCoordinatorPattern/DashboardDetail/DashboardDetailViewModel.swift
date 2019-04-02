import Foundation
import RxSwift
import RxCocoa

class DashboardDetailViewModel {

    let modelDescription: Driver<String>
    let items: BehaviorSubject<[(key: String, value: CustomStringConvertible)]>

    private var rawItems: [(key: String, value: CustomStringConvertible)]

    init(model: DashboardModel) {
        switch model {
        case let user as DashboardUserModel:
            modelDescription = Observable
                .just("User Info")
                .asDriver(onErrorJustReturn: "")
            rawItems = [("firstName", user.firstName),
                        ("lastName", user.lastName),
                        ("gender", user.gender)] as [(String, CustomStringConvertible)]
        case let event as DashboardEventModel:
            modelDescription = Observable
                .just("Event")
                .asDriver(onErrorJustReturn: "")
            rawItems = [("name", event.name),
                        ("priority", event.priority),
                        ("time", event.time)] as [(String, CustomStringConvertible)]
        default:
            modelDescription = Observable
                .just("")
                .asDriver(onErrorJustReturn: "")
            rawItems = []
            assertionFailure()
        }
        items = BehaviorSubject(value: rawItems)
    }

    func updateItem(at row: Int, value: CustomStringConvertible) {
        rawItems[row].value = value
        items.onNext(rawItems)
    }
}
