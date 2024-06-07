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
    
    var settingsViewController: SettingsViewController?
    
    let makeSettingsViewController: () -> SettingsViewController
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: DailyPuzzleViewModel, settingsViewControllerFactory: @escaping () -> SettingsViewController) {
        self.viewModel = viewModel
        self.makeSettingsViewController = settingsViewControllerFactory
        super.init()
        
        viewModel
            .presentSettingsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentSettingsViewController()
            }
            .store(in: &subscriptions)
    }
    
    override func loadView() {
        view = DailyPuzzleRootView(viewModel: viewModel)
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
