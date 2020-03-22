//
//  TargetViewModel.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/05.
//

import Foundation
import Combine

struct Target {
    let weightTarget: Float?
    let fatPercentTarget: Float?
}

class TargetViewModel: ObservableObject {
    // MARK: - Input
    enum Input {
        case onAppear
        case onSaveButtonTapped(weightTarget: Float?, fatPercentTarget: Float?)
    }
    func apply(_ input: Input) {
        switch input {
        case .onAppear:
            onAppearSubject.send()
        case .onSaveButtonTapped(let weightTarget, let fatPercentTarget):
            onSaveButtonTappedSubject.send(Target(weightTarget: weightTarget, fatPercentTarget: fatPercentTarget))
        }
    }
    private var onAppearSubject = PassthroughSubject<Void, Never>()
    private var onSaveButtonTappedSubject = PassthroughSubject<Target, Never>()
    
    
    // MARK: - Intermediate
    private var targetSubject = PassthroughSubject<Target, Never>()
    private var saveSubject = PassthroughSubject<Void, Never>()
    
    // MARK: -Output
    @Published var weightTargetText: String = ""
    @Published var fatPercentTargetText: String = ""
    
    // Mark: - Other
    private var cancellables: [AnyCancellable] = []
    private let targetRepository: TargetRepositoryProtocol
    
    init(targetRepository: TargetRepositoryProtocol = TargetRepository()) {
        self.targetRepository = targetRepository
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        let targetStream = onAppearSubject.flatMap {
            return self.targetRepository.get()
        }
        .share()
        .subscribe(targetSubject)
        
        let saveStream = onSaveButtonTappedSubject.flatMap { target in
            return self.targetRepository.update(target: target)
        }
        .share()
        .subscribe(saveSubject)
        
        cancellables += [targetStream, saveStream]
    }
    
    private func bindOutputs() {
        let weightTargetOutputStream = targetSubject
            .map { target in
                if let weightTarget = target.weightTarget {
                    return weightTarget == 0 ? "" : String(format: "%.2f", weightTarget)
                } else {
                    return ""
                }
            }
            .assign(to: \.weightTargetText, on: self)
        let fatPercentTargetOutputStream = targetSubject
            .map { target in
                if let fatPercentTarget = target.fatPercentTarget {
                    return fatPercentTarget == 0 ? "" : String(format: "%.2f", fatPercentTarget)
                } else {
                    return ""
                }
            }
            .assign(to: \.fatPercentTargetText, on: self)
        cancellables += [weightTargetOutputStream, fatPercentTargetOutputStream]
    }
}
