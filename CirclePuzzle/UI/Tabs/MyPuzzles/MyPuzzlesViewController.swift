//
//  MyPuzzlesViewController.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class MyPuzzlesViewController: NiblessViewController {
    
    let viewModel: MyPuzzlesViewModel
    
    init(viewModel: MyPuzzlesViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = MyPuzzlesRootView(viewModel: viewModel)
    }
}
