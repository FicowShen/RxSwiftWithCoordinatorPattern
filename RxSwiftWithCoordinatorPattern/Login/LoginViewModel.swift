import RxSwift
import RxCocoa

class LoginViewModel {
    //
    let validatedUsername: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>

    // Is signup button enabled
    let signinEnabled: Driver<Bool>

    // Has user signed in
    let signedIn: Driver<Bool>

    // Is signing process in progress
    let signingIn: Driver<Bool>

    // }

    init(
        input: (
        username: Driver<String>,
        password: Driver<String>,
        loginTaps: Signal<()>
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

        /**
         Notice how no subscribe call is being made.
         Everything is just a definition.

         Pure transformation of input sequences to output sequences.

         When using `Driver`, underlying observable sequence elements are shared because
         driver automagically adds "shareReplay(1)" under the hood.

         .observeOn(MainScheduler.instance)
         .catchErrorJustReturn(.Failed(message: "Error contacting server"))

         ... are squashed into single `.asDriver(onErrorJustReturn: .Failed(message: "Error contacting server"))`
         */

        validatedUsername = input.username
            .flatMapLatest { username in
                return validationService.validateUsername(username)
                    .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
        }

        validatedPassword = input.password
            .map { password in
                return validationService.validatePassword(password)
        }

        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asDriver()

        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { (username: $0, password: $1) }

        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return API.signup(pair.username, password: pair.password)
                    .trackActivity(signingIn)
                    .asDriver(onErrorJustReturn: false)
            }
            .flatMapLatest { loggedIn -> Driver<Bool> in
                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    // propagate original value
                    .map { _ in
                        loggedIn
                    }
                    .asDriver(onErrorJustReturn: false)
        }


        signinEnabled = Driver.combineLatest(
            validatedUsername,
            validatedPassword,
            signingIn
        )   { username, password, signingIn in
            username.isValid &&
                password.isValid &&
                !signingIn
            }
            .distinctUntilChanged()
    }
}
