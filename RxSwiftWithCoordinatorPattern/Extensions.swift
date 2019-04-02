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
        return UIStoryboard.init(name: Constants.MainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: String(describing: self))
    }

    static func topMostViewController(_ rootViewController: UIViewController = UIApplication.shared.delegate!.window!!.rootViewController!) -> UIViewController {

        if let presented = rootViewController.presentedViewController {
            return topMostViewController(presented)
        }

        switch rootViewController {
        case let navigationController as UINavigationController:
            if let topViewController = navigationController.topViewController {
                return topMostViewController(topViewController)
            }
        case let tabBarController as UITabBarController:
            if let selectedViewController = tabBarController.selectedViewController {
                return topMostViewController(selectedViewController)
            }
        default:
            break
        }
        return rootViewController
    }

    static func showAlert(msg: String) {
        let topMostVC = topMostViewController()
        if let _ = topMostVC.presentedViewController {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Constants.AlertDisplayDelay), execute: {
                self.showAlert(msg: msg)
            })
            return
        }
        let alert = UIAlertController(title: Constants.AlertTitle, message: msg, preferredStyle: .alert)
        topMostVC.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Constants.AlertDisplayDuration), execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        }
    }
}

extension NSError {
    static func error(message: String) -> NSError {
        return NSError(domain: "NSError", code: -1, userInfo: [NSLocalizedDescriptionKey : message])
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

extension UITableViewCell {
    static var ID: String { return String.init(describing: self) }
}

extension Reactive where Base: UIControl {

    public var isEnabledStyle: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.isEnabledStyle = value
        }
    }
}

struct ValidationColors {
    static let okColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let errorColor = UIColor.red
}
