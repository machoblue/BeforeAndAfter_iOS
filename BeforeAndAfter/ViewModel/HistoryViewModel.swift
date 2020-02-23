//
//  HistoryViewModel.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/16.
//

import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    
    
    // MARK: - Input
    enum Input {
        case onAppear
        case onDelete(record: RecordViewData)
    }
    func apply(_ input: Input) {
        switch input {
        case .onAppear:
            onAppearSubject.send()
        case .onDelete(let recordViewData):
            onDeleteSubject.send(recordViewData.record)
        }
    }
    private var onAppearSubject = PassthroughSubject<Void, Never>()
    private var onDeleteSubject = PassthroughSubject<Record, Never>()
    
    // MARK: - Intermediate
    private let recordsSubject = PassthroughSubject<[Record], Never>()
    private let deleteSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Output
    @Published var records: [RecordViewData] = []
    
    // MARK: - Other
    private var cancellables: [AnyCancellable] = []
    
    private let recordRepository: RecordRepositoryProtocol
    
    private let yearFormatter = DateFormatter.yearFormatter
    private let dateFormatter = DateFormatter.dateFormatter
    private let timeFormatter = DateFormatter.timeFormatter

    init(recordRepository: RecordRepositoryProtocol = RecordRepository()) {
        self.recordRepository = recordRepository
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        let recordsInputStream = onAppearSubject
            .flatMap { [recordRepository] _ in
                recordRepository.list()
            }
            .share()
            .subscribe(recordsSubject)
        
        let deleteStream = onDeleteSubject
            .flatMap { [recordRepository] record in
                recordRepository.delete(record)
            }
            .share()
            .subscribe(deleteSubject)

        cancellables += [recordsInputStream, deleteStream]
    }
    
    private func bindOutputs() {
        let recordsOutputStream = recordsSubject
            .map { records in
                records.map { record in
                    RecordViewData(from: record,
                                   yearText: self.yearFormatter.string(from: Date(timeIntervalSince1970: record.time)),
                                   dateText: self.dateFormatter.string(from: Date(timeIntervalSince1970: record.time)),
                                   timeText: self.timeFormatter.string(from: Date(timeIntervalSince1970: record.time)))
                }
            }
            .assign(to: \.records, on: self)
        cancellables.append(recordsOutputStream)
    }
}
