import UIKit

class DashboardModel {
    struct NotificationName {
        static let modelUpdated = Notification.Name(rawValue: "DashboardModelNotificationName_modelUpdated")
    }
}

class DashboardUserModel: DashboardModel {

    enum Gender: String, CustomStringConvertible {
        var description: String {
            return rawValue
        }

        case male
        case female

        var color: UIColor {
            switch self {
            case .male:
                return .blue
            case .female:
                return .red
            }
        }
    }

    let firstName: String
    let lastName: String
    let gender: Gender

    init(firstName: String, lastName: String, gender: Gender) {
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        super.init()
    }
}

enum EventPriority: String, CustomStringConvertible {
    var description: String {
        return rawValue
    }

    case low
    case normal
    case high

    var color: UIColor {
        switch self {
        case .low:
            return .gray
        case .normal:
            return .darkGray
        case .high:
            return .red
        }
    }
}

class DashboardEventModel: DashboardModel {
    let id: String
    let name: String
    let time: String
    let priority: EventPriority
    init(name: String, time: String, priority: EventPriority, id: String = UUID().uuidString) {
        self.id = id
        self.name = name
        self.time = time
        self.priority = priority
        super.init()
    }
}


