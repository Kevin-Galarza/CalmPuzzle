//
//  UserProfile.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import Foundation

struct UserProfile: Codable, Equatable {
    let uid: String
    let appSettings: AppSettings
    let deviceInfo: DeviceInfo
    let adsEnabled: Bool
    let premiumPackagesUnlocked: [PremiumPackageID]?
    let hints: Int
    let coins: Int
    let credits: Int
    let difficulty: Difficulty
    let createdTimestamp: Date
    var ongoingPuzzles: Set<Puzzle>?
    var completedPuzzles: Set<PuzzleID>?

    struct AppSettings: Equatable, Codable {
        let musicEnabled: Bool
        let soundEffectsEnabled: Bool
        let hapticsEnabled: Bool
    }
    
    struct DeviceInfo: Equatable, Codable {
        let deviceModel: String
        let osVersion: String
    }

    struct Puzzle: Codable, Equatable, Hashable {
        let id: PuzzleID
        let tiles: [Tile]
        
        static func == (lhs: Puzzle, rhs: Puzzle) -> Bool {
            return lhs.id == rhs.id && lhs.tiles == rhs.tiles
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(tiles)  // This works because Array conforms to Hashable if its elements are Hashable
        }
    }

    struct Tile: Codable, Equatable, Hashable {
        let id: Int
        let currentIndex: Int
        let correctIndex: Int
    }
}

extension UserProfile {
    func updated(with changes: (inout UserProfile) -> Void) -> UserProfile {
        var mutableCopy = self
        changes(&mutableCopy)
        return mutableCopy
    }
}

extension UserProfile {
  
    static func ==(lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.uid == rhs.uid &&
            lhs.appSettings == rhs.appSettings &&
            lhs.deviceInfo == rhs.deviceInfo &&
            lhs.adsEnabled == rhs.adsEnabled &&
            lhs.premiumPackagesUnlocked == rhs.premiumPackagesUnlocked &&
            lhs.hints == lhs.hints &&
            lhs.coins == rhs.coins &&
            lhs.credits == rhs.credits &&
            lhs.difficulty == rhs.difficulty &&
            lhs.createdTimestamp == rhs.createdTimestamp &&
            lhs.ongoingPuzzles == rhs.ongoingPuzzles &&
            lhs.completedPuzzles == rhs.completedPuzzles
    }
}


//struct UserProfile: Codable {
//    
//    let uid: String
//    let appSettings: AppSettings
//    let appProgress: AppProgress
//    let deviceInfo: DeviceInfo
//    let adsEnabled: Bool
//    let premiumPackagesUnlocked: [PremiumPackageID]?
//    let hints: Int
//    let coins: Int
//    let credits: Int
//    let difficulty: Difficulty
//    let createdTimestamp: Date
//    
//    struct DeviceInfo: Equatable, Codable {
//        let deviceModel: String
//        let osVersion: String
//    }
//
//    struct AppSettings: Equatable, Codable {
//        let musicEnabled: Bool
//        let soundEffectsEnabled: Bool
//        let hapticsEnabled: Bool
//    }
//
//    struct AppProgress: Equatable, Codable {
//        let completedPuzzles: Set<PuzzleID>?
//        let ongoingPuzzles: [PuzzleID : [Tile]]?
//    }
//
//    struct Tile: Equatable, Codable {
//        let id: Int
//        let currentIndex: Int
//        let correctIndex: Int
//    }
//}
//
//extension UserProfile: Equatable {
//  
//    static func ==(lhs: UserProfile, rhs: UserProfile) -> Bool {
//        return lhs.uid == rhs.uid &&
//            lhs.appSettings == rhs.appSettings &&
//            lhs.appProgress == rhs.appProgress &&
//            lhs.deviceInfo == rhs.deviceInfo &&
//            lhs.adsEnabled == rhs.adsEnabled &&
//            lhs.premiumPackagesUnlocked == rhs.premiumPackagesUnlocked &&
//            lhs.hints == rhs.hints &&
//            lhs.coins == rhs.coins &&
//            lhs.credits == rhs.credits &&
//            lhs.createdTimestamp == rhs.createdTimestamp
//    }
//}
