import UIKit
import RxSwift
import RxCocoa

final class SignUpCoordinator: RootViewCoordinator {

    var rootViewController: UIViewController {
        return presenter
    }

    var childCoordinators: [Coordinator] = []

    private let showLoginPageSubject = PublishSubject<Void>()
    var showLoginPage: Driver<Void> {
        return showLoginPageSubject.asDriverOnErrorJustComplete()
    }

    private let presenter: UINavigationController
    private let disposeBag = DisposeBag()

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let signUpPage = SignUpViewController.loadFromMainStoryboard() as! SignUpViewController
        signUpPage.showLoginPage.subscribe { [weak self] in
            self?.showLoginPageSubject.onNext(())
            }.disposed(by: disposeBag)
        presenter.pushViewController(signUpPage, animated: true)
    }

}

