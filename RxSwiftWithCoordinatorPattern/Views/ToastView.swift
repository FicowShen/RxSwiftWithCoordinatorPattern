//
//  ToastView.swift
//  RxSwiftWithCoordinatorPattern
//
//  Created by fshen on 2019/4/1.
//  Copyright © 2019 fshen. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNib() -> UIView{
        let view = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.last as! UIView
        return view
    }
}

class ToastView: UIView {

    static let shared: ToastView = {
        guard let view = ToastView.loadFromNib() as? ToastView else { fatalError() }
        return view
    }()

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.frame = UIScreen.main.bounds
        containerView.layer.cornerRadius = 4
        containerView.layer.masksToBounds = true
    }

    func show() {
        guard let delegate = UIApplication.shared.delegate, let window = delegate.window as? UIWindow else { return }
        window.endEditing(true)
        window.addSubview(self)
        self.indicatorView.startAnimating()
    }

    func hide() {
        self.indicatorView.stopAnimating()
        self.removeFromSuperview()
    }
}
