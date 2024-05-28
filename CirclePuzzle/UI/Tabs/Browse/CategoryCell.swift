//
//  CategoryCell.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/23/24.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    private var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        constructHierarchy()
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        label.text = text
        label.textColor = .black
    }
    
    private func constructHierarchy() {
        contentView.addSubview(label)
    }
    
    private func applyConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

