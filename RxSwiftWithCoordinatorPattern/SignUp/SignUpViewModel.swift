import Foundation
import RxSwift

class SignUpViewModel {

    func signUp(account: String?, password: String?) -> Single<String> {
        guard let account = account, !account.isEmpty,
            let password = password, !password.isEmpty else {
            return Single<String>.create(subscribe: { (single) -> Disposable in
                single(.error(NSError.error(message: "Account or password can't be empty!")))
                return Disposables.create()
            })
        }
        return Single<String>.create(subscribe: { (single) -> Disposable in
            Bool.random()
                ? single(.success("Sign Up Succeeded!"))
                : single(.error(NSError.error(message: "Sign Up Failed!")))
            return Disposables.create()
        }).delay(2, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
    }
}
