//
//  MainView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation

enum MainView {

    case launching
    case onboarding
    case signedIn(userProfile: UserProfile)
}

extension MainView: Equatable {
  
    public static func ==(lhs: MainView, rhs: MainView) -> Bool {
        switch (lhs, rhs) {
        case (.launching, .launching):
            return true
        case (.onboarding, .onboarding):
            return true
        case let (.signedIn(l), .signedIn(r)):
            return l == r
        case (.launching, _),
         (.onboarding, _),
         (.signedIn, _):
            return false
        }
    }
}
