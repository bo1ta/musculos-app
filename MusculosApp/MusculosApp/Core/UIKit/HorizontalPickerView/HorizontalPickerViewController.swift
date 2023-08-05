//
//  HorizontalPickerViewController.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.07.2023.
//

import Foundation
import UIKit

class HorizontalPickerViewController: UIViewController {
    var selectionDidChange: ((String) -> Void)?

    private var cellWidth: CGFloat = 0
    private var data: [String] = []
    private var selectedCellIndexPath: IndexPath?

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HorizontalPickerViewCell.self, forCellWithReuseIdentifier: HorizontalPickerViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionViewUI()
        self.setupData()
    }
    
    private func setupData() {
        for i in 30..<200 {
            self.data.append("\(i)")
        }
    }
}

extension HorizontalPickerViewController {
    private func setupCollectionViewUI() {
        self.cellWidth = self.view.frame.width / 4
        self.view.addSubview(self.collectionView)

        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            collectionView.heightAnchor.constraint(equalToConstant: cellWidth),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - UICollectionView delegates

extension HorizontalPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalPickerViewCell.identifier, for: indexPath) as! HorizontalPickerViewCell
        cell.configure(with: self.data[indexPath.row])
        return cell
    }
}

extension HorizontalPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.select(row: indexPath.row)
        let selectedOption = self.data[indexPath.row]
        self.selectionDidChange?(selectedOption)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollToCell()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollToCell()
    }
}

extension HorizontalPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.cellWidth, height: self.cellWidth - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = view.frame.width/2 - cellWidth/2
        return UIEdgeInsets(
            top: 0,
            left: inset,
            bottom: 0,
            right: inset
        )
    }
}

// MARK: - Helpers

extension HorizontalPickerViewController {
    public func select(row: Int, in section: Int = 0, animated: Bool = true) {
        guard row < data.count else { return }
    
        self.cleanupSelection()
        
        let indexPath = IndexPath(row: row, section: section)
        self.selectedCellIndexPath = indexPath
        
        let cell = collectionView.cellForItem(at: indexPath) as? HorizontalPickerViewCell
        cell?.configure(
            with: data[indexPath.row],
            isSelected: true
        )
        
        self.collectionView.selectItem(
            at: indexPath,
            animated: animated,
            scrollPosition: .centeredHorizontally)
    }
    
    
    private func cleanupSelection() {
        guard let indexPath = self.selectedCellIndexPath else { return }
        let cell = self.collectionView.cellForItem(at: indexPath) as? HorizontalPickerViewCell
        cell?.configure(with: data[indexPath.row])
        self.selectedCellIndexPath = nil
    }
    
    /// Scrolls to visible cell based on `scrollViewDidEndDragging` or `scrollViewDidEndDecelerating` delegate functions
    private func scrollToCell() {
        var indexPath = IndexPath()
        var visibleCells = self.collectionView.visibleCells
        
        visibleCells = visibleCells.filter({ cell -> Bool in
            let cellRect = self.collectionView.convert(
                cell.frame,
                to: self.collectionView.superview
            )
            /// Calculate if at least 50% of the cell is in the boundaries we created
            let viewMidX = view.frame.midX
            let cellMidX = cellRect.midX
            let topBoundary = viewMidX + cellRect.width/2
            let bottomBoundary = viewMidX - cellRect.width/2
            
            /// A print state representating what the return is calculating
            return topBoundary > cellMidX  && cellMidX > bottomBoundary
        })
        
        /// Appends visible cell index to `cellIndexPath`
        visibleCells.forEach({
            if let selectedIndexPath = self.collectionView.indexPath(for: $0) {
                indexPath = selectedIndexPath
            }
        })
        
        let row = indexPath.row
        // Disables animation on the first and last cell
        if row == 0 || row == data.count - 1 {
            self.select(row: row, animated: false)
            return
        }
        self.select(row: row)
    }
}

