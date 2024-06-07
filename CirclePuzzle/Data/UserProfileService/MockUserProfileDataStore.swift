//
//  MockUserProfileDataStore.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation
import Combine

class MockUserProfileDataStore: UserProfileDataStore {
    private var data: UserProfile?

    init(data: UserProfile?) {
        self.data = data
    }

    func create(userProfile: UserProfile) -> AnyPublisher<UserProfile?, Error> {
        return Future<UserProfile?, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                self.data = userProfile
                promise(.success(userProfile))
            }
        }
        .eraseToAnyPublisher()
    }

    func fetch() -> AnyPublisher<UserProfile?, Error> {
        return Future<UserProfile?, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                promise(.success(self.data))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(userProfile: UserProfile) -> AnyPublisher<UserProfile?, Error> {
        return Future<UserProfile?, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                self.data = userProfile
                promise(.success(userProfile))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateProgress(completedPuzzle: PuzzleID) -> AnyPublisher<UserProfile?, Error> {
        return Future<UserProfile?, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                guard let data = self.data else {
                    promise(.failure(ErrorMessage(title: "Error Updating App Progress", message: "Mock data is nil.")))
                    return
                }
                
                var newCompletedPuzzles = Set<PuzzleID>(data.appProgress.completedPuzzles ?? [])
                newCompletedPuzzles.insert(completedPuzzle)
                let ongoingPuzzles = data.appProgress.ongoingPuzzles?.filter { $0.key != completedPuzzle }

                let newProgress = UserProfile.AppProgress(
                    completedPuzzles: newCompletedPuzzles,
                    ongoingPuzzles: ongoingPuzzles
                )

                let newUserProfile = UserProfile(
                    uid: data.uid,
                    appSettings: data.appSettings,
                    appProgress: newProgress,
                    deviceInfo: data.deviceInfo,
                    adsEnabled: data.adsEnabled,
                    premiumPackagesUnlocked: data.premiumPackagesUnlocked,
                    hints: data.hints,
                    coins: data.coins,
                    credits: data.credits,
                    difficulty: data.difficulty,
                    createdTimestamp: data.createdTimestamp
                )
                self.data = newUserProfile
                promise(.success(newUserProfile))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateProgress(ongoingPuzzle: [PuzzleID : [UserProfile.Tile]]) -> AnyPublisher<UserProfile?, Error> {
        return Future<UserProfile?, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                guard let data = self.data else {
                    promise(.failure(ErrorMessage(title: "Error Updating App Progress", message: "Mock data is nil.")))
                    return
                }

                // Create mutable copies of the sets and dictionaries as needed.
                var newCompletedPuzzles = Set<PuzzleID>(data.appProgress.completedPuzzles ?? [])
                var newOngoingPuzzles: [PuzzleID : [UserProfile.Tile]] = data.appProgress.ongoingPuzzles ?? [:]
                
//                print("New Completed Puzzles: \(newCompletedPuzzles)")
//                print("New Ongoing Puzzles: \(newOngoingPuzzles)")

                // Process each ongoing puzzle provided
                for (puzzleID, tiles) in ongoingPuzzle {
                    // Remove from completed puzzles if it exists there
                    newCompletedPuzzles.remove(puzzleID)

                    // Add or update the ongoing puzzle ID in the ongoing puzzles dictionary
                    newOngoingPuzzles[puzzleID] = tiles
                }

                // Create the new app progress instance with updated data
                let newProgress = UserProfile.AppProgress(
                    completedPuzzles: newCompletedPuzzles,
                    ongoingPuzzles: newOngoingPuzzles
                )

                // Create a new user profile instance with updated app progress
                let newUserProfile = UserProfile(
                    uid: data.uid,
                    appSettings: data.appSettings,
                    appProgress: newProgress,
                    deviceInfo: data.deviceInfo,
                    adsEnabled: data.adsEnabled,
                    premiumPackagesUnlocked: data.premiumPackagesUnlocked,
                    hints: data.hints,
                    coins: data.coins,
                    credits: data.credits,
                    difficulty: data.difficulty,
                    createdTimestamp: data.createdTimestamp
                )
                self.data = newUserProfile
                promise(.success(newUserProfile))
            }
        }
        .eraseToAnyPublisher()
    }
}
