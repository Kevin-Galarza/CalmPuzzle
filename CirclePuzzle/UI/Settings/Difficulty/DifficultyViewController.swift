//
//  DifficultyBottomSheetViewController.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 6/6/24.
//

import UIKit
import Combine

class DifficultyViewController: NiblessViewController {
    
    let viewModel: DifficultyViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: DifficultyViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = DifficultyRootView(viewModel: viewModel)
    }
}
