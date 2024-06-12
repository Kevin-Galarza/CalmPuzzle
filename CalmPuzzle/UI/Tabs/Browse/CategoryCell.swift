//
//  CategoryCell.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/23/24.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var viewModel: BrowseViewModel?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CategoryItemCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructHierarchy()
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func constructHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    private func applyConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with viewModel: BrowseViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.puzzleCategories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryItemCell", for: indexPath)
        guard let viewModel = viewModel else { return cell }
        
        let category = viewModel.puzzleCategories[indexPath.item]
        let isSelected = category == viewModel.selectedPuzzleCategory

        let label: UILabel
        if let existingLabel = cell.contentView.viewWithTag(100) as? UILabel {
            label = existingLabel
        } else {
            label = UILabel()
            label.tag = 100
            label.textAlignment = .center
            label.frame = cell.bounds
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(label)
        }
        label.text = category.rawValue.capitalized
        label.textColor = isSelected ? .white : Color.textBlack

        cell.backgroundColor = isSelected ? Color.primaryPurple : .clear
        cell.layer.cornerRadius = isSelected ? 12 : 0

        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = viewModel?.puzzleCategories[indexPath.item].rawValue ?? ""
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width + 24
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let selectedCategory = viewModel.puzzleCategories[indexPath.item]
        viewModel.selectedPuzzleCategory = selectedCategory

        collectionView.reloadData()
    }
}
