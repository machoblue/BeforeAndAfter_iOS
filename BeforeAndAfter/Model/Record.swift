//
//  Record.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/16.
//

import Foundation

struct Record: Identifiable {
    var id = UUID().uuidString
    var time: TimeInterval
    var weight: Float? = nil
    var fatPercent: Float? = nil
    var note: String? = nil
    var frontImage: String? = nil
    var sideImage: String? = nil
}
