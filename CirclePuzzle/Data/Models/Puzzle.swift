//
//  Puzzle.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation

struct Puzzle: Codable {
    
    let id: String
    let name: String
    let url: URL
    let categories: [PuzzleCategory]
    let isPremium: Bool
    let premiumPackageID: PremiumPackageID?
}
