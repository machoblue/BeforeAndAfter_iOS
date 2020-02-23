//
//  GraphViewModel.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/24.
//

import Foundation

import Foundation
import Combine

class GraphViewModel: ObservableObject {

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

    // MARK: - Intermediate
    private let recordsSubject = PassthroughSubject<[Record], Never>()

    // MARK: - Output
    @Published var records: [Record] = []
    
    // MARK: - Other
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
        
        cancellables += [recordsInputStream]
    }
    
    private func bindOutputs() {
        let recordsOutputStream = recordsSubject
            .assign(to: \.records, on: self)
        cancellables.append(recordsOutputStream)
    }
}
