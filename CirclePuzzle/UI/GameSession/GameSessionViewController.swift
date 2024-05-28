//
//  GameSessionViewController.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/23/24.
//

import UIKit
import Combine

class GameSessionViewController: NiblessViewController {
    
    let viewModel: GameSessionViewModel
    
    init(viewModel: GameSessionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = GameSessionRootView(viewModel: viewModel)
    }
}

