//
//  Puzzle.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation

enum Difficulty: String, Codable {
    case easy, medium, hard, pro
}

struct Puzzle: Codable {
    
    let id: String
    let name: String
    let url: URL
    let categories: [PuzzleCategory]
    let isPremium: Bool
    let difficulty: Difficulty
}
