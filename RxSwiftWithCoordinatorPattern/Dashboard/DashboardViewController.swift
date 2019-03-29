import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!

    let showLoginPage = PublishSubject<Void>()

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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Dashboard"

        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: DashboardUserTableViewCell.ID,
                                 bundle: nil),
                           forCellReuseIdentifier: DashboardUserTableViewCell.ID)
        tableView.register(UINib(nibName: DashboardEventTableViewCell.ID,
                                 bundle: nil),
                           forCellReuseIdentifier: DashboardEventTableViewCell.ID)

        let dataSource = self.dataSource

        DashboardViewModel().items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { pair in
                DefaultWireframe.presentAlert("Tapped `\(pair.1)` @ \(pair.0)")
            })
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        logoutButton.rx.tap
            .subscribe { [weak self] _ in
                self?.showLoginPage.onNext(())
            }
            .disposed(by: disposeBag)

    }

}
