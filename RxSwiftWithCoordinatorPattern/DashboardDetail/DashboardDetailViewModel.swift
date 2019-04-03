import Foundation
import RxSwift
import RxCocoa

class DashboardDetailViewModel {

    private let model: DashboardModel
    let modelDescription: Driver<String>
    let items: BehaviorSubject<[(key: String, value: CustomStringConvertible)]>

    private var rawItems: [(key: String, value: CustomStringConvertible)]

    var updatedModel: DashboardModel? {
        switch model {
        case is DashboardUserModel:
            guard let gender = DashboardUserModel.Gender(rawValue: rawItems[2].value.description) else { return nil }
            return DashboardUserModel(firstName: rawItems[0].value.description, lastName: rawItems[1].value.description, gender: gender)
        case let newModel as DashboardEventModel:
            guard let priority = EventPriority(rawValue: rawItems[1].value.description) else { return nil }
            return DashboardEventModel(name: rawItems[0].value.description, time: rawItems[2].value.description, priority: priority, id: newModel.id)
        default:
            break
        }
        assertionFailure()
        return nil
    }

    init(model: DashboardModel) {
        self.model = model

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
