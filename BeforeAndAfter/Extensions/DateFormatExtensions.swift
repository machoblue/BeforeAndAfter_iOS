//
//  DateFormatExtensions.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/18.
//

import Foundation

extension DateFormatter {
    static var yearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }
    
    static var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "kk:mm"
        return formatter
    }
}
