//
//  BrowseViewModel.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import Foundation
import Combine

class BrowseViewModel: BaseViewModel {
    
    let userProfileRepository: UserProfileRepository
    let puzzleRepository: PuzzleRepository
    
    let puzzleCategories: [PuzzleCategory]
    
    var puzzles: [Puzzle]?
    
    @Published var selectedPuzzleCategory: PuzzleCategory
    @Published var filteredPuzzles: [Puzzle]?
    
    let presentGameSessionPublisher = PassthroughSubject<Puzzle, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(userProfileRepository: UserProfileRepository, puzzleRepository: PuzzleRepository, selectedPuzzleCategory: PuzzleCategory = .all) {
        self.userProfileRepository = userProfileRepository
        self.puzzleRepository = puzzleRepository
        self.puzzleCategories = PuzzleCategory.allCases
        self.selectedPuzzleCategory = selectedPuzzleCategory
        super.init()
        
        $selectedPuzzleCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] category in
                self?.filterPuzzles()
            }
            .store(in: &subscriptions)
    }
    
    func fetchPuzzles() {
        puzzleRepository
            .fetchAll()
            .first()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("")
                case .failure(let error):
                    print(error)
                    // TODO: handle error
                }
            },
            receiveValue: { [weak self] puzzles in
                self?.puzzles = puzzles
                self?.filterPuzzles()
            })
            .store(in: &subscriptions)
    }
    
    func handlePuzzleSelection(index: Int) {
        guard let puzzle = filteredPuzzles?[index] else { return }
        presentGameSessionPublisher.send(puzzle)
    }
    
    private func filterPuzzles() {
        guard let puzzles = self.puzzles else { return }
        self.filteredPuzzles = puzzles.filter { $0.categories.contains(selectedPuzzleCategory) }
    }
}
