//
//  MessengerButton.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import BonMot

class MessengerButton: UIButton {
    
    enum ButtonSizeType {
        case small
        case medium
        case large
    }
    
    enum ButtonStyleType {
        case select
        case notSelect
        case disable
    }
    
    func setup(text: String, type: ButtonSizeType, buttonStyle: ButtonStyleType) {
        layer.borderWidth = 0.5
        layer.cornerRadius = 4
        var style = StringStyle.init()
        switch buttonStyle {
        case .select:
            style.color = .light100
            backgroundColor = .themeColor
            layer.borderColor = UIColor.themeColor.cgColor
        case .notSelect:
            style.color = .dark80
            backgroundColor = .light100
            layer.borderColor = UIColor.dark10.cgColor
        case .disable:
            style.color = .light100
            backgroundColor = .dark20
            layer.borderColor = UIColor.dark10.cgColor
        }
        switch type {
        case .small:
            style.font = .mediumDefaultFont(ofSize: 11)
        case .medium:
            style.font = .mediumDefaultFont(ofSize: 13)
        case .large:
            style.font = .mediumDefaultFont(ofSize: 14)
        }
        setAttributedTitle(text.styled(with: style), for: .normal)
    }
}
