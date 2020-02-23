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
    func insertOrUpdate(record: Record) -> AnyPublisher<Void, Never>
}

class RecordRepository: RecordRepositoryProtocol {
    
    var records = CurrentValueSubject<[Record], Never>([])
    
    let realm: Realm
    var notificationToken: NotificationToken?

    init() {
        self.realm = try! Realm()
    }
    
    deinit {
        self.notificationToken?.invalidate()
    }
    
    func list() -> AnyPublisher<[Record], Never> {
        let results = realm.objects(RealmRecord.self)
        self.notificationToken = results.observe { [weak self] changes in
            guard let self = self else { return }
            self.records.send(results.map { Record(from: $0) })
        }
        return records.eraseToAnyPublisher()
    }
    
    func insertOrUpdate(record: Record) -> AnyPublisher<Void, Never> {
        try! realm.write {
            realm.add(record.realmRecord, update: .modified)
        }
        return PassthroughSubject<Void, Never>().eraseToAnyPublisher()
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
    
    var realmRecord: RealmRecord {
        let realmRecord = RealmRecord()
        realmRecord.id = id
        realmRecord.time = time
        realmRecord.weight = weight ?? 0
        realmRecord.fatPercent = fatPercent ?? 0
        realmRecord.frontImage = frontImage
        realmRecord.sideImage = sideImage
        realmRecord.note = note
        return realmRecord
    }
}
