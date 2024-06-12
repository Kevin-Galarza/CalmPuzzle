//
//  SettingsSection.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 6/6/24.
//

import UIKit

enum SettingsSection: Int, CaseIterable {
    case audio
    case difficulty
    case restore
    case misc
    
    var cellConfigurations: [SettingsCellType] {
        switch self {
        case .audio:
            return [
                .toggle("Music", UIImage(named: "settings_icon_music")!),
                .toggle("Sound Effects", UIImage(named: "settings_icon_sound")!),
                .toggle("Vibrations", UIImage(named: "settings_icon_haptic")!)
            ]
        case .difficulty:
            return [
                .disclosure("Difficulty", UIImage(named: "settings_icon_difficulty")!)
            ]
        case .restore:
            return [
                .action("Restore Purchases", UIImage(named: "settings_icon_restore")!)
            ]
        case .misc:
            return [
                .action("Feedback", UIImage(named: "settings_icon_feedback")!),
                .action("Help Center", UIImage(named: "settings_icon_help")!),
                .action("Rate Us", UIImage(named: "settings_icon_rate")!)
            ]
        }
    }
}
