import UIKit
import RxCocoa
import RxSwift

class LoginViewController: BaseViewController {

    @IBOutlet weak var accountInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var showSignUpButton: UIButton!

    let showDashboard = PublishSubject<Void>()
    let showSignUp = PublishSubject<Void>()

    struct MinimumLength {
        static let account = 8
        static let password = 6
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.rx.tap
            .subscribe { [weak self] _ in
                self?.showDashboard.onCompleted()
            }
            .disposed(by: disposeBag)

        showSignUpButton.rx.tap
            .subscribe { [weak self] _ in
                self?.showSignUp.onCompleted()
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
            .bind(to: signInButton.rx.isEnabledStyle)
            .disposed(by: disposeBag)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
