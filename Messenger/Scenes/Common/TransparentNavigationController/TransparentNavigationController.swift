import UIKit

class TransparentNavigationController: UINavigationController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = .clear
        navigationBar.tintColor = .white
    }
    
}


