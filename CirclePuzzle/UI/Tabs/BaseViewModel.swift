//
//  SignedInViewModel.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation
import Combine

class BaseViewModel {
    
    let presentSettingsPublisher = PassthroughSubject<Void, Never>()
    
    func showSettings() {
        presentSettingsPublisher.send()
    }
}
