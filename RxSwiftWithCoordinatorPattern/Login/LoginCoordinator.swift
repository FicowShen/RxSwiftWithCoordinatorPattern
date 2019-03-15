import UIKit
import RxSwift

final class LoginCoordinator: RootViewCoordinator {

    var rootViewController: UIViewController {
        return presenter
    }

    var childCoordinators: [Coordinator] = []

    let displayCompletion = PublishSubject<Void>()

    private let presenter: UINavigationController
    private var subPresenter: UINavigationController!
    private let disposeBag = DisposeBag()

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let loginPage = LoginViewController.loadFromMainStoryboard() as! LoginViewController
        loginPage.showDashboard.subscribe { [weak self] in
            self?.showDashboard()
            }.disposed(by: disposeBag)
        loginPage.showSignUp.subscribe { [weak self] in
            self?.showSignUpPage()
            }.disposed(by: disposeBag)
        subPresenter = UINavigationController(rootViewController: loginPage)
        presenter.present(subPresenter, animated: true, completion: nil)
    }

    private func showDashboard() {
        self.subPresenter.dismiss(animated: true, completion: nil)
        subPresenter = nil
        childCoordinators.removeAll()
        displayCompletion.onCompleted()
    }

    private func showSignUpPage() {
        let coordinator = SignUpCoordinator(presenter: self.subPresenter)
        coordinator.displayCompletion.subscribe { [weak self] in
            self?.childCoordinators.removeAll()
        }.disposed(by: disposeBag)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }

}
