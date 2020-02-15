//
//  HistoryRow.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/16.
//

import SwiftUI

struct HistoryRow: View {
    var record: Record
    var body: some View {
        Text(record.weight?.description ?? "-")
    }
}

struct HistoryRow_Previews: PreviewProvider {
    static var previews: some View {
        HistoryRow(record: Record(time: Date().timeIntervalSince1970, weight: 50.0, fatPercent: 20.0))
    }
}
