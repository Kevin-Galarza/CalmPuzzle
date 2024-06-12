//
//  Puzzle.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation

/*
 Firestore Format:
 
 Collection: Puzzles
    Document ID: `id` (String)
    Document: Puzzle
        `id`: String
        `name`: String
        `url`: String
        `categories`: [String]
        `isPremium`: Boolean
        `premiumPackageID`: String (nullable)
 */

struct Puzzle: Codable {
    
    let id: String
    let name: String
    let url: URL
    let categories: [PuzzleCategory]
    let isPremium: Bool
    let premiumPackageID: PremiumPackageID?
}
