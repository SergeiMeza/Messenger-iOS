//
//  OriginalTabView.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/05.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

class OriginalTabView: UIView {
    
    var delegate: OriginalTabViewDelegate?
    
    func to(index: Int, isAnimated: Bool = true) {
        guard let cell = collectionView.cellForItem(at: [0, index]) as? OriginalTabCell else { return }
        
        UIView.animate(withDuration: isAnimated ? 0.3 : 0) {
            self.selectedView.frame.origin.x = cell.frame.origin.x + self.collectionView.contentInset.left
            self.selectedView.frame.size.width = cell.frame.width
        }
        
        cell.setTextColor(s.tabSelectedTextColor, duration: isAnimated ? 0.3 : 0)
        collectionView.visibleCells.map { $0 as! OriginalTabCell }.filter { $0 != cell }.forEach { otherCell in
            otherCell.setTextColor(s.tabTextColor, duration: isAnimated ? 0.3 : 0)
        }
    }
    
    func moving(from: Int, to: Int, rate: CGFloat) {
        guard
            let fromCell = collectionView.cellForItem(at: [0, from]) as? OriginalTabCell,
            let toCell = collectionView.cellForItem(at: [0, to]) as? OriginalTabCell else { return }
        self.selectedView.frame.origin.x = (toCell.frame.origin.x - fromCell.frame.origin.x) * rate + fromCell.frame.origin.x + collectionView.contentInset.left
        self.selectedView.frame.size.width = (toCell.frame.width - fromCell.frame.width) * rate + fromCell.frame.width
        
        fromCell.textColor = blend(color1: s.tabTextColor, color2: s.tabSelectedTextColor, weight: rate)
        toCell.textColor = blend(color1: s.tabSelectedTextColor, color2: s.tabTextColor, weight: rate)
    }
    
    func reload() {
        collectionView.reloadData()
        to(index: viewController.index, isAnimated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollViewDidScroll(self.collectionView) // for text color
        }
    }
    
    // MARK: -
    
    private var viewController: OriginalTabViewController!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedView: UIView! // not autolayout
    
    var s: OriginalTabViewController.Settings {
        return self.viewController.settings
    }
    
    var titles: [String] {
        return self.viewController.titles
    }
    
    private var cellWidth: CGFloat {
        return (UIScreen.main.bounds.width - s.tabInterval * CGFloat(titles.count+1)) / CGFloat(titles.count)
    }
    
    init(parent homeTabViewController: OriginalTabViewController) {
        viewController = homeTabViewController
        super.init(frame: .zero)
        
        let view = Bundle.main.loadNibNamed("OriginalTabView", owner: self)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        self.backgroundColor = s.tabBackgroundColor
        
        selectedView.backgroundColor = s.tabSelectionColor
        selectedView.frame.size.height = s.tabSelectionHeight
        selectedView.center.y = self.center.y - (s.tabBottomInset / 2)
        selectedView.layer.cornerRadius = s.tabSelectionHeight/2
        
        collectionView.register(UINib(nibName: OriginalTabCell.id, bundle: nil), forCellWithReuseIdentifier: OriginalTabCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        collectionView.contentInset = .init(top: 0, left: s.tabInterval, bottom: s.tabBottomInset, right: s.tabInterval)
        collectionView.isScrollEnabled = false
        
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = s.tabInterval
            flowLayout.minimumInteritemSpacing = s.tabInterval
        }
        
        DispatchQueue.main.async {
            self.selectedView.center.y = self.center.y - (self.s.tabBottomInset / 2)
            self.to(index: 0, isAnimated: false)
        }
    }
}

extension OriginalTabView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OriginalTabCell.id, for: indexPath) as! OriginalTabCell
        cell.set(title: titles[indexPath.row % titles.count], height: s.tabHeight)
        cell.textColor = (indexPath.row % titles.count == self.viewController.index) ? s.tabSelectedTextColor : s.tabTextColor
        return cell
    }
}

extension OriginalTabView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.originalTabView(didSelect: indexPath.row)
        to(index: indexPath.row)
    }
    
    // keep for overriding
    func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { }
}

extension OriginalTabView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: cellWidth, height: s.tabHeight - s.tabBottomInset)
    }
}

extension OriginalTabView {
    
    /// weight: 0...1
    func blend(color1: UIColor, color2: UIColor, weight w: CGFloat) -> UIColor {
            var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0, r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return UIColor(red: r1*w + r2*(1-w), green: g1*w + g2*(1-w), blue: b1*w + b2*(1-w), alpha: a1*w + a2*(1-w))
    }
}
