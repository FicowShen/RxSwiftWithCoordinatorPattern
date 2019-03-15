import UIKit
import RxSwift

final class SignUpCoordinator: RootViewCoordinator {

    var rootViewController: UIViewController {
        return presenter
    }

    var childCoordinators: [Coordinator] = []

    var displayCompletion = PublishSubject<Void>()

    private let presenter: UINavigationController
    private let disposeBag = DisposeBag()

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let signUpPage = SignUpViewController.loadFromMainStoryboard() as! SignUpViewController
        signUpPage.showLoginPage.subscribe { [weak self] in
            self?.showLoginPage()
            }.disposed(by: disposeBag)
        presenter.pushViewController(signUpPage, animated: true)
    }

    func showLoginPage() {
        self.presenter.popViewController(animated: true)
        displayCompletion.onCompleted()
    }

}

