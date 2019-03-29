import UIKit
import RxSwift

final class AppCoordinator: RootViewCoordinator {

    var rootViewController: UIViewController {
        return navigationController
    }

    var childCoordinators: [Coordinator] = []

    private let window: UIWindow
    private let navigationController = UINavigationController()
    private var isUserLogin = true
    private let disposeBag = DisposeBag()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        isUserLogin ? showDashboard() : showLoginPage()
    }

    func showLoginPage() {
        let coordinator = LoginCoordinator(presenter: navigationController)
        coordinator.showDashboard.subscribe { [weak self] in
            self?.showDashboard()
        }.disposed(by: disposeBag)

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        coordinator.start()
        childCoordinators.append(coordinator)
    }

    func showDashboard() {
        childCoordinators.removeAll()
        let coordinator = DashboardCoordinator(presenter: navigationController)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
}
