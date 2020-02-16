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
    }
    func apply(_ input: Input) {
        switch input {
        case .onAppear:
            onAppearSubject.send()
        }
    }
    private var onAppearSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Output
    @Published var records: [Record] = []
    
    private let recordsSubject = PassthroughSubject<[Record], Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    private let recordRepository: RecordRepositoryProtocol
    
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
        
        cancellables.append(recordsInputStream)
    }
    
    private func bindOutputs() {
        let recordsOutputStream = recordsSubject.assign(to: \.records, on: self)
        cancellables.append(recordsOutputStream)
    }
}
