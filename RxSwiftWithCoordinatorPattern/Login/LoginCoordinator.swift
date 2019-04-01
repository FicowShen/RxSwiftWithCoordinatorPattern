import UIKit
import RxSwift

final class LoginCoordinator: RootViewCoordinator {
    var rootViewController: UIViewController {
        return presenter
    }

    var childCoordinators: [Coordinator] = []

    let showDashboard = PublishSubject<Void>()

    private let presenter: UINavigationController
    private var loginPresenter: UINavigationController!
    private let disposeBag = DisposeBag()

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let loginPage = LoginViewController.loadFromMainStoryboard() as! LoginViewController
        loginPage.showDashboard.subscribe { [weak self] in
            self?.showDashboardPage()
            }.disposed(by: disposeBag)
        loginPage.showSignUp.subscribe { [weak self] (_) in
            self?.showSignUpPage()
            }.disposed(by: disposeBag)

        loginPresenter = UINavigationController(rootViewController: loginPage)
        presenter.present(loginPresenter, animated: true, completion: nil)
    }

    private func showDashboardPage() {
        self.loginPresenter.dismiss(animated: true, completion: nil)
        loginPresenter = nil
        childCoordinators.removeAll()
        showDashboard.onCompleted()
    }

    private func showSignUpPage() {
        let coordinator = SignUpCoordinator(presenter: self.loginPresenter)
        coordinator.showLoginPage.subscribe { [weak self] in
            self?.showLoginPage()
            }.disposed(by: disposeBag)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }

    private func showLoginPage() {
        self.loginPresenter.popViewController(animated: true)
        childCoordinators.removeAll()
    }

}
