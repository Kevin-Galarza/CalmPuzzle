//
//  DailyPuzzleRootView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class DailyPuzzleRootView: BaseRootView {
    
    private let header: UIView = {
        let view = UIView()
        view.backgroundColor = Color.primaryPurple
        return view
    }()
    
    init(frame: CGRect = .zero, viewModel: DailyPuzzleViewModel) {
        super.init(frame: frame, viewModel: viewModel)
        applyStyle()
        constructHierarchy()
        applyConstraints()
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
    }
    
    private func applyConstraints() {
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalTo: widthAnchor),
            header.heightAnchor.constraint(equalToConstant: 120),
            header.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
