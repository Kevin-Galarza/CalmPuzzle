//
//  PuzzleCatalogRepository.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation
import Combine

class PuzzleRepository {
    
    let dataStore: PuzzleDataStore
    
    init(dataStore: PuzzleDataStore) {
        self.dataStore = dataStore
    }
    
    func create(puzzle: Puzzle) -> AnyPublisher<Puzzle?, Error> {
        dataStore.create(puzzle: puzzle)
    }
    
    func fetchAll() -> AnyPublisher<[Puzzle]?, Error> {
        dataStore.fetchAll()
    }
    
    func fetch(ids: Set<PuzzleID>) -> AnyPublisher<[Puzzle]?, Error> {
        dataStore.fetch(ids: ids)
    }
}
