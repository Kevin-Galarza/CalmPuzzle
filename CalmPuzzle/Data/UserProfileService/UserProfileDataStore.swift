//
//  UserProfileDataStore.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation
import Combine

protocol UserProfileDataStore {
    
    func create(userProfile: UserProfile) -> AnyPublisher<UserProfile?, Error>
    func fetch() -> AnyPublisher<UserProfile?, Error>
    func update(userProfile: UserProfile) -> AnyPublisher<UserProfile?, Error>
    func updateProgress(completedPuzzle: PuzzleID) -> AnyPublisher<UserProfile?, Error>
    func updateProgress(ongoingPuzzle: [PuzzleID : [UserProfile.Tile]]) -> AnyPublisher<UserProfile?, Error>
}
