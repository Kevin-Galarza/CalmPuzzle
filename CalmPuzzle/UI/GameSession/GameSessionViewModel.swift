//
//  GameSessionViewModel.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/23/24.
//

import UIKit
import Combine

// TODO: Lock tiles in the correct position, expose locked tile publisher to play shake animation on tile
// TODO: Extend game session with post game: show completed puzzle image, present next puzzle & menu buttons, puzzle complete label, sounds

class GameSessionViewModel {
    
    let userProfilePublisher: AnyPublisher<UserProfile?, Error>
    let userProfileRepository: UserProfileRepository
    let puzzleRepository: PuzzleRepository
    
    let puzzleID: PuzzleID
    
    private(set) var gridSize: Int = 5
    
    @Published var tiles: [Tile] = []
    @Published var isGameCompleted = false
    @Published var selectedTileIndex: Int?
    
    let swapPublisher = PassthroughSubject<(Int, Int), Never>()
    let dismissPublisher = PassthroughSubject<Void, Never>()
    let lockedTilePublisher = PassthroughSubject<Int, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(userProfileRepository: UserProfileRepository, puzzleRepository: PuzzleRepository, puzzle: Puzzle, userProfilePublisher: AnyPublisher<UserProfile?, Error>) {
        self.userProfilePublisher = userProfilePublisher
        self.userProfileRepository = userProfileRepository
        self.puzzleRepository = puzzleRepository
        self.puzzleID = puzzle.id
        
        userProfilePublisher
            .compactMap { $0 }  // Ensure the UserProfile is not nil
            .receive(on: DispatchQueue.main)
            .first()
            .sink(receiveCompletion: { completion in

            }, receiveValue: { [weak self] userProfile in
                let progress = userProfile.appProgress.ongoingPuzzles?[puzzle.id]
                self?.setGridSize(from: userProfile.difficulty)
                self?.initializeTiles(from: puzzle, with: progress)
            })
            .store(in: &subscriptions)
    }
    
    func selectTile(at index: Int) {
        guard index < tiles.count else { return }
        
        if isTileLocked(index: index) {
            lockedTilePublisher.send(index)
            return
        }
        
        if let selectedIndex = selectedTileIndex {
            if selectedIndex == index {
                selectedTileIndex = nil
            } else {
                swapTiles(index1: selectedIndex, index2: index)
                selectedTileIndex = nil
            }
        } else {
            selectedTileIndex = index
        }
    }
    
    func swapTiles(index1: Int, index2: Int) {
        guard index1 < tiles.count, index2 < tiles.count else { return }
        swapPublisher.send((index1, index2)) // TODO: Verify swap publisher will always complete execution before the tiles data in view model is updated. Might have a race condition between tiles publisher and swap publisher.
        tiles[index1].currentIndex = index2
        tiles[index2].currentIndex = index1
        tiles.swapAt(index1, index2)
        checkGameCompletion()
    }
    
    func dismiss() {
        dismissPublisher.send()
    }
    
    func provideHint() {
        let misplacedTiles = tiles.filter { $0.isCorrectPosition == false }
        guard let randomMisplacedTile = misplacedTiles.randomElement() else {
            print("No hint available: All tiles are correctly placed or no tiles available.")
            return
        }
        
        let tileAtCorrectPosition = tiles.firstIndex { $0.currentIndex == randomMisplacedTile.correctIndex }
        guard let swapWithIndex = tileAtCorrectPosition else {
            print("No suitable tile found for swapping.")
            return
        }

        swapTiles(index1: randomMisplacedTile.currentIndex, index2: swapWithIndex)
    }
    
    private func isTileLocked(index: Int) -> Bool {
        let tile = tiles[index]
        return tile.isCorrectPosition // tile is locked if isCorrectPosition == true
    }
    
    private func setGridSize(from difficulty: Difficulty) {
        switch difficulty {
        case .easy:
            gridSize = 3
        case .medium:
            gridSize = 5
        case .hard:
            gridSize = 7
        case .pro:
            gridSize = 9
        }
    }
    
    private func initializeTiles(from puzzle: Puzzle, with progress: [UserProfile.Tile]?) {
        guard let image = UIImage(named: puzzle.name) else { return }
        let tileImages = extractTileSections(image: image, gridSize: gridSize)
        tiles = tileImages.enumerated().map { (index, image) in
            let id = index
            let correctIndex = index
            let currentIndex = progress?.first(where: { $0.id == index })?.currentIndex ?? index
            return Tile(id: id, image: image, currentIndex: currentIndex, correctIndex: correctIndex)
        }

        if let progress = progress {
            // Sort tiles to match the currentIndex to their index in the array if progress exists
            tiles.sort(by: { $0.currentIndex < $1.currentIndex })
        } else {
            tiles.shuffle()
            // Update currentIndex after shuffling to match new positions
            for (newIndex, tile) in tiles.enumerated() {
                tiles[newIndex].currentIndex = newIndex
            }
        }
    }
    
    private func checkGameCompletion() {
        isGameCompleted = tiles.allSatisfy { $0.isCorrectPosition }
        if isGameCompleted {
            saveAsCompleted()
        } else {
            saveAsOngoing()
        }
    }
    
    private func extractTileSections(image: UIImage, gridSize: Int) -> [UIImage] {
        var tileImages: [UIImage] = []
        let tileWidth = image.size.width / CGFloat(gridSize)
        let tileHeight = image.size.height / CGFloat(gridSize)
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let x = CGFloat(col) * tileWidth
                let y = CGFloat(row) * tileHeight
                let rect = CGRect(x: x, y: y, width: tileWidth, height: tileHeight)
                if let tileImage = image.cgImage?.cropping(to: rect) {
                    tileImages.append(UIImage(cgImage: tileImage))
                }
            }
        }
        
        return tileImages
    }
    
    private func createRestoreData() -> [PuzzleID : [UserProfile.Tile]] {
        let puzzleState = tiles.map { UserProfile.Tile(id: $0.id, currentIndex: $0.currentIndex, correctIndex: $0.correctIndex) }
        let record: [PuzzleID : [UserProfile.Tile]] = [self.puzzleID : puzzleState]
        return record
    }
    
    private func saveAsOngoing() {
        let restoreData = createRestoreData()
        userProfileRepository
            .updateProgress(ongoingPuzzle: restoreData)
            .receive(on: DispatchQueue.main)
            .first()
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscriptions)
    }
    
    private func saveAsCompleted() {
        userProfileRepository
            .updateProgress(completedPuzzle: self.puzzleID)
            .receive(on: DispatchQueue.main)
            .first()
            .sink(receiveCompletion: { _ in}, receiveValue: { profile in
//                print("SaveAsCompleted: \(profile)")
            })
            .store(in: &subscriptions)
    }
}

extension GameSessionViewModel {
    private func debugTiles() {
        print("")
        for (index, tile) in tiles.enumerated() {
            print("index: \(index) - tile current: \(tile.currentIndex), tile correct: \(tile.correctIndex) ")
        }
    }
}
