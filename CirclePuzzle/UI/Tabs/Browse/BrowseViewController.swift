//
//  BrowseViewController.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class BrowseViewController: NiblessViewController {
    
    let viewModel: BrowseViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    // child vc
    var gameSessionViewController: GameSessionViewController?
    
    // factory
    let makeGameSessionViewController: (Puzzle) -> GameSessionViewController
    
    init(viewModel: BrowseViewModel, gameSessionViewControllerFactory: @escaping (Puzzle) -> GameSessionViewController) {
        self.viewModel = viewModel
        self.makeGameSessionViewController = gameSessionViewControllerFactory
        super.init()
        
        viewModel
            .presentGameSessionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] puzzle in
                guard let strongSelf = self else { return }
                strongSelf.presentGameSessionViewController(puzzle: puzzle)
            }
            .store(in: &subscriptions)
    }
    
    override func loadView() {
        view = BrowseRootView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        viewModel.fetchPuzzles()
    }
    
    func presentGameSessionViewController(puzzle: Puzzle) {
        if let _ = gameSessionViewController {
            remove(childViewController: gameSessionViewController)
            gameSessionViewController = nil
        }
        
        let gameSessionViewControllerToPresent = makeGameSessionViewController(puzzle)
        gameSessionViewController = gameSessionViewControllerToPresent

        presentFullScreenModal(childViewController: gameSessionViewControllerToPresent)
    }
}
