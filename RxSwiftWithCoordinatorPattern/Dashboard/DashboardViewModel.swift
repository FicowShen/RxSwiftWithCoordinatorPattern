import Foundation
import RxSwift

class DashboardViewModel {

    let items: Observable<[SectionModel<String, DashboardModel>]>

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

    init() {
        let userInfo = SectionModel(model: "User Info", items: [
            DashboardUserModel(firstName: "Ficow", lastName: "Shen", gender: .male) as DashboardModel])
        let punchIn = DashboardEventModel(name: "Punch In", time: "2018/03/19 09:00", priority: .normal)
        let shareMeeting = DashboardEventModel(name: "Share Meeting", time: "2018/03/19 11:00", priority: .high)
        let haveLaunch = DashboardEventModel(name: "Have Launch", time: "2018/03/19 12:00", priority: .low)
        let events = SectionModel(model: "Events", items: [punchIn, shareMeeting, haveLaunch] as [DashboardModel])
        items = Observable.just([userInfo, events])
    }
}
