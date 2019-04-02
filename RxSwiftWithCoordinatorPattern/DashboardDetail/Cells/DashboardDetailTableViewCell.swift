import UIKit
import RxSwift
import RxCocoa

class DashboardDetailTableViewCell: UITableViewCell {

    static let DefaultHeight: CGFloat = 44

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!

    var textFieldValueUpdated: Observable<String> {
        return textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(textField.rx.value.orEmpty)
            .distinctUntilChanged()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
}
