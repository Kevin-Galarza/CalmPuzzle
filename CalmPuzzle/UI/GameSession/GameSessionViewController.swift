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
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: GameSessionViewModel) {
        self.viewModel = viewModel
        super.init()
        
        viewModel
            .dismissPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.dismiss(animated: true)
            })
            .store(in: &subscriptions)
    }
    
    override func loadView() {
        view = GameSessionRootView(viewModel: viewModel)
    }
}
