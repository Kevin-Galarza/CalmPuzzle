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
        button.setImage(UIImage(named: "settings_button"), for: .normal)
        return button
    }()
    
    init(frame: CGRect = .zero, viewModel: BaseViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        constructHierarchy()
        applyConstraints()
    }
    
    private func constructHierarchy() {
        settingsButton.addTarget(self, action: #selector(handleSettingButtonTap), for: .touchUpInside)
        addSubview(settingsButton)
    }
    
    @objc private func handleSettingButtonTap() {
        viewModel.showSettings()
    }
    
    private func applyConstraints() {
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 44),
            settingsButton.heightAnchor.constraint(equalToConstant: 44),
            settingsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            settingsButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])
    }
}
