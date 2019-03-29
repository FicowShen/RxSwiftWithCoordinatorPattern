import UIKit

class DashboardModel {}

class DashboardUserModel: DashboardModel {

    enum Gender {
        case male
        case female

        var string: String {
            switch self {
            case .male:
                return "男"
            case .female:
                return "女"
            }
        }

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

enum EventPriority {
    case low
    case normal
    case high

    var string: String {
        switch self {
        case .low:
            return "低"
        case .normal:
            return "中"
        case .high:
            return "高"
        }
    }

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

