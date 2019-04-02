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

        let viewModel = SignUpViewModel(
            input: (
                username: accountInput.rx.text.orEmpty.asDriver(),
                password: passwordInput.rx.text.orEmpty.asDriver(),
                signUpTaps: signUpButton.rx.tap.asSignal()
            ),
            dependency: (
                API: GitHubDefaultAPI.sharedAPI,
                validationService: GitHubDefaultValidationService.sharedValidationService,
                wireframe: DefaultWireframe.shared
            )
        )

        showLoginPageButton.rx.tap
            .subscribe { [weak self] _ in
                self?.showLoginPage.onCompleted()
            }.disposed(by: disposeBag)

        viewModel.signUpEnabled
            .drive(onNext: { [weak self] valid  in
                self?.signUpButton.isEnabledStyle = valid
            }).disposed(by: disposeBag)

        viewModel.signingUp
            .drive(onNext: { signingUp  in
                signingUp
                    ? ToastView.shared.show()
                    : ToastView.shared.hide()
            }).disposed(by: disposeBag)

        viewModel.signedUp
            .drive(onNext: { [weak self] signedUp  in
                guard signedUp else { return }
                self?.showLoginPage.onCompleted()
            }).disposed(by: disposeBag)

        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }

}
