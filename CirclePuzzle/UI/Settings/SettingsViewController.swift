//
//  SettingsViewController.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class SettingsViewController: NiblessViewController {
    
    let viewModel: SettingsViewModel
    
    var difficultyViewController: DifficultyViewController?
    
    let makeDifficultyViewController: () -> DifficultyViewController
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: SettingsViewModel, difficultyViewControllerFactory: @escaping () -> DifficultyViewController) {
        self.viewModel = viewModel
        self.makeDifficultyViewController = difficultyViewControllerFactory
        super.init()
        
        viewModel
            .dismissPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.dismiss(animated: true)
            })
            .store(in: &subscriptions)
        
        viewModel
            .presentDifficultyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("difficulty present")
                self?.presentDifficultyViewController()
            }
            .store(in: &subscriptions)
    }
    
    override func loadView() {
        view = SettingsRootView(viewModel: viewModel)
    }
    
    func presentDifficultyViewController() {
        if let _ = difficultyViewController {
            remove(childViewController: difficultyViewController)
            difficultyViewController = nil
        }
        
        let difficultyViewControllerToPresent = makeDifficultyViewController()
        difficultyViewController = difficultyViewControllerToPresent
        
        presentBottomSheetModal(childViewController: difficultyViewControllerToPresent)
    }
}
