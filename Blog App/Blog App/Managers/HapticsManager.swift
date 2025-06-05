//
//  HapticsManager.swift
//  Blog App
//
//  Created by  Антон Шадрин on 02.06.2025.
//

import Foundation
import UIKit

final class HapticsManager {
    
    // MARK: - Properties
    
    static let shared = HapticsManager()
    
    // MARK: - Methods
    
    private init() {}
    
    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
