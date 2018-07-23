import UIKit
import BonMot

class HeroViewController: VideoBackgroundViewController {
    
    let welcomeLabel = UILabel()
    let button = MessengerButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        welcomeLabel.numberOfLines = 0
        welcomeLabel.attributedText = "AppCruch\nBussiness Plan".styled(with: StringStyle(.lineHeightMultiple(1.2), .alignment(.center), .font(.boldDefaultFont(ofSize: 50)), .color(.black)))
        
        view.addSubview(button)
        button.setup(text: "Start Experience", type: .large, buttonStyle: .select)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let w = view.bounds.width
        let h = view.bounds.height
        
        welcomeLabel.frame = CGRect(x: 20,
                                    y: h * 0.15,
                                    width: w - 20,
                                    height: 200)
        
        videoFrame = CGRect(x: 32,
                            y: h * 0.5,
                            width: w - 64,
                            height: h * 0.5 - 32)
        
        button.frame = CGRect(x: w * 0.5 - 80,
                              y: h - 104,
                              width: 160,
                              height: 40)
    }
}
