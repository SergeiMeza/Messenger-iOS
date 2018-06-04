//
//  UIColor+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hexString: String) {
        var cString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines as CharacterSet).uppercased()

        if cString.hasPrefix("#") {
            cString = String(cString[cString.index(cString.startIndex, offsetBy: 1)...])
        }

        let alpha = cString.count == 6 ? 1.0 : 0.0

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

extension UIColor {
    
    static let themeColor = UIColor(red: 239/255, green: 132/255, blue: 145/255, alpha: 1.0)

    static let backgroundColor: UIColor = .init(white: 0.95, alpha: 1.0)

    static let background60 = UIColor(red: 232/255, green: 225/255, blue: 225/255, alpha: 0.6)
    static let background100 = UIColor(red: 232/255, green: 225/255, blue: 225/255, alpha: 1.0)
    static let lips10 = UIColor(red: 255/255, green: 239/255, blue: 241/255, alpha: 1.0)
    static let lips60 = UIColor(red: 237/255, green: 116/255, blue: 131/255, alpha: 1.0)
    static let alabaster = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    static let dark10 = UIColor(red: 94/255, green: 63/255, blue: 63/255, alpha: 0.2)
    static let dark20 = UIColor(red: 199/255, green: 188/255, blue: 188/255, alpha: 1.0)
    static let dark50 = UIColor(red: 152/255, green: 141/255, blue: 141/255, alpha: 1.0)
    static let dark80 = UIColor(red: 95/255, green: 83/255, blue: 84/255, alpha: 1.0)
    static let light12 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.12)
    static let light30 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
    static let light70 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
    static let light100 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let gradationBottom = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    static let gradationTop = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
}
