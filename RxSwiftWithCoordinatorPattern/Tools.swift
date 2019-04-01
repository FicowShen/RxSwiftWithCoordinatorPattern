import Foundation

func delay(on queue: DispatchQueue = .main,
           seconds: TimeInterval,
           block: @escaping (() -> Void)){
    queue.asyncAfter(deadline: .now() + seconds) {
        block()
    }
}
