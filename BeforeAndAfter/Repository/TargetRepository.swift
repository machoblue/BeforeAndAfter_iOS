//
//  TargetRepository.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/05.
//

import Foundation
import Combine

protocol TargetRepositoryProtocol {
    func get() -> AnyPublisher<Target, Never>
    func update(target: Target) -> AnyPublisher<Void, Never>
}

class TargetRepository: TargetRepositoryProtocol {
    let userDefaults: UserDefaults
    
    var targetSubject = CurrentValueSubject<Target, Never>(Target(weightTarget: nil, fatPercentTarget: nil))
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func get() -> AnyPublisher<Target, Never> {
        let weightTarget = userDefaults.float(forKey: "weightTarget")
        let fatPercentTarget = userDefaults.float(forKey: "fatPercentTarget")
        let target = Target(weightTarget: weightTarget, fatPercentTarget: fatPercentTarget)
        targetSubject.send(target)
        return targetSubject.eraseToAnyPublisher()
    }
    
    
    func update(target: Target) -> AnyPublisher<Void, Never> {
        userDefaults.set(target.weightTarget, forKey: "weightTarget")
        userDefaults.set(target.fatPercentTarget, forKey: "fatPercentTarget")
        return PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    }
    
    
}
