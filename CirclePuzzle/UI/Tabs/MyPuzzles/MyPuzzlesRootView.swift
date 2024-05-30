//
//  MyPuzzlesRootView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

import UIKit
import Combine

class MyPuzzlesRootView: BaseRootView {
    
    private var subscriptions = Set<AnyCancellable>()
    
    // UI Components
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["In Progress", "Completed"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .systemBackground
        control.selectedSegmentTintColor = .systemBlue
        return control
    }()
    
    private let puzzleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: UIScreen.main.bounds.width / 2 - 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    init(frame: CGRect = .zero, viewModel: MyPuzzlesViewModel) {
        super.init(frame: frame, viewModel: viewModel)
        applyStyle()
        constructHierarchy()
        applyConstraints()
        setupBindings()
    }
    
    private func applyStyle() {
        backgroundColor = .systemRed
    }
    
    private func constructHierarchy() {
        addSubview(segmentedControl)
        addSubview(puzzleCollectionView)

        puzzleCollectionView.delegate = self
        puzzleCollectionView.dataSource = self
        puzzleCollectionView.register(PuzzleTileCell.self, forCellWithReuseIdentifier: "PuzzleTileCell")
    }
    
    private func applyConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        puzzleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            puzzleCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            puzzleCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            puzzleCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            puzzleCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        guard let viewModel = viewModel as? MyPuzzlesViewModel else { return }
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        viewModel.$puzzles
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.puzzleCollectionView.reloadData()
            })
            .store(in: &subscriptions)
    }
    
    @objc private func segmentChanged() {
        guard let viewModel = viewModel as? MyPuzzlesViewModel else { return }
        viewModel.selectedSegment = MyPuzzlesSegment(rawValue: segmentedControl.selectedSegmentIndex) ?? .inProgress
    }
}

// MARK: - UICollectionViewDataSource
extension MyPuzzlesRootView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel as? MyPuzzlesViewModel else { return 0 }
        return viewModel.puzzles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleTileCell", for: indexPath) as? PuzzleTileCell,
              let viewModel = viewModel as? MyPuzzlesViewModel,
              let puzzle = viewModel.puzzles?[indexPath.row] else {
            fatalError("Failed to dequeue PuzzleTileCell or puzzle data unavailable")
        }
        
        cell.configure(with: puzzle)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MyPuzzlesRootView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel as? MyPuzzlesViewModel else { return }
        viewModel.handlePuzzleSelection(index: indexPath.row)
    }
}

