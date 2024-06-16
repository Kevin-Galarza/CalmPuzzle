//
//  LaunchViewModel.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation
import Combine
import FirebaseAuth
import GameKit

class LaunchViewModel {

    let userProfileRepository: UserProfileRepository
    let notSignedInResponder: NotSignedInResponder
    let signedInResponder: SignedInResponder

    var errorMessages: AnyPublisher<ErrorMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    private let errorMessagesSubject = PassthroughSubject<ErrorMessage,Never>()
    let errorPresentation = PassthroughSubject<ErrorPresentation?, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(userProfileRepository: UserProfileRepository,
              notSignedInResponder: NotSignedInResponder,
              signedInResponder: SignedInResponder) {
        self.userProfileRepository = userProfileRepository
        self.notSignedInResponder = notSignedInResponder
        self.signedInResponder = signedInResponder
    }

    func loadUserProfile() {
        userProfileRepository.fetch()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Fetching puzzles completed successfully.")
                case .failure(let error):
                    print("An error occurred: \(error)")
                    let errorMessage = ErrorMessage(title: "User Profile Error", message: "Sorry, we couldn't determine if you already have a user profile. Creating a new profile.")
                    self.present(errorMessage: errorMessage)
                }
            }, receiveValue: { userProfile in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.goToNextScreen(userProfile: userProfile)
                }
            })
            .store(in: &subscriptions)
    }

    func present(errorMessage: ErrorMessage) {
        goToNextScreenAfterErrorPresentation()
        errorMessagesSubject.send(errorMessage)
    }

    func goToNextScreenAfterErrorPresentation() {
        errorPresentation
            .filter { $0 == .dismissed }
            .prefix(1)
            .sink { [weak self] _ in
                self?.goToNextScreen(userProfile: nil)
            }
            .store(in: &subscriptions)
    }

    func goToNextScreen(userProfile: UserProfile?) {
        switch userProfile {
        case .none:
            notSignedInResponder.notSignedIn()
        case .some:
            signedInResponder.signedIn()
        }
    }
}
