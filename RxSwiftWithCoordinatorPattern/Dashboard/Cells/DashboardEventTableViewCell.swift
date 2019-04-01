//
//  DashboardEventTableViewCell.swift
//  RxSwiftWithCoordinatorPattern
//
//  Created by fshen on 2019/3/28.
//  Copyright © 2019 fshen. All rights reserved.
//

import UIKit

class DashboardEventTableViewCell: UITableViewCell {

    static let DefaultHeight: CGFloat = 80

    var model: DashboardEventModel? {
        didSet {
            guard let m = model else { return }
            nameLabel.text = m.name
            priorityLabel.text = m.priority.rawValue
            priorityLabel.textColor = m.priority.color
            timeLabel.text = m.time
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
