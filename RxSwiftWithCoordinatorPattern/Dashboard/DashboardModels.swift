import UIKit

class DashboardModel {}

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
    let name: String
    let time: String
    let priority: EventPriority
    init(name: String, time: String, priority: EventPriority) {
        self.name = name
        self.time = time
        self.priority = priority
        super.init()
    }
}


