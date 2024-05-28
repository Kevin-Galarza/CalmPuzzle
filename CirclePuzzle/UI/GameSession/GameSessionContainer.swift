//
//  GameSessionContainer.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/23/24.
//

import Foundation

class GameSessionContainer {
    
    let userProfileRepository: UserProfileRepository
    let puzzleRepository: PuzzleRepository
    
    let puzzle: Puzzle
    let userProfile: UserProfile
    
    init(puzzle: Puzzle, userProfile: UserProfile, signedInContainer: SignedInContainer) {
        self.userProfileRepository = signedInContainer.userProfileRepository
        self.puzzleRepository = signedInContainer.puzzleRepository
        
        self.puzzle = puzzle
        self.userProfile = userProfile
    }
    
    func makeGameSessionViewModel() -> GameSessionViewModel {
        let progress = userProfile.appProgress.ongoingPuzzles?[puzzle.id]
        return GameSessionViewModel(userProfileRepository: userProfileRepository, puzzleRepository: puzzleRepository, puzzle: puzzle, progress: progress)
    }
    
    func makeGameSessionViewController() -> GameSessionViewController {
        let viewModel = makeGameSessionViewModel()
        return GameSessionViewController(viewModel: viewModel)
    }
}
