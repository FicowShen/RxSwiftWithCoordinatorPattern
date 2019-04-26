import Foundation
import RxSwift
import RxCocoa

final class DashboardDetailCoordinator: RootViewCoordinator {
    var childCoordinators: [Coordinator] = []

    var rootViewController: UIViewController {
        return presenter
    }

    private let showDashboardSubject = PublishSubject<Void>()
    var showDashboard: Driver<Void> {
        return showDashboardSubject.asDriverOnErrorJustComplete()
    }

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
        showDashboardSubject.onNext(())
    }
}
