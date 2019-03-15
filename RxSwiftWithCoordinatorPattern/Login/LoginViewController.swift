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

//        signInButton.rx.tap
//            .subscribe { [weak self] _ in
//                self?.showDashboard.onCompleted()
//            }
//            .disposed(by: disposeBag)
//
//        showSignUpButton.rx.tap
//            .subscribe { [weak self] _ in
//                self?.showSignUp.onCompleted()
//            }
//            .disposed(by: disposeBag)
//
//        let usernameValid = accountInput.rx.text.orEmpty
//            .map { $0.count >= MinimumLength.account }
//            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default
//
//        let passwordValid = passwordInput.rx.text.orEmpty
//            .map { $0.count >= MinimumLength.password }
//            .share(replay: 1)
//
//        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
//            .share(replay: 1)
//
//        usernameValid
//            .bind(to: passwordInput.rx.isEnabled)
//            .disposed(by: disposeBag)
//
//        everythingValid
//            .bind(to: signInButton.rx.isEnabledStyle)
//            .disposed(by: disposeBag)

        let viewModel = LoginViewModel(
            input: (
                username: accountInput.rx.text.orEmpty.asDriver(),
                password: passwordInput.rx.text.orEmpty.asDriver(),
                loginTaps: signInButton.rx.tap.asSignal()
            ),
            dependency: (
                API: GitHubDefaultAPI.sharedAPI,
                validationService: GitHubDefaultValidationService.sharedValidationService,
                wireframe: DefaultWireframe.shared
            )
        )

        viewModel.signupEnabled
            .drive(onNext: { [weak self] valid  in
                self?.signInButton.isEnabled = valid
                self?.signInButton.alpha = valid ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)

//        viewModel.validatedUsername
//            .drive(accountInput.rx.validationResult)
//            .disposed(by: disposeBag)
//
//        viewModel.validatedPassword
//            .drive(passwordInput.rx.validationResult)
//            .disposed(by: disposeBag)
//
//        viewModel.signingIn
//            .drive(signInButton.rx.isAnimating)
//            .disposed(by: disposeBag)

        viewModel.signedIn
            .drive(onNext: { signedIn in
                print("User signed in \(signedIn)")
            })
            .disposed(by: disposeBag)

        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
