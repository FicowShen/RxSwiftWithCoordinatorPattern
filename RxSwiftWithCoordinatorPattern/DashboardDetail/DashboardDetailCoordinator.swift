import Foundation
import RxSwift

final class DashboardDetailCoordinator: RootViewCoordinator {
    var childCoordinators: [Coordinator] = []

    var rootViewController: UIViewController {
        return presenter
    }

    let showDashboard = PublishSubject<Void>()

    private let presenter: UINavigationController
    private let dashboardModel: DashboardModel
    private let disposeBag = DisposeBag()

    init(dashboardModel: DashboardModel, presenter: UINavigationController) {
        self.dashboardModel = dashboardModel
        self.presenter = presenter
    }

    func start() {
        let detail = DashboardDetailViewController.loadFromMainStoryboard() as! DashboardDetailViewController
        detail.model = dashboardModel
        detail.showDashboard.subscribe { [weak self] in
            self?.showDashboardPage()
            }.disposed(by: disposeBag)
        presenter.pushViewController(detail, animated: true)
    }

    private func showDashboardPage() {
        presenter.popViewController(animated: true)
        showDashboard.onCompleted()
    }
}
