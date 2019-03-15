import UIKit
import RxSwift
import RxCocoa

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}

extension UIViewController {
    static func loadFromMainStoryboard() -> UIViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: self))
    }
}

extension UIControl {
    var isEnabledStyle: Bool {
        get {
            return isEnabled
        }
        set {
            isEnabled = newValue
            alpha = newValue ? 1 : 0.5
        }
    }
}

extension Reactive where Base: UIControl {

    public var isEnabledStyle: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.isEnabledStyle = value
        }
    }
}
