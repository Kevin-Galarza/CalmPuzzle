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
    
    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 50)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let puzzleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: UIScreen.main.bounds.width / 2 - 10) // Adjust size for padding and better fit
        layout.minimumInteritemSpacing = 10  // Space between items horizontally
        layout.minimumLineSpacing = 10       // Space between rows

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    init(frame: CGRect = .zero, viewModel: BrowseViewModel) {
        super.init(frame: frame, viewModel: viewModel)
        applyStyle()
        constructHierarchy()
        applyConstraints()
        setupBindings()
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
        backgroundColor = .systemGray
    }
    
    private func constructHierarchy() {
        addSubview(categoryCollectionView)
        addSubview(puzzleCollectionView)

        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")

        puzzleCollectionView.delegate = self
        puzzleCollectionView.dataSource = self
        puzzleCollectionView.register(PuzzleTileCell.self, forCellWithReuseIdentifier: "PuzzleTileCell")
    }
    
    private func applyConstraints() {
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        puzzleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 200),
            categoryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            puzzleCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 10),
            puzzleCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            puzzleCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            puzzleCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension BrowseRootView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel as? BrowseViewModel else { return 0 }
        
        if collectionView == categoryCollectionView {
            return viewModel.puzzleCategories.count
        }
        
        if collectionView == puzzleCollectionView {
            return viewModel.filteredPuzzles?.count ?? 0
        }
        
        return 0
    }

    // TODO: Look into implementing lazy loading for puzzle tile cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel as? BrowseViewModel else { return UICollectionViewCell() }
        
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
                fatalError("Failed to dequeue CategoryCell")
            }
            let category = viewModel.puzzleCategories[indexPath.item]
            cell.configure(with: category.rawValue.capitalized)
            return cell
        }
        
        if collectionView == puzzleCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleTileCell", for: indexPath) as? PuzzleTileCell,
                  let puzzle = viewModel.filteredPuzzles?[indexPath.row] else {
                fatalError("Failed to dequeue PuzzleTileCell or puzzle data unavailable")
            }
            cell.configure(with: puzzle)
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension BrowseRootView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel as? BrowseViewModel else { return }
        
        if collectionView == categoryCollectionView {
            let category = viewModel.puzzleCategories[indexPath.item]
            viewModel.selectedPuzzleCategory = category
        }
        
        if collectionView == puzzleCollectionView {
//            guard let puzzle = viewModel.filteredPuzzles?[indexPath.row] else { return }
            viewModel.handlePuzzleSelection(index: indexPath.row)
        }
    }
}
