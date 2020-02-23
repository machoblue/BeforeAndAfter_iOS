//
//  UserDefaultsExtensions.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/23.
//

import Foundation

extension UserDefaults {
    private static var latestWeightKey = "latestWeight"
    private static var latestFatPercentKey = "latestFatPercent"

    static var latestWeight: Float? {
        get {
            let value = UserDefaults.standard.float(forKey: Self.latestWeightKey)
            return value == 0 ? nil : value
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Self.latestWeightKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var latestFatPercent: Float? {
        get {
            let value = UserDefaults.standard.float(forKey: Self.latestFatPercentKey)
            return value == 0 ? nil : value
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Self.latestFatPercentKey)
            UserDefaults.standard.synchronize()
        }
    }
}
