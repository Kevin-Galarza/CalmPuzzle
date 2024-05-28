//
//  OnboardingViewController.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import UIKit
import Combine

class OnboardingViewController: NiblessViewController {
    
    let viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
    }
}
