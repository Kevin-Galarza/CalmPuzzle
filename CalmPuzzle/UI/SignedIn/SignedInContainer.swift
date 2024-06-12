//
//  SignedInContainer.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation
import Combine

class SignedInContainer {
    
    // From parent container
    let userProfileRepository: UserProfileRepository
    let puzzleRepository: PuzzleRepository
    
    // Context
    let userProfilePublisher: AnyPublisher<UserProfile?, Error>
    
    init(appContainer: AppContainer) {
        self.userProfileRepository = appContainer.sharedUserProfileRepository
        self.puzzleRepository = appContainer.sharedPuzzleRepository
        self.userProfilePublisher = userProfileRepository.profilePublisher()
    }
    
    func makeSignedInViewController() -> SignedInViewController {
        let browseViewController = makeBrowseViewController()
        let dailyPuzzleViewController = makeDailyPuzzleViewController()
        let shopViewController = makeShopViewController()
        let myPuzzlesViewController = makeMyPuzzlesViewController()
        return SignedInViewController(browseViewController: browseViewController,
                                      dailyPuzzleViewController: dailyPuzzleViewController,
                                      shopViewController: shopViewController,
                                      myPuzzlesViewController: myPuzzlesViewController)
    }
    
    // MARK: Browse
    
    func makeBrowseViewController() -> BrowseViewController {
        let viewModel = makeBrowseViewModel()
        
        let gameSessionViewControllerFactory = { (puzzle: Puzzle) in
            return self.makeGameSessionViewController(puzzle: puzzle)
        }
        
        let settingsViewControllerFactory = { () in
            return self.makeSettingsViewController()
        }
        
        return BrowseViewController(viewModel: viewModel, gameSessionViewControllerFactory: gameSessionViewControllerFactory, settingsViewControllerFactory: settingsViewControllerFactory)
    }
    
    func makeBrowseViewModel() -> BrowseViewModel {
        return BrowseViewModel(userProfileRepository: userProfileRepository, puzzleRepository: puzzleRepository)
    }
    
    // MARK: Daily Puzzle
    
    func makeDailyPuzzleViewController() -> DailyPuzzleViewController {
        let viewModel = makeDailyPuzzleViewModel()
        
        let settingsViewControllerFactory = { () in
            return self.makeSettingsViewController()
        }
        
        return DailyPuzzleViewController(viewModel: viewModel, settingsViewControllerFactory: settingsViewControllerFactory)
    }
    
    func makeDailyPuzzleViewModel() -> DailyPuzzleViewModel {
        return DailyPuzzleViewModel()
    }
    
    // MARK: Shop
    
    func makeShopViewController() -> ShopViewController {
        let viewModel = makeShopViewModel()
        return ShopViewController(viewModel: viewModel)
    }
    
    func makeShopViewModel() -> ShopViewModel {
        return ShopViewModel()
    }
    
    // MARK: My Puzzles
    
    func makeMyPuzzlesViewController() -> MyPuzzlesViewController {
        let viewModel = makeMyPuzzlesViewModel()
        
        let gameSessionViewControllerFactory = { (puzzle: Puzzle) in
            return self.makeGameSessionViewController(puzzle: puzzle)
        }
        
        let settingsViewControllerFactory = { () in
            return self.makeSettingsViewController()
        }
        
        return MyPuzzlesViewController(viewModel: viewModel, gameSessionViewControllerFactory: gameSessionViewControllerFactory, settingsViewControllerFactory: settingsViewControllerFactory)
    }
    
    func makeMyPuzzlesViewModel() -> MyPuzzlesViewModel {
        return MyPuzzlesViewModel(signedInContainer: self)
    }
    
    // MARK: GameSession
    
    func makeGameSessionViewController(puzzle: Puzzle) -> GameSessionViewController {
        let dependencyContainer = makeGameSessionContainer(puzzle: puzzle)
        return dependencyContainer.makeGameSessionViewController()
    }
    
    func makeGameSessionContainer(puzzle: Puzzle) -> GameSessionContainer {
        return GameSessionContainer(puzzle: puzzle, signedInContainer: self)
    }
    
    // MARK: Settings
    
    func makeSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel(userProfilePublisher: self.userProfilePublisher, userProfileRepository: self.userProfileRepository)
    }
    
    func makeSettingsViewController() -> SettingsViewController {
        let viewModel = makeSettingsViewModel()
        
        let difficultyViewControllerFactory = { () in
            return self.makeDifficultyViewController()
        }
        
        return SettingsViewController(viewModel: viewModel, difficultyViewControllerFactory: difficultyViewControllerFactory)
    }
    
    // MARK: Difficulty
    
    func makeDifficultyViewModel() -> DifficultyViewModel {
        return DifficultyViewModel(userProfilePublisher: self.userProfilePublisher, userProfileRepository: self.userProfileRepository)
    }
    
    func makeDifficultyViewController() -> DifficultyViewController {
        let viewModel = makeDifficultyViewModel()
        return DifficultyViewController(viewModel: viewModel)
    }
}
