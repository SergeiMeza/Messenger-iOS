//
//  UILabel+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

extension UILabel {
    
    func formattedSet(number: Int) {
        if number > DeviceConst.giga { return text = "\(format(number, DeviceConst.giga))G" }
        if number > DeviceConst.mega { return text = "\(format(number, DeviceConst.mega))M" }
        if number > DeviceConst.kilo { return text = "\(format(number, DeviceConst.kilo))K" }
        return text = "\(number)"
    }
    
    private func format(_ numerator: Int, _ denominator: Int) -> String {
        // 10倍して小数点一桁残す
        let num = Double(numerator / denominator) * 10
        return "\(round(num) / 10)"
    }

}
