import Foundation
import UIKit

class FooterCell: UICollectionReusableView {
    static let CELL_ID = "footerCell"
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func startAnimating() {
        loadingIndicator.startAnimating()
    }
    
    func stopAnimating() {
        loadingIndicator.stopAnimating()
    }
}
