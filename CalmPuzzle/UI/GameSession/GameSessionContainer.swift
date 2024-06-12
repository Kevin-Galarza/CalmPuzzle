//
//  GameSessionContainer.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/23/24.
//

import Foundation
import Combine

class GameSessionContainer {
    
    let userProfileRepository: UserProfileRepository
    let puzzleRepository: PuzzleRepository
    
    let puzzle: Puzzle
    let userProfilePublisher: AnyPublisher<UserProfile?, Error>
    
    init(puzzle: Puzzle, signedInContainer: SignedInContainer) {
        self.userProfilePublisher = signedInContainer.userProfilePublisher
        self.userProfileRepository = signedInContainer.userProfileRepository
        self.puzzleRepository = signedInContainer.puzzleRepository
        
        self.puzzle = puzzle
    }
    
    func makeGameSessionViewModel() -> GameSessionViewModel {
        return GameSessionViewModel(userProfileRepository: userProfileRepository, puzzleRepository: puzzleRepository, puzzle: puzzle, userProfilePublisher: self.userProfilePublisher)
    }
    
    func makeGameSessionViewController() -> GameSessionViewController {
        let viewModel = makeGameSessionViewModel()
        return GameSessionViewController(viewModel: viewModel)
    }
}
