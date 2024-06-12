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
    
    private var subscriptions = Set<AnyCancellable>()
    
    // child vc
    var gameSessionViewController: GameSessionViewController?
    var settingsViewController: SettingsViewController?
    
    // factory
    let makeGameSessionViewController: (Puzzle) -> GameSessionViewController
    let makeSettingsViewController: () -> SettingsViewController
    
    init(viewModel: MyPuzzlesViewModel, gameSessionViewControllerFactory: @escaping (Puzzle) -> GameSessionViewController, settingsViewControllerFactory: @escaping () -> SettingsViewController) {
        self.viewModel = viewModel
        self.makeGameSessionViewController = gameSessionViewControllerFactory
        self.makeSettingsViewController = settingsViewControllerFactory
        super.init()
        
        viewModel
            .presentGameSessionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] puzzle in
                guard let strongSelf = self else { return }
                strongSelf.presentGameSessionViewController(puzzle: puzzle)
            }
            .store(in: &subscriptions)
        
        viewModel
            .presentSettingsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentSettingsViewController()
            }
            .store(in: &subscriptions)
    }
    
    override func loadView() {
        view = MyPuzzlesRootView(viewModel: viewModel)
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
    
    func presentSettingsViewController() {
        if let _ = settingsViewController {
            remove(childViewController: settingsViewController)
            settingsViewController = nil
        }
        
        let settingsViewControllerToPresent = makeSettingsViewController()
        settingsViewController = settingsViewControllerToPresent
        
        presentFullScreenModal(childViewController: settingsViewControllerToPresent)
    }
}
