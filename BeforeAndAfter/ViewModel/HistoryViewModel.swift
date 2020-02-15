//
//  HistoryViewModel.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/16.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var records: [Record] = []
    
    init() {
        getRecords()
    }
    
    private func getRecords() {
        records.append(Record(time: Date().timeIntervalSince1970, weight: 70, fatPercent: 25))
        records.append(Record(time: Date().timeIntervalSince1970, weight: 70, fatPercent: 25))
        records.append(Record(time: Date().timeIntervalSince1970, weight: 70, fatPercent: 25))
        records.append(Record(time: Date().timeIntervalSince1970, weight: 70, fatPercent: 25))
        records.append(Record(time: Date().timeIntervalSince1970, weight: 70, fatPercent: 25))
    }
}
