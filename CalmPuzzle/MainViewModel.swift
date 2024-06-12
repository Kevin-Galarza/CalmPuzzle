//
//  MainViewModel.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation
import Combine

class MainViewModel: SignedInResponder, NotSignedInResponder {

    @Published public private(set) var view: MainView = .launching

    init() {}

    func notSignedIn() {
        view = .onboarding
    }

    func signedIn() {
        view = .signedIn
    }
}
