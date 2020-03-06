//
//  HomeViewModel.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/07.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
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
    private let targetSubject = PassthroughSubject<Target, Never>()
    
    // MARK: - Output
    @Published var countOfElapsedDay: Int = 0
    @Published var countOfDayKeepRecording: Int = 0
    
    @Published var latestWeight: Float = 0
    @Published var firstWeight: Float = 0
    @Published var targetWeight: Float = 0
    @Published var bestWeight: Float = 0
    @Published var lostWeight: Float = 0
    @Published var remainingWeight: Float = 0
    
    @Published var latestFatPercent: Float = 0
    @Published var firstFatPercent: Float = 0
    @Published var targetFatPercent: Float = 0
    @Published var bestFatPercent: Float = 0
    @Published var lostFatPercent: Float = 0
    @Published var remainingFatPercent: Float = 0
    
    @Published var weightSummary = Summary.empty()
    @Published var fatPercentSummary = Summary.empty()
    
    // MARK: - Other
    private var cancellables: [AnyCancellable] = []
    
    private let recordRepository: RecordRepositoryProtocol
    private let targetRepository: TargetRepositoryProtocol
    
    init(recordRepository: RecordRepositoryProtocol = RecordRepository(),
         targetRepository: TargetRepositoryProtocol = TargetRepository())
    {
        self.recordRepository = recordRepository
        self.targetRepository = targetRepository
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
        
        let targetInputStream = onAppearSubject
            .flatMap { [targetRepository] _ in
                targetRepository.get()
        }
        .share()
        .subscribe(targetSubject)

        cancellables += [recordsInputStream, targetInputStream]
    }
    
    private func bindOutputs() {
        let recordsAndTarget = recordsSubject.combineLatest(targetSubject)
        
        let weightOutputStream = recordsAndTarget
            .map { recordsAndTarget -> Summary in
                let records = recordsAndTarget.0
                let target = recordsAndTarget.1
                
                let latest = records.first?.weight ?? 0
                let first = records.last?.weight ?? 0
                let targetValue = target.weightTarget ?? 0
                let best = records.sorted { ($0.weight ?? 0) < ($1.weight ?? 0) }.first?.weight ?? 0
                let lost = latest - first
                let remaining = targetValue - latest
                
                return Summary(latest: latest, first: first, target: targetValue, best: best, lost: lost, remainig: remaining)
            }
            .assign(to: \.weightSummary, on: self)
            
        let fatPercentOutputStream = recordsAndTarget
            .map { recordsAndTarget -> Summary in
                let records = recordsAndTarget.0
                let target = recordsAndTarget.1

                let latest = records.first?.fatPercent ?? 0
                let first = records.last?.fatPercent ?? 0
                let targetValue = target.fatPercentTarget ?? 0
                let best = records.sorted { ($0.fatPercent ?? 0) < ($1.fatPercent ?? 0) }.first?.fatPercent ?? 0
                let lost = latest - first
                let remaining = targetValue - latest

                return Summary(latest: latest, first: first, target: targetValue, best: best, lost: lost, remainig: remaining)
            }
            .assign(to: \.fatPercentSummary, on: self)

        cancellables += [weightOutputStream, fatPercentOutputStream]
    }
}

struct Summary {
    let latest: Float
    let first: Float
    let target: Float
    let best: Float
    let lost: Float
    let remainig: Float
    
    static func empty() -> Summary {
        return Summary(latest: 0, first: 0, target: 0, best: 0, lost: 0, remainig: 0)
    }
}
