//
//  OnboardingContainer.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation

class OnboardingContainer {
    
    let sharedUserProfileRepository: UserProfileRepository
    let sharedMainViewModel: MainViewModel
    
    let sharedOnboardingViewModel: OnboardingViewModel
    
    init(appContainer: AppContainer) {
        func makeOnboardingViewModel() -> OnboardingViewModel {
            return OnboardingViewModel()
        }
        
        self.sharedUserProfileRepository = appContainer.sharedUserProfileRepository
        self.sharedMainViewModel = appContainer.sharedMainViewModel
        
        self.sharedOnboardingViewModel = makeOnboardingViewModel()
    }
    
    func makeOnboardingViewController() -> OnboardingViewController {
        return OnboardingViewController(viewModel: sharedOnboardingViewModel)
    }
}
