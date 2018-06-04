//
//  ErrorStateView.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/04.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ErrorStateView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private lazy var reloadButton: MessengerButton = {
        let button = MessengerButton()
        button.setup(text: "もう一回読み込む", type: .medium, buttonStyle: .select)
        button.contentEdgeInsets = UIEdgeInsets(top: 12.5, left: 20, bottom: 12.5, right: 20)
        return button
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumDefaultFont(ofSize: 15)
        label.textColor = .dark80
        label.text = "通信に失敗しました"
        label.sizeToFit()
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(reloadButton)
        stackView.spacing = 10.0
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
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
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
    
    func setupButtonClickListener(handler: @escaping () -> Void) {
        reloadButton.rx.tap
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: {
                handler()
            }).disposed(by: disposeBag)
    }
}
