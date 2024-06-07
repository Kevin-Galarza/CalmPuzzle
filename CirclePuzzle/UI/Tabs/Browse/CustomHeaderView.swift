//
//  HeaderView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 6/3/24.
//

import UIKit

class CustomHeaderView: UICollectionReusableView {
    
    let imageView: UIImageView = {
        let image = UIImage(named: "browse_header_avatar")
        let view = UIImageView(image: image)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        applyConstraints()
        setGradientBackground()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustLayout(forHeight height: CGFloat) {
        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        if height <= 120 {
            backgroundColor = Color.primaryPurple
        } else {
            addSubview(imageView)
            applyConstraints()
            setGradientBackground()
        }
    }
    
    private func applyConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 115),
            imageView.widthAnchor.constraint(equalToConstant: 230),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setGradientBackground() {
        let colorTop =  Color.secondaryPurple.cgColor
        let colorBottom = Color.primaryPurple.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
                
        self.layer.insertSublayer(gradientLayer, at:0)
    }
}
