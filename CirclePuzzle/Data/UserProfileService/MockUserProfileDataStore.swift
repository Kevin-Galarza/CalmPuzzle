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
}
