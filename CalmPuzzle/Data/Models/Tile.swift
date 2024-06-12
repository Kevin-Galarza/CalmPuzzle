//
//  Tile.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/28/24.
//

import UIKit

struct Tile {
    let id: Int
    var image: UIImage
    var currentIndex: Int
    let correctIndex: Int

    var isCorrectPosition: Bool {
        return currentIndex == correctIndex
    }
}
