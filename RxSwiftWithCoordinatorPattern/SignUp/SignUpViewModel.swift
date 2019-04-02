import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {

    let signUpEnabled: Driver<Bool>

    let signedUp: Driver<Bool>

    let signingUp: Driver<Bool>

    init(input: (
        username: Driver<String>,
        password: Driver<String>,
        signUpTaps: Signal<()>
        ),
         dependency: (
        API: GitHubAPI,
        validationService: GitHubValidationService,
        wireframe: Wireframe
        )
        ) {

        let API = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe

        let validatedUsername = input.username.flatMapLatest { (username) in
            return validationService.validateUsername(username).asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
        }
        let validatePassword = input.password.map { (password) in
            return validationService.validatePassword(password)
        }

        let signingUp = ActivityIndicator()
        self.signingUp = signingUp.asDriver()

        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { (username: $0, password: $1) }

        signedUp = input.signUpTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return API.signup(pair.username, password: pair.password)
                    .trackActivity(signingUp)
                    .asDriver(onErrorJustReturn: false)
            }
            .flatMapLatest { signedUp -> Driver<Bool> in
                let message = signedUp ? "Mock: Signed up to GitHub." : "Mock: Sign up to GitHub failed"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    // propagate original value
                    .map { _ in
                        signedUp
                    }
                    .asDriver(onErrorJustReturn: false)
        }


        signUpEnabled = Driver.combineLatest(
            validatedUsername,
            validatePassword,
            signingUp
        )   { username, password, signingUp in
            username.isValid &&
                password.isValid &&
                !signingUp
            }
            .distinctUntilChanged()

    }
}
