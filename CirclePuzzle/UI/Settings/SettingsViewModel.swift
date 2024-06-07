//
//  SettingsViewModel.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import Foundation
import Combine

class SettingsViewModel {
    
    let userProfilePublisher: AnyPublisher<UserProfile?, Error>
    let userProfileRepository: UserProfileRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    let dismissPublisher = PassthroughSubject<Void, Never>()
    let presentDifficultyPublisher = PassthroughSubject<Void, Never>()
    
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
    
    func dismiss() {
        dismissPublisher.send()
    }
    
    func handleDifficultySelectPresentation() {
        presentDifficultyPublisher.send()
    }
}
