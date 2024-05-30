//
//  GameSessionRootView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/23/24.
//

import UIKit
import Combine

class GameSessionRootView: UIView {
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    var viewModel: GameSessionViewModel
    
    private var collectionView: UICollectionView!
    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: GameSessionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        applyStyle()
        constructHierarchy()
        applyConstraints()
        setupCollectionView()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyStyle() {
        backgroundColor = .gray
    }
    
    private func constructHierarchy() {
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        addSubview(backButton)
    }
    
    @objc private func handleBackButtonTap() {
        viewModel.dismiss()
    }
    
    private func applyConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 88),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16)
        ])
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1

        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 375, height: 375), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TileCell.self, forCellWithReuseIdentifier: "TileCell")
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: 375),
            collectionView.heightAnchor.constraint(equalToConstant: 375),
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.$tiles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.$selectedTileIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateSelectedTileHighlighting()
            }
            .store(in: &subscriptions)

        viewModel.swapPublisher
            .sink { [weak self] swapInfo in
                self?.animateSwap(index1: swapInfo.0, index2: swapInfo.1)
            }
            .store(in: &subscriptions)
    }
    
    private func updateSelectedTileHighlighting() {
        guard let collectionView = collectionView else { return }
        for cell in collectionView.visibleCells {
            guard let tileCell = cell as? TileCell,
                  let indexPath = collectionView.indexPath(for: tileCell) else { continue }
            let isSelected = indexPath.item == viewModel.selectedTileIndex
            if isSelected {
                tileCell.highlight()
            } else {
                tileCell.unhighlight()
            }
        }
    }

    private func animateSwap(index1: Int, index2: Int) {
        collectionView.performBatchUpdates({
            collectionView.moveItem(at: IndexPath(item: index1, section: 0), to: IndexPath(item: index2, section: 0))
            collectionView.moveItem(at: IndexPath(item: index2, section: 0), to: IndexPath(item: index1, section: 0))
        }, completion: nil)
    }
}

extension GameSessionRootView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCell", for: indexPath) as? TileCell else {
            fatalError("Failed to dequeue TileCell")
        }
        let tile = viewModel.tiles[indexPath.item]
        cell.configure(with: tile.image, isSelected: indexPath.item == viewModel.selectedTileIndex)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = (375 - CGFloat(viewModel.gridSize - 1)) / CGFloat(viewModel.gridSize)
        return CGSize(width: sideLength, height: sideLength)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectTile(at: indexPath.item)
    }
}

