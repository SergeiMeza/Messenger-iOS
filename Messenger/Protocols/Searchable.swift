//
//  Searchable+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

//protocol Searchable: UITextFieldDelegate {
//    func setupSearchBar()
//}
//
//extension Searchable where Self: UIViewController {
//    func setupSearchBar() {
//        guard let navigationBarFrame = navigationController?.navigationBar.bounds else { return }
//
//        let barButtonItemSize: CGFloat = 42
//        let margin: CGFloat = {
//            var margin: CGFloat = 72
//            if let numOfRightItems = navigationItem.rightBarButtonItems?.count,
//                numOfRightItems > 1 { margin += barButtonItemSize }
//            if let numOfLeftItems = navigationItem.leftBarButtonItems?.count, numOfLeftItems > 0 { margin += barButtonItemSize }
//            if navigationBarFrame.width == 414 { margin += 8 } // When Plus size.
//            return margin
//        }()
//
//        let fieldWidth = navigationBarFrame.width - margin
//        let fieldFrame = CGRect(x: 0, y: 6, width: fieldWidth, height: 30)
//        let field = SearchField(frame: fieldFrame)
//        field.backgroundColor = .background60
//        field.layer.cornerRadius = 15
//        setupTextFor(field)
//        setupImageFor(field)
//
//        let searchBarView = UIView(frame: navigationBarFrame)
//        searchBarView.addSubview(field)
//
//        navigationItem.titleView = searchBarView
//
//        field.delegate = self
//    }
//
//    func setupTextFor(_ field: UITextField) {
//        field.attributedPlaceholder = NSAttributedString(string: "キーワードで検索", attributes: [NSAttributedStringKey.foregroundColor: UIColor.dark20, NSAttributedStringKey.baselineOffset: -0.3])
//        field.textColor = .dark20
//        field.font = UIFont.mediumDefaultFont(ofSize: 12)
//    }
//
//    func setupImageFor(_ field: SearchField) {
//        let imageViewContainerFrame = CGRect(x: 0, y: 0, width: field.imageSize + field.imageRightPadding, height: field.imageSize)
//        let imageViewContainer = UIView(frame: imageViewContainerFrame)
//        let imageViewFrame = CGRect(x: 0, y: 0, width: field.imageSize, height: field.imageSize)
//        let imageView = UIImageView(frame: imageViewFrame)
//        imageView.image = UIImage(named: "ic_16_search")
//        imageViewContainer.addSubview(imageView)
//
//        field.leftView = imageViewContainer
//        field.leftViewMode = .always
//    }
//    
//    func showSearchView() -> Bool {
//        let vc = SearchSuggestionViewController.instantiate()
//        self.navigationController?.pushViewController(vc, animated: false)
//        return false
//    }
//}
//
//class SearchField: UITextField {
//    let imageSize: CGFloat = 13
//    let imageRightPadding: CGFloat = 5
//
//    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
//        let textAndImageWidth: CGFloat = 116
//
//        let xPosition: CGFloat = (self.frame.width - textAndImageWidth) / 2
//        let yPosition = (self.frame.height - imageSize) / 2
//
//        return CGRect(x: xPosition, y: yPosition, width: imageSize + imageRightPadding, height: imageSize)
//    }
//}
