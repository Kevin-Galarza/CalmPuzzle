//
//  PuzzleDataStore.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation
import Combine

protocol PuzzleDataStore {
    
    func create(puzzle: Puzzle) -> AnyPublisher<Puzzle?, Error>
    func fetchAll() -> AnyPublisher<[Puzzle]?, Error>
    func fetch(ids: Set<PuzzleID>) -> AnyPublisher<[Puzzle]?, Error>
}
