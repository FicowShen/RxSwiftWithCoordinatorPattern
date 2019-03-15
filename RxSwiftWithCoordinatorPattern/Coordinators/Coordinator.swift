import UIKit

protocol Coordinator: class {
    func start()
    var childCoordinators: [Coordinator] { get set }
}

protocol RootViewControllerProvider: class {
    var rootViewController: UIViewController { get }
}

typealias RootViewCoordinator = Coordinator & RootViewControllerProvider
