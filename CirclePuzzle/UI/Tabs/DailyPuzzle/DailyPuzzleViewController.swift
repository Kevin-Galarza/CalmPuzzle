//
//  DailyPuzzleViewController.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class DailyPuzzleViewController: NiblessViewController {
    
    let viewModel: DailyPuzzleViewModel
    
    init(viewModel: DailyPuzzleViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = DailyPuzzleRootView(viewModel: viewModel)
    }
}
