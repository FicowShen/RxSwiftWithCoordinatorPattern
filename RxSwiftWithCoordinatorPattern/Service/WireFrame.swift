import RxSwift

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

enum RetryResult {
    case retry
    case cancel
}

protocol Wireframe {
    func open(url: URL)
    func promptFor<Action: CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}


class DefaultWireframe: Wireframe {
    static let shared = DefaultWireframe()

    func open(url: URL) {
        #if os(iOS)
        UIApplication.shared.openURL(url)
        #elseif os(macOS)
        NSWorkspace.shared.open(url)
        #endif
    }

    #if os(iOS)
    private static func topMostViewController(_ rootViewController: UIViewController = UIApplication.shared.delegate!.window!!.rootViewController!) -> UIViewController {

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
    #endif

    static func presentAlert(_ message: String) {
        #if os(iOS)
        let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        topMostViewController().present(alertView, animated: true, completion: nil)
        #endif
    }

    func promptFor<Action : CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> {
        #if os(iOS)
        return Observable.create { observer in
            let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                observer.on(.next(cancelAction))
            })

            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.on(.next(action))
                })
            }

            DefaultWireframe.topMostViewController().present(alertView, animated: true, completion: nil)

            return Disposables.create {
                alertView.dismiss(animated:false, completion: nil)
            }
        }
        #elseif os(macOS)
        return Observable.error(NSError(domain: "Unimplemented", code: -1, userInfo: nil))
        #endif
    }
}


extension RetryResult : CustomStringConvertible {
    var description: String {
        switch self {
        case .retry:
            return "Retry"
        case .cancel:
            return "Cancel"
        }
    }
}
