import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!

    let showLoginPage = PublishSubject<Void>()
    let showDetailPage = PublishSubject<DashboardModel>()

    private var viewModel: DashboardViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Dashboard"

        logoutButton.layer.cornerRadius = 4
        logoutButton.layer.masksToBounds = true

        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: DashboardUserTableViewCell.ID, bundle: nil),
                           forCellReuseIdentifier: DashboardUserTableViewCell.ID)
        tableView.register(UINib(nibName: DashboardEventTableViewCell.ID, bundle: nil),
                           forCellReuseIdentifier: DashboardEventTableViewCell.ID)

        let viewModel = DashboardViewModel()
        self.viewModel = viewModel
        
        let dataSource = viewModel.dataSource

        viewModel.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { [weak self] pair in
                self?.tableView.deselectRow(at: pair.0, animated: true)
                self?.showDetailPage.onNext(pair.1)
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
