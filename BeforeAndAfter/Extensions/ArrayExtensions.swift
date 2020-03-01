//
//  ArrayExtensions.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/01.
//

import Foundation

extension Array {
    func get(at index: Int) -> Element? {
        guard index <= count else { return nil }
        return self[index]
    }
}
