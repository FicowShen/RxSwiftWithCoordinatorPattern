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

        showSignUpButton.rx.tap
            .subscribe { [weak self] _ in
                self?.showSignUp.onNext(())
            }
            .disposed(by: disposeBag)

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

        viewModel.signinEnabled
            .drive(onNext: { [weak self] valid  in
                self?.signInButton.isEnabledStyle = valid
            })
            .disposed(by: disposeBag)

        viewModel.signingIn
            .drive(onNext: { signingIn  in
                signingIn
                    ? ToastView.shared.show()
                    : ToastView.shared.hide()
            }).disposed(by: disposeBag)

        viewModel.signedIn
            .drive(onNext: { [weak self] signedIn in
                if signedIn {
                    self?.showDashboard.onCompleted()
                }
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
