//
//  StringExtensions.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/25.
//

import Foundation

extension String {
    var localized: String {
//        return NSLocalizedString(self, comment: "")
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
