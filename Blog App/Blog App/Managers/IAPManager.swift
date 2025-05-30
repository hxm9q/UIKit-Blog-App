//
//  IAPManager.swift
//  Blog App
//
//  Created by  Антон Шадрин on 30.05.2025.
//

import Foundation

final class IAPManager {
    
    static let shared = IAPManager()
    
    private let formatter = ISO8601DateFormatter()
    
    private init() {}
    
    private var postEligibleViewDate: Date? {
        return nil
    }
    
    var isPremium: Bool {
        get { UserDefaults.standard.bool(forKey: "premium") }
        set { UserDefaults.standard.set(newValue, forKey: "premium") }
    }
}
