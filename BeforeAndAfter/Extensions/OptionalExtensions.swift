//
//  OptionalExtensions.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/20.
//

import Foundation

// Workaround to set Optional<String> to TextField.text
extension Optional where Wrapped == String {
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}
