//
//  DifficultyRootView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 6/6/24.
//

import UIKit
import Combine

class DifficultyRootView: NiblessView {
    
    let viewModel: DifficultyViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(frame: CGRect = .zero, viewModel: DifficultyViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        applyStyle()
    }
    
    private func applyStyle() {
        backgroundColor = .white
    }
}
