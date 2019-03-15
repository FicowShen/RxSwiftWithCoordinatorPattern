import UIKit
import RxCocoa
import RxSwift

class SignUpViewController: BaseViewController {

    @IBOutlet weak var accountInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var showLoginPageButton: UIButton!

    struct MinimumLength {
        static let account = 8
        static let password = 6
    }

    let showLoginPage = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()

        showLoginPageButton.rx.tap
            .subscribe { [weak self] _ in
                self?.showLoginPage.onCompleted()
            }
            .disposed(by: disposeBag)

        let usernameValid = accountInput.rx.text.orEmpty
            .map { $0.count >= MinimumLength.account }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default

        let passwordValid = passwordInput.rx.text.orEmpty
            .map { $0.count >= MinimumLength.password }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        usernameValid
            .bind(to: passwordInput.rx.isEnabled)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: signUpButton.rx.isEnabledStyle)
            .disposed(by: disposeBag)
    }

}
