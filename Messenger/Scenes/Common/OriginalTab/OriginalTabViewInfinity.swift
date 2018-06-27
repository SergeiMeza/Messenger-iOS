//
//  OriginalTabViewInfinity.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/05.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit

final class OriginalTabViewInfinity: OriginalTabView {
    
    private var centerCellX: CGFloat = 0 // for infinity
    
    override func initialize() {
        // not call super.initialize()
        collectionView.contentInset.bottom = s.tabBottomInset
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.scrollToItem(at: [0, self.titles.count + 0], at: .centeredHorizontally, animated: false)
            self.collectionView.layoutIfNeeded()
            guard let cell = self.collectionView.cellForItem(at: [0, self.titles.count + 0]) else { return }
            self.selectedView.frame.size.width = cell.frame.width
            self.selectedView.center.x = self.collectionView.center.x
            self.selectedView.center.y = self.collectionView.center.y - (self.s.tabBottomInset / 2)
        }
    }
    
    override func to(index: Int, isAnimated: Bool) {
        let items = collectionView.indexPathsForVisibleItems.map { $0.item }
        let nearItem = Set(items).intersection([index, index + titles.count, index + titles.count*2]).first ?? index + titles.count
        let indexPath: IndexPath = [0, nearItem]
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: isAnimated)
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        self.selectedView.frame.size.width = cell.frame.width
        self.selectedView.center.x = self.collectionView.center.x
        self.selectedView.center.y = self.collectionView.center.y - (s.tabBottomInset / 2)
    }
    
    override func moving(from: Int, to: Int, rate: CGFloat) {
        let items = collectionView.indexPathsForVisibleItems.map { $0.item }
        guard
            let fromItem = Set(items).intersection([from, from + titles.count, from + titles.count*2]).first,
            let toItem = Set(items).intersection([to, to + titles.count, to + titles.count*2]).first else { return }
        let fromIndexPath: IndexPath = [0, fromItem], toIndexPath: IndexPath = [0, toItem]
        guard
            let fromCell = collectionView.cellForItem(at: fromIndexPath),
            let toCell = collectionView.cellForItem(at: toIndexPath) else { return }
        var gap = abs(fromCell.center.x - toCell.center.x) * rate
        if from - 1 == to || (from == 0 && to != 1) { gap = -gap }
        
        var x = fromCell.center.x - collectionView.frame.width/2 + gap
        if (gap > 0 && x > toCell.center.x - collectionView.frame.width/2) || (gap < 0 && x < toCell.center.x - collectionView.frame.width/2) {
            x = toCell.center.x - collectionView.frame.width/2
        }
        collectionView.contentOffset.x = x
    }
}

// MARK: UICollectionViewDatasource

extension OriginalTabViewInfinity {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIHelper.isIPad) ? titles.count * 5 : titles.count * 3
    }
}

// MARK: UICollectionViewDelegate

extension OriginalTabViewInfinity {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.originalTabView(didSelect: indexPath.row % titles.count)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // ---------------
        // infinity scroll
        // ---------------
        let x = scrollView.contentOffset.x
        let thirdX = collectionView.cellForItem(at: [0, titles.count * 2])?.frame.origin.x ?? CGFloat.greatestFiniteMagnitude
        if let centerCellX = collectionView.cellForItem(at: [0, titles.count])?.frame.origin.x {
            self.centerCellX = centerCellX // memorize center cell x
        }
        if x <= 5 || thirdX + 5 <= x {
            scrollView.contentOffset.x = centerCellX + 5
        }
        
        // ---------------------
        // selection stay center
        // ---------------------
        let cells = collectionView.visibleCells.sorted(by: { $0.frame.minX < $1.frame.minX })
        // center cell
        let diffs = cells.map({ fabs($0.frame.midX - scrollView.bounds.midX) })
        guard let minDiff = diffs.min(), let centerCellIndex = diffs.index(of: minDiff) else { return }
        let centerCell = cells[centerCellIndex]
        // cell near the center cell
        let centerLeftCell = (centerCellIndex-1 >= 0) ? cells[centerCellIndex-1] : nil
        let centerRightCell = (centerCellIndex+1 < cells.count) ? cells[centerCellIndex+1] : nil
        guard let centerNearCell = (scrollView.bounds.midX < centerCell.frame.midX) ? centerLeftCell : centerRightCell else { return }
        // rate of scroll position
        let ratePosition = (centerCell.center.x - scrollView.bounds.midX) / fabs(centerCell.center.x - centerNearCell.center.x)
        // coordinate of selectedView
        selectedView.frame.size.width = centerCell.bounds.width + (centerNearCell.bounds.width - centerCell.bounds.width) * abs(ratePosition)
        self.selectedView.center.x = self.collectionView.center.x
        self.selectedView.center.y = self.collectionView.center.y - (self.s.tabBottomInset / 2)
        // text color
        (centerCell as? OriginalTabCell)?.textColor = blend(color1: s.tabTextColor, color2: s.tabSelectedTextColor, weight: abs(ratePosition))
        (centerNearCell as? OriginalTabCell)?.textColor = blend(color1: s.tabSelectedTextColor, color2: s.tabTextColor, weight: abs(ratePosition))
        cells.filter{ $0 != centerCell && $0 != centerNearCell }.forEach{ ($0 as? OriginalTabCell)?.textColor = s.tabTextColor }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { endScrollAndMove() }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endScrollAndMove()
    }
    
    private func endScrollAndMove() {
        let diffs = collectionView.visibleCells.map({ fabs($0.frame.midX - collectionView.bounds.midX) })
        guard
            let minDiff = diffs.min(),
            let centerCellIndex = diffs.index(of: minDiff),
            let centerIndexPath = collectionView.indexPath(for: collectionView.visibleCells[centerCellIndex]) else { return }
        collectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
        
        delegate?.originalTabView(didSelect: centerIndexPath.row % titles.count)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension OriginalTabViewInfinity {
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: OriginalTabCell.getWidth(title: titles[indexPath.row % titles.count]), height: s.tabHeight - s.tabBottomInset)
    }
}

