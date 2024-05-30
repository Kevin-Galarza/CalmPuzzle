//
//  RootContainer.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/20/24.
//

import Foundation

class AppContainer {
    
    let sharedUserProfileRepository: UserProfileRepository
    let sharedPuzzleRepository: PuzzleRepository
    let sharedMainViewModel: MainViewModel
    
    init() {
        func makeUserProfileRepository() -> UserProfileRepository {
            let dataStore = makeUserProfileDataStore()
            return UserProfileRepository(dataStore: dataStore)
            
        }
        
        func makeMockUserProfile() -> UserProfile {
            let appSettings = UserProfile.AppSettings(musicEnabled: true, soundEffectsEnabled: true, hapticsEnabled: true)
            let appProgress = UserProfile.AppProgress(completedPuzzles: nil, ongoingPuzzles: nil)
            let deviceInfo = UserProfile.DeviceInfo(deviceModel: "iPhone 15 Pro", osVersion: "17.3.1")
            return UserProfile(uid: UUID().uuidString,
                       appSettings: appSettings,
                       appProgress: appProgress,
                       deviceInfo: deviceInfo,
                       adsEnabled: true,
                       hints: 10,
                       coins: 100,
                       credits: 10,
                       createdTimestamp: Date())
        }
        
        func makeUserProfileDataStore() -> UserProfileDataStore {
            #if DEBUG
                let data = makeMockUserProfile()
                return MockUserProfileDataStore(data: data)
            #else
                return RealmUserProfileDataStore()
            #endif
        }
        
        func makePuzzleRepository() -> PuzzleRepository {
            let dataStore = makePuzzleDataStore()
            return PuzzleRepository(dataStore: dataStore)
        }
        
        func makeMockPuzzleData() -> [Puzzle] {
            let jsonString = """
            [
                {
                    "id": "puzzle1",
                    "name": "merchant.png",
                    "url": "http://example.com/sunset-puzzle",
                    "categories": [
                        "all",
                        "easy"
                    ],
                    "isPremium": false,
                    "difficulty": "easy"
                },
                {
                    "id": "puzzle2",
                    "name": "merchant.png",
                    "url": "http://example.com/cityscape-puzzle",
                    "categories": [
                        "all",
                        "hard",
                        "premium"
                    ],
                    "isPremium": true,
                    "difficulty": "hard"
                },
                {
                    "id": "puzzle3",
                    "name": "merchant.png",
                    "url": "http://example.com/sunset-puzzle",
                    "categories": [
                        "all",
                        "easy"
                    ],
                    "isPremium": false,
                    "difficulty": "easy"
                },
                {
                    "id": "puzzle4",
                    "name": "merchant.png",
                    "url": "http://example.com/cityscape-puzzle",
                    "categories": [
                        "all",
                        "hard",
                        "premium"
                    ],
                    "isPremium": true,
                    "difficulty": "hard"
                },
                {
                    "id": "puzzle5",
                    "name": "merchant.png",
                    "url": "http://example.com/sunset-puzzle",
                    "categories": [
                        "all",
                        "easy"
                    ],
                    "isPremium": false,
                    "difficulty": "easy"
                },
                {
                    "id": "puzzle6",
                    "name": "merchant.png",
                    "url": "http://example.com/cityscape-puzzle",
                    "categories": [
                        "all",
                        "hard",
                        "premium"
                    ],
                    "isPremium": true,
                    "difficulty": "hard"
                },
                {
                    "id": "puzzle7",
                    "name": "merchant.png",
                    "url": "http://example.com/sunset-puzzle",
                    "categories": [
                        "all",
                        "easy"
                    ],
                    "isPremium": false,
                    "difficulty": "easy"
                },
                {
                    "id": "puzzle8",
                    "name": "merchant.png",
                    "url": "http://example.com/cityscape-puzzle",
                    "categories": [
                        "all",
                        "hard",
                        "premium"
                    ],
                    "isPremium": true,
                    "difficulty": "hard"
                }
            ]
            """
            
            do {
                let data = Data(jsonString.utf8)
                let puzzles = try JSONDecoder().decode([Puzzle].self, from: data)
                return puzzles
            } catch {
                print("Failed to decode JSON: \(error)")
                return []
            }
        }
        
        func makePuzzleDataStore() -> PuzzleDataStore {
            #if DEBUG
                let data = makeMockPuzzleData()
                return MockPuzzleDataStore(data: data)
            #else
            
            #endif
        }
        
        func makeMainViewModel() -> MainViewModel {
          return MainViewModel()
        }

        self.sharedUserProfileRepository = makeUserProfileRepository()
        self.sharedPuzzleRepository = makePuzzleRepository()
        self.sharedMainViewModel = makeMainViewModel()
    }
    
    // MARK: Main
    
    func makeMainViewController() -> MainViewController {
        let launchViewController = makeLaunchViewController()

        let onboardingViewControllerFactory = {
          return self.makeOnboardingViewController()
        }
        
        let signedInViewControllerFactory = {
          return self.makeSignedInViewController()
        }

        return MainViewController(viewModel: self.sharedMainViewModel,
                                  launchViewController: launchViewController,
                                  onboardingViewControllerFactory: onboardingViewControllerFactory,
                                  signedInViewControllerFactory: signedInViewControllerFactory)
    }
    
    // MARK: Launching
    
    func makeLaunchViewController() -> LaunchViewController {
        return LaunchViewController(launchViewModelFactory: self)
    }
    
    func makeLaunchViewModel() -> LaunchViewModel {
        return LaunchViewModel(userProfileRepository: sharedUserProfileRepository, notSignedInResponder: sharedMainViewModel, signedInResponder: sharedMainViewModel)
    }
    
    // MARK: Onboarding
    
    func makeOnboardingViewController() -> OnboardingViewController {
        let onboardingContainer = OnboardingContainer(appContainer: self)
        return onboardingContainer.makeOnboardingViewController()
    }
    
    // MARK: Signed-in

    func makeSignedInViewController() -> SignedInViewController {
        let dependencyContainer = makeSignedInContainer()
        return dependencyContainer.makeSignedInViewController()
    }

    func makeSignedInContainer() -> SignedInContainer  {
        return SignedInContainer(appContainer: self)
    }
}

extension AppContainer: LaunchViewModelFactory {}
