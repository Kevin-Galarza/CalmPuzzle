//
//  MyPuzzlesRootView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class MyPuzzlesRootView: BaseRootView {
    
    init(frame: CGRect = .zero, viewModel: MyPuzzlesViewModel) {
        super.init(frame: frame, viewModel: viewModel)
        applyStyle()
        constructHierarchy()
        applyConstraints()
    }
    
    private func applyStyle() {
        backgroundColor = .systemCyan
    }
    
    private func constructHierarchy() {
        
    }
    
    private func applyConstraints() {
        
    }
}
