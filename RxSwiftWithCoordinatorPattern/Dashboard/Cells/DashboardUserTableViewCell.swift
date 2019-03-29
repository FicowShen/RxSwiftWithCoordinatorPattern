//
//  DashboardUserTableViewCell.swift
//  RxSwiftWithCoordinatorPattern
//
//  Created by fshen on 2019/3/28.
//  Copyright © 2019 fshen. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var ID: String { return String.init(describing: self) }
}

class DashboardUserTableViewCell: UITableViewCell {

    static let DefaultHeight: CGFloat = 44

    var model: DashboardUserModel? {
        didSet {
            guard let m = model else { return }
            firstNameLabel.text = m.firstName
            lastNameLabel.text = m.lastName
            genderLabel.text = m.gender.string
            genderLabel.textColor = m.gender.color
        }
    }

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
