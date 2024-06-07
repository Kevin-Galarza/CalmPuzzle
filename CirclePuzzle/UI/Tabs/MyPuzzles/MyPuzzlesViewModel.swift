//
//  MyPuzzlesViewModel.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import Combine
import Foundation

enum MyPuzzlesSegment: Int {
    case inProgress = 0
    case completed = 1
}

class MyPuzzlesViewModel: BaseViewModel {
    
    let userProfileRepository: UserProfileRepository
    let puzzleRepository: PuzzleRepository
    
    var userProfile: UserProfile?
    
    @Published var selectedSegment: MyPuzzlesSegment = .inProgress
    @Published var puzzles: [Puzzle]?
    
    private var userProfilePublisher: AnyPublisher<UserProfile?, Error>
    
    let presentGameSessionPublisher = PassthroughSubject<Puzzle, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(signedInContainer: SignedInContainer) {
        self.userProfileRepository = signedInContainer.userProfileRepository
        self.puzzleRepository = signedInContainer.puzzleRepository
        self.userProfilePublisher = signedInContainer.userProfilePublisher
        super.init()
        
        userProfilePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] userProfile in
//                print("MyPuzzles User Profile updated: \(userProfile)")
                self?.userProfile = userProfile
                self?.fetchPuzzles(using: userProfile)
            })
            .store(in: &subscriptions)
        
        $selectedSegment
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchPuzzles(using: self?.userProfile)
            }
            .store(in: &subscriptions)
    }
    
    func fetchPuzzles(using userProfile: UserProfile?) {
        guard let userProfile = userProfile else { return }
        
        let ids: Set<PuzzleID> = {
            if self.selectedSegment == .inProgress {
                if let keys = userProfile.appProgress.ongoingPuzzles?.keys {
                    return Set<PuzzleID>(keys)
                }
                return Set<PuzzleID>()
            } else {
                return userProfile.appProgress.completedPuzzles ?? Set()
            }
        }()
        
        self.puzzleRepository.fetch(ids: ids)
            .receive(on: DispatchQueue.main)
            .first()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching puzzles: \(error)")
                }
            }, receiveValue: { [weak self] puzzles in
                self?.puzzles = puzzles
            })
            .store(in: &self.subscriptions)
    }
    
    func handlePuzzleSelection(index: Int) {
        guard let puzzle = puzzles?[index] else { return }
        presentGameSessionPublisher.send(puzzle)
    }
}
