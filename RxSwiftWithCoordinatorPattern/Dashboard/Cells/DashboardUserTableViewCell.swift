import UIKit

class DashboardUserTableViewCell: UITableViewCell {

    static let DefaultHeight: CGFloat = 44

    var model: DashboardUserModel? {
        didSet {
            guard let m = model else { return }
            firstNameLabel.text = m.firstName
            lastNameLabel.text = m.lastName
            genderLabel.text = m.gender.rawValue
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
