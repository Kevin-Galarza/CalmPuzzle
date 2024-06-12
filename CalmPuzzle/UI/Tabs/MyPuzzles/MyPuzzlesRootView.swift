//
//  MyPuzzlesRootView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class MyPuzzlesRootView: BaseRootView {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let header: UIView = {
        let view = UIView()
        view.backgroundColor = Color.primaryPurple
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["In Progress", "Completed"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = UIColor.black.withAlphaComponent(0.04)
        control.selectedSegmentTintColor = Color.primaryPurple
        
        let defaultAttributes = [NSAttributedString.Key.foregroundColor: Color.textBlack]
        control.setTitleTextAttributes(defaultAttributes, for: .normal)
        let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        return control
    }()
    
    private let puzzleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    init(frame: CGRect = .zero, viewModel: MyPuzzlesViewModel) {
        super.init(frame: frame, viewModel: viewModel)
        applyStyle()
        constructHierarchy()
        applyConstraints()
        setupBindings()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubviewToFront(settingsButton)
    }
    
    private func applyStyle() {
        backgroundColor = .white
    }
    
    private func constructHierarchy() {
        addSubview(header)
        addSubview(segmentedControl)
        addSubview(puzzleCollectionView)

        puzzleCollectionView.delegate = self
        puzzleCollectionView.dataSource = self
        puzzleCollectionView.register(PuzzleTileCell.self, forCellWithReuseIdentifier: "PuzzleTileCell")
    }
    
    private func applyConstraints() {
        header.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        puzzleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalTo: widthAnchor),
            header.heightAnchor.constraint(equalToConstant: 120),
            header.topAnchor.constraint(equalTo: topAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            puzzleCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            puzzleCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            puzzleCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MyPuzzlesRootView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 24, height: UIScreen.main.bounds.width / 2 - 24)
    }
}
