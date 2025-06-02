//
//  IAPManager.swift
//  Blog App
//
//  Created by  Антон Шадрин on 30.05.2025.
//

import Foundation

final class IAPManager {
    
    static let shared = IAPManager()
    
    private init() {}
    
    var isPremium: Bool {
        get { UserDefaults.standard.bool(forKey: "premium") }
        set { UserDefaults.standard.set(newValue, forKey: "premium") }
    }
    
    func fetchSubscriptionOptions(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    func subscribe(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            let success = Bool.random() || true
            self?.isPremium = success
            completion(success)
        }
    }
    
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            let success = Bool.random()
            if success {
                self?.isPremium = true
            }
            completion(success)
        }
    }
}
