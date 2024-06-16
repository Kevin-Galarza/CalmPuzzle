//
//  Authenticator.swift
//  CalmPuzzle
//
//  Created by Kevin Galarza on 6/13/24.
//

import Foundation
import Combine
import GameKit
import FirebaseAuth

enum AuthenticationError: Error {
    case networkUnavailable
    case userCancelled
    case invalidCredentials
    case permissionDenied
    case unknownError
    case customError(message: String)

    var localizedDescription: String {
        switch self {
        case .networkUnavailable:
            return "The network is unavailable. Please check your connection and try again."
        case .userCancelled:
            return "User cancelled the authentication process."
        case .invalidCredentials:
            return "The credentials provided are invalid. Please try again."
        case .permissionDenied:
            return "Permission was denied. Ensure the correct permissions are granted."
        case .unknownError:
            return "An unknown error occurred during authentication."
        case .customError(let message):
            return message
        }
    }
}

// TODO: Fix this mess :P
class Authenticator {
    
    private let userDefaultsLocalUID = "localUID"
    
    private(set) var uid: String
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        if let uid = UserDefaults.standard.string(forKey: userDefaultsLocalUID) {
            self.uid = uid
        } else {
            let uid = UUID().uuidString
            UserDefaults.standard.set(uid, forKey: userDefaultsLocalUID)
            self.uid = uid
        }
    }
    
//    private func authenticate() -> AnyPublisher<String, Never> {
//        return Future <String, Never> { promise in
//            if NetworkReachability.shared.isConnected {
//                // online
//                Auth.auth().signInAnonymously { authResult, error in
//                    if let error = error {
//                        print(error)
//                        return promise(.success(self.uid))
//                    }
//                    let firebaseUID = authResult?.user.uid
//                    let localUID = self.uid
//                    if firebaseUID == localUID {
//                        return promise(.success(self.uid))
//                    } else {
//                        
//                        UserDefaults.standard.setValue(firebaseUID, forKey: self.userDefaultsLocalUID)
//                        promise(.success(self.uid))
//                    }
//                }
//            } else {
//                // offline
//                return promise(.success(self.uid))
//            }
//        }
//        .eraseToAnyPublisher()
//    }
}
