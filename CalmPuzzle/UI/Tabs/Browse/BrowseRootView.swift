//
//  BrowseRootView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class BrowseRootView: BaseRootView {
    
    private var subscriptions = Set<AnyCancellable>()

    let puzzleCollectionView: UICollectionView = {
        let layout = StretchyHeaderLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    init(frame: CGRect = .zero, viewModel: BrowseViewModel) {
        super.init(frame: frame, viewModel: viewModel)
        applyStyle()
        constructHierarchy()
        applyConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubviewToFront(settingsButton)
    }
    
    private func setupBindings() {
        guard let viewModel = viewModel as? BrowseViewModel else { return }
        viewModel
            .$filteredPuzzles
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.puzzleCollectionView.reloadData()
            })
            .store(in: &subscriptions)
    }
    
    private func applyStyle() {
        backgroundColor = .white
    }
    
    private func constructHierarchy() {
        addSubview(puzzleCollectionView)

        puzzleCollectionView.delegate = self
        puzzleCollectionView.dataSource = self
        puzzleCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        puzzleCollectionView.register(PuzzleTileCell.self, forCellWithReuseIdentifier: "PuzzleTileCell")
        puzzleCollectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeaderView")
    }
    
    private func applyConstraints() {
        puzzleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            puzzleCollectionView.topAnchor.constraint(equalTo: topAnchor),
            puzzleCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            puzzleCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            puzzleCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension BrowseRootView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel as? BrowseViewModel else { return 0 }
        return section == 0 ? 1 : viewModel.filteredPuzzles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel as? BrowseViewModel else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.configure(with: viewModel)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleTileCell", for: indexPath) as! PuzzleTileCell
            guard let puzzle = viewModel.filteredPuzzles?[indexPath.item] else { return UICollectionViewCell() }
            cell.configure(with: puzzle)
            return cell
        }
    }
}

extension BrowseRootView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == puzzleCollectionView && kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderView", for: indexPath) as? CustomHeaderView else {
                fatalError("Could not dequeue CustomHeaderView for puzzleCollectionView")
            }
            return header
        } else {
            // Return a default reusable view in the unlikely case it's still requested
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DefaultHeader", for: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height / 4)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: frame.width, height: 24)
        }
        
        if indexPath.section == 1 {
            return CGSize(width: UIScreen.main.bounds.width / 2 - 24, height: UIScreen.main.bounds.width / 2 - 24)
        }
        
        return .zero
    }
}

extension BrowseRootView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel as? BrowseViewModel else { return }
        
        if indexPath.section == 1 {
            viewModel.handlePuzzleSelection(index: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension BrowseRootView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == puzzleCollectionView {
            guard let header = puzzleCollectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? CustomHeaderView else { return }
            let currentHeaderHeight = header.frame.height
            header.adjustLayout(forHeight: currentHeaderHeight)
        }
    }
}
