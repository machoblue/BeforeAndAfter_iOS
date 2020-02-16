//
//  RecordRepository.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/16.
//

import Foundation
import Combine

protocol RecordRepositoryProtocol {
    func list() -> AnyPublisher<[Record], Never>
}

class RecordRepository: RecordRepositoryProtocol {
    var records = CurrentValueSubject<[Record], Never>([])
    func list() -> AnyPublisher<[Record], Never> {
        records.send([
            Record(time: Date().timeIntervalSince1970, weight: 50.0),
            Record(time: Date().timeIntervalSince1970, weight: 50.0),
            Record(time: Date().timeIntervalSince1970, weight: 50.0),
            Record(time: Date().timeIntervalSince1970, weight: 50.0),
            Record(time: Date().timeIntervalSince1970, weight: 50.0),
            Record(time: Date().timeIntervalSince1970, weight: 50.0),
            Record(time: Date().timeIntervalSince1970, weight: 50.0),
            Record(time: Date().timeIntervalSince1970, weight: 50.0),
            Record(time: Date().timeIntervalSince1970, weight: 50.0),
            Record(time: Date().timeIntervalSince1970, weight: 50.0),
        ])
        return records.eraseToAnyPublisher()
    }
}
