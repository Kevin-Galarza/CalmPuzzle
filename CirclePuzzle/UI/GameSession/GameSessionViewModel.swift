//
//  GameSessionViewModel.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/23/24.
//

import Foundation
import Combine

//class GameSessionViewModel {
//    
//    let userProfileRepository: UserProfileRepository
//    let puzzleRepository: PuzzleRepository
//    
//    let puzzle: Puzzle
//    let progress: [UserProfile.Tile]?
//    
//    init(userProfileRepository: UserProfileRepository, puzzleRepository: PuzzleRepository, puzzle: Puzzle, progress: [UserProfile.Tile]?) {
//        self.userProfileRepository = userProfileRepository
//        self.puzzleRepository = puzzleRepository
//        self.puzzle = puzzle
//        self.progress = progress
//    }
//    
//    
//}

import UIKit
import Combine

struct Tile {
    let id: Int
    var image: UIImage
    var currentIndex: Int
    let correctIndex: Int

    var isCorrectPosition: Bool {
        return currentIndex == correctIndex
    }
}

class GameSessionViewModel {
    
    let userProfileRepository: UserProfileRepository
    let puzzleRepository: PuzzleRepository
    
    private(set) var gridSize: Int = 5
    
    @Published var tiles: [Tile] = []
    @Published var isGameCompleted = false
    @Published var selectedTileIndex: Int?
    
    var swapPublisher = PassthroughSubject<(Int, Int), Never>()
    
    init(userProfileRepository: UserProfileRepository, puzzleRepository: PuzzleRepository, puzzle: Puzzle, progress: [UserProfile.Tile]?) {
        self.userProfileRepository = userProfileRepository
        self.puzzleRepository = puzzleRepository
        setGridSize(from: puzzle.difficulty)
        initializeTiles(from: puzzle, with: progress)
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
            // Shuffle tiles directly in the existing array if no progress is provided
            tiles.shuffle()
            // Update currentIndex after shuffling to match new positions
            for (newIndex, tile) in tiles.enumerated() {
                tiles[newIndex].currentIndex = newIndex
            }
        }
    }
    
    func selectTile(at index: Int) {
        guard index < tiles.count else { return }
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
        tiles[index1].currentIndex = index2
        tiles[index2].currentIndex = index1
        tiles.swapAt(index1, index2)
        swapPublisher.send((index1, index2))
        checkGameCompletion()
    }
    
    private func checkGameCompletion() {
        isGameCompleted = tiles.allSatisfy { $0.isCorrectPosition }
        if isGameCompleted {
            print("you won")
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
}
