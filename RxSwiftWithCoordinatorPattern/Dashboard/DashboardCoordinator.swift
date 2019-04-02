import UIKit
import RxSwift

protocol DashboardPresenter: class {
    func showDashboard()
}

final class DashboardCoordinator: RootViewCoordinator {

    var rootViewController: UIViewController {
        return presenter
    }

    var childCoordinators: [Coordinator] = []

    private let presenter: UINavigationController
    private let disposeBag = DisposeBag()

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let dashboard = DashboardViewController.loadFromMainStoryboard() as! DashboardViewController
        dashboard.showLoginPage.subscribe { [weak self] _ in
            self?.showLoginPage()
            }.disposed(by: disposeBag)

        dashboard.showDetailPage.subscribe { [weak self] event in
            switch event {
            case .next(let dashboardModel):
                self?.showDetailPage(dashboardModel: dashboardModel)
            default:
                break
            }
            }.disposed(by: disposeBag)
        presenter.pushViewController(dashboard, animated: false)
    }

    private func showLoginPage() {
        let coordinator = LoginCoordinator(presenter: presenter)
        coordinator.showDashboard.subscribe { [weak self] _ in
            self?.goBackToDashboard()
            }.disposed(by: disposeBag)
        coordinator.start()
        childCoordinators.append(coordinator)
    }

    private func showDetailPage(dashboardModel: DashboardModel) {
        let coordinator = DashboardDetailCoordinator(dashboardModel: dashboardModel, presenter: presenter)
        coordinator.showDashboard.subscribe { [weak self] _ in
            self?.goBackToDashboard()
            }.disposed(by: disposeBag)
        coordinator.start()
        childCoordinators.append(coordinator)
    }

    private func goBackToDashboard() {
        childCoordinators.removeAll()
    }

}
