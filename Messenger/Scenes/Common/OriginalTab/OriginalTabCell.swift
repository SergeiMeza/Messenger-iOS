//
//  OriginalTabCell.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/05.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

final class OriginalTabCell: UICollectionViewCell {
    static let id = "OriginalTabCell"
    
    static let padding: CGFloat = 12
    /// The width of "人気" label when font size is 11
    static let minWidth: CGFloat = 22
    
    class func getWidth(title: String) -> CGFloat {
        let label = UILabel()
        label.font = UIFont.mediumDefaultFont(ofSize: 11)
        label.text = title
        let labelWidth = label.sizeThatFits(CGSize(width: 1000, height: 200)).width
        return max(labelWidth, minWidth) + padding * 2
    }
    
    // MARK: -

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var leftPaddingLayout: NSLayoutConstraint!
    @IBOutlet private weak var rightPaddingLayout: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftPaddingLayout.constant = OriginalTabCell.padding
        rightPaddingLayout.constant = OriginalTabCell.padding
    }
    
    var textColor: UIColor {
        get {
            return titleLabel.textColor
        } set {
            titleLabel.textColor = newValue
        }
    }
    
    func setTextColor(_ color: UIColor, duration: TimeInterval) {
        UIView.transition(with: self.titleLabel, duration: duration, options: .transitionCrossDissolve, animations: {
            self.titleLabel.textColor = color
        })
    }
    
    func set(title: String, height: CGFloat) {
        titleLabel.text = title
        titleLabelHeightConstraint.constant = height
    }
    

}
