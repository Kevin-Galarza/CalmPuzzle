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
        applyStyle()
        constructHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with puzzle: Puzzle) {
        imageView.image = UIImage(named: puzzle.name)
    }
    
    private func applyStyle() {
        self.contentView.layer.cornerRadius = 16
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    private func constructHierarchy() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }
}
