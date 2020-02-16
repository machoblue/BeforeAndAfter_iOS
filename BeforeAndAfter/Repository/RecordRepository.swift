//
//  RecordRepository.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/16.
//

import Foundation
import Combine

import RealmSwift

protocol RecordRepositoryProtocol {
    func list() -> AnyPublisher<[Record], Never>
}

class RecordRepository: RecordRepositoryProtocol {
    
    var records = CurrentValueSubject<[Record], Never>([])
    
    let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func list() -> AnyPublisher<[Record], Never> {
        records.send(realm.objects(RealmRecord.self).map { Record(from: $0) })
        return records.eraseToAnyPublisher()
    }
}

class RealmRecord: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var time: TimeInterval = 0
    @objc dynamic var weight: Float = 0
    @objc dynamic var fatPercent: Float = 0
    @objc dynamic var frontImage: String? = nil
    @objc dynamic var sideImage: String? = nil
    @objc dynamic var note: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Record {
    init(from: RealmRecord) {
        self.id = from.id
        self.time = from.time
        self.weight = from.weight
        self.fatPercent = from.fatPercent
        self.frontImage = from.frontImage
        self.sideImage = from.sideImage
        self.note = from.note
    }
}
