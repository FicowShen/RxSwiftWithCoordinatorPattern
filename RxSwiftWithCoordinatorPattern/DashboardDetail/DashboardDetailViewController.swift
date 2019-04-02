import UIKit
import RxSwift
import RxCocoa

class DashboardDetailViewController: BaseViewController {

    var model: DashboardModel!

    @IBOutlet weak var tableView: UITableView!

    let showDashboard = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = DashboardDetailViewModel(model: model)
        viewModel.modelDescription.drive(self.rx.title).disposed(by: disposeBag)

        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: DashboardDetailTableViewCell.ID, bundle: nil), forCellReuseIdentifier: DashboardDetailTableViewCell.ID)

        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: DashboardDetailTableViewCell.ID)) { [unowned self] (row, item, cell) in
            guard let cell = cell as? DashboardDetailTableViewCell else { return }
            cell.textFieldValueUpdated
                .asDriver(onErrorJustReturn: "")
                .drive(onNext: { text in
                viewModel.updateItem(at: row, value: text)
            }).disposed(by: self.disposeBag)
            cell.label.text = item.key
            cell.textField.text = item.value.description
        }.disposed(by: disposeBag)

        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)

        showDashboard.subscribe { (_) in
            guard let updatedModel = viewModel.updatedModel else { return }
            let userInfo: [AnyHashable : Any] = [String(describing: DashboardModel.self) : updatedModel]
            NotificationCenter.default.post(name: DashboardModel.NotificationName.modelUpdated, object: nil, userInfo: userInfo)
        }.disposed(by: disposeBag)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        showDashboard.onCompleted()
    }

}
