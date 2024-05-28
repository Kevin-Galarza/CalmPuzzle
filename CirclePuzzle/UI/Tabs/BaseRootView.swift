//
//  BaseRootView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class BaseRootView: NiblessView {
    
    let viewModel: BaseViewModel
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    init(frame: CGRect = .zero, viewModel: BaseViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        constructHierarchy()
        applyConstraints()
    }
    
    private func constructHierarchy() {
        addSubview(settingsButton)
    }
    
    private func applyConstraints() {
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 88),
            settingsButton.heightAnchor.constraint(equalToConstant: 44),
            settingsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            settingsButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])
    }
}
