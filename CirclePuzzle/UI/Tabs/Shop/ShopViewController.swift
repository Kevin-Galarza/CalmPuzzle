//
//  ShopViewController.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class ShopViewController: NiblessViewController {
    
    let viewModel: ShopViewModel
    
    init(viewModel: ShopViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = ShopRootView(viewModel: viewModel)
    }
}
