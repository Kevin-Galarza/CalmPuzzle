//
//  UserProfileRepository.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation
import Combine

class UserProfileRepository {
    
    let dataStore: UserProfileDataStore
    
    private var currentUserProfile = CurrentValueSubject<UserProfile?, Error>(nil)
    
    init(dataStore: UserProfileDataStore) {
        self.dataStore = dataStore
    }
    
    func create(userProfile: UserProfile) -> AnyPublisher<UserProfile?, Error> {
        dataStore.create(userProfile: userProfile)
            .handleEvents(receiveOutput: { [weak self] profile in
                self?.currentUserProfile.send(profile)
            })
            .eraseToAnyPublisher()
    }
    
    func fetch(uid: String) -> AnyPublisher<UserProfile?, Error> {
        dataStore.fetch(uid: uid)
            .handleEvents(receiveOutput: { [weak self] profile in
                self?.currentUserProfile.send(profile)
            })
            .eraseToAnyPublisher()
    }
    
    func update(userProfile: UserProfile) -> AnyPublisher<UserProfile?, Error> {
        dataStore.update(userProfile: userProfile)
            .handleEvents(receiveOutput: { [weak self] profile in
                self?.currentUserProfile.send(profile)
            })
            .eraseToAnyPublisher()
    }

    func profilePublisher() -> AnyPublisher<UserProfile?, Error> {
        currentUserProfile.eraseToAnyPublisher()
    }
}
