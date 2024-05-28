//
//  PuzzleTileCell.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/23/24.
//

import UIKit

class PuzzleTileCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with puzzle: Puzzle) {
        imageView.image = UIImage(named: puzzle.name)
    }
    
    private func constructHierarchy() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }
}
