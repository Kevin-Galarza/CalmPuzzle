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
    
    init(dataStore: UserProfileDataStore) {
        self.dataStore = dataStore
    }
    
    func create(userProfile: UserProfile) -> AnyPublisher<UserProfile?, Error> {
        dataStore.create(userProfile: userProfile)
    }
    
    func fetch() -> AnyPublisher<UserProfile?, Error> {
        dataStore.fetch()
    }
    
    func update(userProfile: UserProfile) -> AnyPublisher<UserProfile?, Error> {
        dataStore.update(userProfile: userProfile)
    }
}
