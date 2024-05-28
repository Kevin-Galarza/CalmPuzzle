//
//  ViewController.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/16/24.
//

import UIKit

class ViewController: UIViewController {
    
    var selectedTile: UIImageView?
    var tiles: [[UIImageView]] = []
    let gridSize = 5
    let tileSize: CGFloat = 375 / 5  // Assuming the image size is 375x375 and grid is 5x5
    var shuffledTiles: [UIImageView] = []
    var originalTilePositions: [UIImageView: (row: Int, col: Int)] = [:]
    
    var sourceImage: UIImage!
    var puzzleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        // Load the source image
        guard let inputImage = UIImage(named: "merchant.png") else { return }
        sourceImage = inputImage
        
        // Create the puzzle view to hold the tiles
        puzzleView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 375))
        puzzleView.center = view.center
        view.addSubview(puzzleView)
        
        setupTiles()
        
        // Add tap gesture recognizer to the main view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupTiles() {
        let tileImages = extractTileSections(image: sourceImage, gridSize: gridSize)
        var tileImageViews: [UIImageView] = []

        for (index, tileImage) in tileImages.enumerated() {
            let row = index / gridSize
            let col = index % gridSize
            let tileImageView = UIImageView(image: tileImage)
            tileImageView.contentMode = .scaleAspectFill
            tileImageView.clipsToBounds = true
            tileImageView.isUserInteractionEnabled = true
            tileImageView.layer.borderWidth = 2
            tileImageView.layer.borderColor = UIColor.clear.cgColor
            tileImageViews.append(tileImageView)

            // Store the original position
            originalTilePositions[tileImageView] = (row, col)
        }

        shuffledTiles = tileImageViews.shuffled()

        for (index, tileImageView) in shuffledTiles.enumerated() {
            let row = index / gridSize
            let col = index % gridSize
            tileImageView.frame = CGRect(x: CGFloat(col) * tileSize, y: CGFloat(row) * tileSize, width: tileSize, height: tileSize)
            puzzleView.addSubview(tileImageView)

            if row >= tiles.count {
                tiles.append([UIImageView]())
            }
            tiles[row].append(tileImageView)

            // Add center view indicator only if the tile is not already in the correct position
            if originalTilePositions[tileImageView]! != (row, col) {
                let centerView = UIView(frame: CGRect(x: (tileSize - 10) / 2, y: (tileSize - 10) / 2, width: 10, height: 10))
                centerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                centerView.tag = 101 // Assign a tag to easily find and remove later
                tileImageView.addSubview(centerView)
            }
        }
    }

    func updateTileBorders() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let tile = tiles[row][col]
                updateTileBorder(tile: tile)
            }
        }
    }

    func updateTileBorder(tile: UIImageView) {
        guard let originalPos = originalTilePositions[tile], let currentPos = indexOfTile(tile: tile) else { return }

        if originalPos == currentPos {
            tile.layer.borderColor = UIColor.clear.cgColor
            // Remove the center view if the tile is in the correct position
            tile.viewWithTag(101)?.removeFromSuperview()
        } else {
            tile.layer.borderColor = UIColor.clear.cgColor
            if tile.viewWithTag(101) == nil {
                // If there's no center view and the tile is not in the correct position, add it
                let centerView = UIView(frame: CGRect(x: (tileSize - 10) / 2, y: (tileSize - 10) / 2, width: 10, height: 10))
                centerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                centerView.tag = 101
                tile.addSubview(centerView)
            }
        }
    }

    func selectTile(tile: UIImageView) {
        selectedTile?.layer.borderColor = UIColor.lightGray.cgColor
        tile.layer.borderColor = UIColor.yellow.cgColor
        selectedTile = tile
    }

    func deselectTile(tile: UIImageView) {
        updateTileBorder(tile: tile)
    }

    
    func extractTileSections(image: UIImage, gridSize: Int) -> [UIImage] {
        var tileSections: [UIImage] = []
        let tileWidth = image.size.width / CGFloat(gridSize)
        let tileHeight = image.size.height / CGFloat(gridSize)
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let tileRect = CGRect(x: CGFloat(col) * tileWidth, y: CGFloat(row) * tileHeight, width: tileWidth, height: tileHeight)
                if let tileImage = cropImage(image: image, toRect: tileRect) {
                    tileSections.append(tileImage)
                }
            }
        }
        return tileSections
    }
    
    func cropImage(image: UIImage, toRect rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: puzzleView)
        
        if let tappedTile = tiles.flatMap({ $0 }).first(where: { $0.frame.contains(touchLocation) }) {
            if let selectedTile = selectedTile {
                // Swap the tiles
                swapTiles(tile1: selectedTile, tile2: tappedTile)
                deselectTile(tile: selectedTile)
                self.selectedTile = nil
            } else {
                // Select the tile
                selectTile(tile: tappedTile)
                self.selectedTile = tappedTile
            }
        } else {
            // Deselect the selected tile if tapped outside the tile grid
            if let selectedTile = selectedTile {
                deselectTile(tile: selectedTile)
                self.selectedTile = nil
            }
        }
        
        // Check if the puzzle is solved
        if isPuzzleSolved() {
            print("Puzzle Solved!")
        }
    }
    
    func swapTiles(tile1: UIImageView, tile2: UIImageView) {
        let tempFrame = tile1.frame
        UIView.animate(withDuration: 0.3) {
            tile1.frame = tile2.frame
            tile2.frame = tempFrame
        }

        // Swap positions in the tiles array
        if let index1 = indexOfTile(tile: tile1), let index2 = indexOfTile(tile: tile2) {
            tiles[index1.row][index1.col] = tile2
            tiles[index2.row][index2.col] = tile1
        }

        // Update borders for swapped tiles
        updateTileBorder(tile: tile1)
        updateTileBorder(tile: tile2)
    }
    
    func indexOfTile(tile: UIImageView) -> (row: Int, col: Int)? {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if tiles[row][col] == tile {
                    return (row, col)
                }
            }
        }
        return nil
    }
    
    func isPuzzleSolved() -> Bool {
        for (tile, originalPosition) in originalTilePositions {
            if let currentPosition = indexOfTile(tile: tile), currentPosition != originalPosition {
                return false
            }
        }
        return true
    }
}
