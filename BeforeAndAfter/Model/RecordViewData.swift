//
//  RecordViewData.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/16.
//

import Foundation

struct RecordViewData: Identifiable {
    var id: String
    var time: TimeInterval
    var weight: Float?
    var fatPercent: Float?
    var frontImage: String?
    var sideImage: String?
    var note: String?

    var yearText: String
    var dateText: String
    var timeText: String

    init(from: Record, yearText: String, dateText: String, timeText: String) {
        self.id = from.id
        self.time = from.time
        self.weight = from.weight
        self.fatPercent = from.fatPercent
        self.frontImage = from.frontImage
        self.sideImage = from.sideImage
        self.note = from.note
        self.yearText = yearText
        self.dateText = dateText
        self.timeText = timeText
    }
}
