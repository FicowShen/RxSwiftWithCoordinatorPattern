import UIKit

protocol DashboardPresenter: class {
    func showDashboard()
}

final class DashboardCoordinator: RootViewCoordinator {

    var rootViewController: UIViewController {
        return presenter
    }

    var childCoordinators: [Coordinator] = []

    private let presenter: UINavigationController

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let dashboard = DashboardViewController.loadFromMainStoryboard()
        presenter.pushViewController(dashboard, animated: false)
    }

    func showLoginPage() {
        let loginPage = LoginViewController.loadFromMainStoryboard()
        presenter.present(loginPage, animated: true, completion: nil)
    }

}
