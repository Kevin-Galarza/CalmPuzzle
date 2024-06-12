//
//  DifficultyViewModel.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 6/6/24.
//

import Foundation
import Combine

class DifficultyViewModel {
    
    let userProfilePublisher: AnyPublisher<UserProfile?, Error>
    let userProfileRepository: UserProfileRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(userProfilePublisher: AnyPublisher<UserProfile?, Error>, userProfileRepository: UserProfileRepository) {
        self.userProfilePublisher = userProfilePublisher
        self.userProfileRepository = userProfileRepository
        
        userProfilePublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .first()
            .sink(receiveCompletion: { completion in

            }, receiveValue: { [weak self] userProfile in
                // do settings stuff here with user profile
            })
            .store(in: &subscriptions)
    }
}
