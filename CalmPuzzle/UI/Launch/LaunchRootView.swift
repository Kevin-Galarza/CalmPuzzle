//
//  LaunchRootView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import UIKit

class LaunchRootView: NiblessView {

    let viewModel: LaunchViewModel
    
    let logoImageView: UIImageView = {
        guard let image = UIImage(named: "pixel-potion-logo") else { return UIImageView() }
        let imageView = UIImageView(image: image)
        return imageView
    }()

    init(frame: CGRect = .zero, viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)

        styleView()
        constructHierarchy()
        activateConstraints()
        loadUserProfile()
    }

    private func styleView() {
        backgroundColor = Color.launchBackground
    }
    
    private func constructHierarchy() {
        addSubview(logoImageView)
    }

    private func activateConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 164),
            logoImageView.heightAnchor.constraint(equalToConstant: 242),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func loadUserProfile() {
        viewModel.loadUserProfile()
    }
}
