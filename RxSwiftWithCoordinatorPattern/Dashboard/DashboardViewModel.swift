import Foundation
import RxSwift

class DashboardViewModel {

    let items: BehaviorSubject<[SectionModel<String, DashboardModel>]>

    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, DashboardModel>>(
        configureCell: { (_, tv, indexPath, element) in
            switch element {
            case let user as DashboardUserModel:
                let cell = tv.dequeueReusableCell(withIdentifier: DashboardUserTableViewCell.ID) as! DashboardUserTableViewCell
                cell.model = user
                return cell
            case let event as DashboardEventModel:
                let cell = tv.dequeueReusableCell(withIdentifier: DashboardEventTableViewCell.ID) as! DashboardEventTableViewCell
                cell.model = event
                return cell
            default:
                fatalError()
            }
    },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
    }
    )

    private var userInfoModel: DashboardUserModel
    private var eventsModel: [DashboardEventModel]

    init() {
        userInfoModel = DashboardUserModel(firstName: "Ficow", lastName: "Shen", gender: .male)
        let userInfo = SectionModel(model: "User Info", items: [userInfoModel as DashboardModel])

        let punchIn = DashboardEventModel(name: "Punch In", time: "2018/03/19 09:00", priority: .normal)
        let shareMeeting = DashboardEventModel(name: "Share Meeting", time: "2018/03/19 11:00", priority: .high)
        let haveLaunch = DashboardEventModel(name: "Have Launch", time: "2018/03/19 12:00", priority: .low)
        eventsModel = [punchIn, shareMeeting, haveLaunch]

        let events = SectionModel(model: "Events", items: eventsModel as [DashboardModel])
        items = BehaviorSubject(value: [userInfo, events])
        NotificationCenter.default.addObserver(self, selector: #selector(self.dashboardModelDidUpdate(_:)), name: DashboardModel.NotificationName.modelUpdated, object: nil)
    }

    @objc
    private func dashboardModelDidUpdate(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let updatedModel = userInfo[String(describing: DashboardModel.self)] as? DashboardModel
            else { return }

        switch updatedModel {
        case let model as DashboardUserModel:
            userInfoModel = model
        case let model as DashboardEventModel:
            guard let index = eventsModel.firstIndex(where: { $0.id == model.id }) else { return }
            eventsModel[index] = model
        default:
            break
        }
        let userInfoSectionModel = SectionModel(model: "User Info", items: [userInfoModel as DashboardModel])
        let eventSectionModel = SectionModel(model: "Events", items: eventsModel as [DashboardModel])
        items.onNext([userInfoSectionModel, eventSectionModel])
    }
}
