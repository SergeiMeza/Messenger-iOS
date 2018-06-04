//
//  LoadingStateView.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

class LoadingStateView: UIView {
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.grayIndicator()
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.backgroundColor
        addSubview(indicator)
        indicator.startAnimating()
        indicator.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.center.equalToSuperview()
        }
    }
}
