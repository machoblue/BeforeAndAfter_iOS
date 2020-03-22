//
//  StoreReviewUtils.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/22.
//

import Foundation
import StoreKit

import RealmSwift

class StoreReviewUtils {
    static func requestReviewIfNeeded() {
        guard canShowReviewDialog else { return }
        SKStoreReviewController.requestReview()
        UserDefaults.reviewDialogCompleted = true
    }
    
    static var canShowReviewDialog: Bool {
        guard !UserDefaults.reviewDialogCompleted else { return false }
        let realm = try! Realm()
        let results = realm.objects(RealmRecord.self)
        guard results.count > 9 else { return false }
        let sortedResults = results.sorted { $0.time > $1.time }
        let newest = sortedResults.first!.weight
        let secondNewest = sortedResults[1].weight
        let oldest = sortedResults.last!.weight
        guard newest > 0, secondNewest > 0, oldest > 0 else { return false }
        return oldest - newest >= 3 && newest < secondNewest
    }
}
