//
//  MockPuzzleDataStore.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation
import Combine

class MockPuzzleDataStore: PuzzleDataStore {
    private var data: [Puzzle]

    init(data: [Puzzle] = []) {
        self.data = data
    }

    func create(puzzle: Puzzle) -> AnyPublisher<Puzzle?, Error> {
        return Future<Puzzle?, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                self.data.append(puzzle)
                promise(.success(puzzle))
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchAll() -> AnyPublisher<[Puzzle]?, Error> {
        return Future<[Puzzle]?, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                promise(.success(self.data))
            }
        }
        .eraseToAnyPublisher()
    }
}
