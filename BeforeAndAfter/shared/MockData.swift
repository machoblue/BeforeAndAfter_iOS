//
//  MockData.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/27.
//

#if DEBUG

import Foundation
import RealmSwift

func createMockDataIfNeeded() {
    let realm = try! Realm()
    
    guard realm.objects(RealmRecord.self).count == 0 else { return }
    
    var records: [Record] = []
    let startWeight: Float = 70
    let startRate: Float = 25.0
    for i in 0..<21 {
        let time = Date().timeIntervalSince1970 - Double(60 * 60 * 24 * (21 - i))
        let weight = startWeight - Float(Double(i) * 0.5) + Float.random(in: -1.0...1.0)
        let rate = startRate - Float(Double(i) * 0.25) + Float.random(in: -0.5...0.5)
        records.append(Record(id: UUID().description, time: time, weight: weight, fatPercent: rate, note: nil, frontImage: nil, sideImage: nil))
    }
    
    try! realm.write {
        for record in records {
            realm.add(record.realmRecord, update: .modified)
        }
    }
}

#endif
