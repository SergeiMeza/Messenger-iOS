//
//  UIImageView+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import AlamofireImage
import SnapKit

extension UIImageView {
    convenience init(urlString: String) {
        self.init()
        self.normalSetup(urlString: urlString)
    }
    
    convenience init(urlString: String, size: CGSize) {
        self.init()
        self.roundSetup(urlString: urlString, size: size)
    }

    
    func normalSetup(urlString: String) {
        contentMode = .scaleAspectFill
        layer.masksToBounds = true
        if let url = URL(string: urlString) {
            af_setImage(
                withURL: url,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
    
    func aspectFitSetup(urlString: String) {
        contentMode = .scaleAspectFit
        layer.masksToBounds = true
        if let url = URL(string: urlString) {
            af_setImage(
                withURL: url,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
    
    func dynamicHeightSetup(urlString: String, size: CGSize) {
        contentMode = .scaleAspectFit
        guard size.height != 0, size.width != 0 else {
            // JSONデータで縦と横が0となっている時、画像を見せるため、ディフォルトの縦と横の比を4:3としました。
            if !urlString.isEmpty {
            dynamicHeightSetup(urlString: urlString, size: .init(width: 4, height: 3))
            }
            return
        }
        let aspectRatio = size.height / size.width
        let filter = AspectScaledToFitSizeFilter(size: CGSize(width: frame.width, height: frame.width * aspectRatio))
        snp.remakeConstraints {
            $0.height.equalTo(ceil(frame.width * aspectRatio)).priority(500)
        }
        if let url = URL(string: urlString) {
            af_setImage(
                withURL: url,
                filter: filter,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
    
    func roundSetup(urlString: String, size: CGSize) {
        contentMode = .scaleAspectFit
        layer.masksToBounds = true
        if let url = URL(string: urlString) {
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: size,
                radius: size.width / 2
            )
            af_setImage(
                withURL: url,
                filter: filter,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
}
