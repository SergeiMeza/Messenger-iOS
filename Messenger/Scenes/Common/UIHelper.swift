//
//  UIHelper.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/06.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

struct UIHelper {
    
    enum Device {
        case iPad
        case iphoneSE
        case iphoneX
        case other
    }
    
    /// 画面幅でiphoneSEか他のデバイスかどうか分けることができます。
    static var device: Device {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return Device.iPad
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 1136.0 {
                return Device.iphoneSE
            } else if UIScreen.main.nativeBounds.height == 2436.0 {
                return Device.iphoneX
            }
        }
        return Device.other
    }
    
    static var isIPad: Bool {
        return UIHelper.device == .iPad
    }
    
    static var isIphoneSE: Bool {
        return UIHelper.device == .iphoneSE
    }
    
    static var isIphoneX: Bool {
        return UIHelper.device == .iphoneX
    }
}

