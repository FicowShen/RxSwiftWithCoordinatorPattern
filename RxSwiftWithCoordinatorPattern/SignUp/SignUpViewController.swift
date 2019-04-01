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

    private let viewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        showLoginPageButton.rx.tap
            .subscribe { [weak self] _ in
                self?.showLoginPage.onCompleted()
            }
            .disposed(by: disposeBag)
        signUpButton.rx.tap
            .subscribe { [weak self] _ in
                self?.signUp()
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

        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }

    private func signUp() {
        ToastView.shared.show()

        viewModel.signUp(account: accountInput.text, password: passwordInput.text)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (message) in
                ToastView.shared.hide()
                UIViewController.showAlert(msg: message)
                delay(seconds: TimeInterval(Constants.AlertDisplayDuration), block: {
                    self?.showLoginPage.onCompleted()
                })
            }) { (error) in
                ToastView.shared.hide()
                UIViewController.showAlert(msg: error.localizedDescription)
        }.disposed(by: disposeBag)
    }

}
