//
//  ShopRootView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class ShopRootView: BaseRootView {
    
    init(frame: CGRect = .zero, viewModel: ShopViewModel) {
        super.init(frame: frame, viewModel: viewModel)
        applyStyle()
        constructHierarchy()
        applyConstraints()
    }
    
    private func applyStyle() {
        backgroundColor = .systemMint
    }
    
    private func constructHierarchy() {
        
    }
    
    private func applyConstraints() {
        
    }
}
