import UIKit
import RxSwift

final class LoginCoordinator: RootViewCoordinator {
    var rootViewController: UIViewController {
        return presenter
    }

    var childCoordinators: [Coordinator] = []

    let showDashboard = PublishSubject<Void>()

    private let presenter: UINavigationController
    private var subPresenter: UINavigationController!
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

        subPresenter = UINavigationController(rootViewController: loginPage)
        presenter.present(subPresenter, animated: true, completion: nil)
    }

    private func showDashboardPage() {
        self.subPresenter.dismiss(animated: true, completion: nil)
        subPresenter = nil
        childCoordinators.removeAll()
        showDashboard.onCompleted()
    }

    private func showSignUpPage() {
        let coordinator = SignUpCoordinator(presenter: self.subPresenter)
        coordinator.showLoginPage.subscribe { [weak self] in
            self?.showLoginPage()
            }.disposed(by: disposeBag)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }

    private func showLoginPage() {
        self.subPresenter.popViewController(animated: true)
        childCoordinators.removeAll()
    }

}
