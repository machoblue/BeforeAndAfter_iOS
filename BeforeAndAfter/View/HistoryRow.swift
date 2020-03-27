//
//  HistoryRow.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/16.
//

import SwiftUI

struct HistoryRow: View {
    var record: RecordViewData
    var body: some View {
        HStack {
            VStack {
                Text(record.yearText)
                    .font(.system(size: BAFontSize.small))
                Text(record.dateText)
                    .font(.system(size: BAFontSize.large))
                Text(record.timeText)
                    .font(.system(size: BAFontSize.small))
            }
            VStack(alignment: .leading) {
                HStack(alignment: .bottom, spacing: 0) {
                    Text(record.weight?.description ?? "-")
                        .font(.system(size: BAFontSize.xLarge))
                    Text("common_kg".localized)
                        .font(.system(size: BAFontSize.small))
                    Spacer()
                        .frame(width: BAMargin.medium, height: .zero)
                    Text(record.fatPercent?.description ?? "-")
                        .font(.system(size: BAFontSize.xLarge))
                    Text("common_percent".localized)
                        .font(.system(size: BAFontSize.small))
                }
                Text(record.note ?? "-")
                    .font(.system(size: BAFontSize.small))
            }
            .padding(.leading, BAMargin.large)
        }
    }
}

struct HistoryRow_Previews: PreviewProvider {
    static var previews: some View {
        HistoryRow(record: RecordViewData(from: Record(time: Date().timeIntervalSince1970, weight: 50.0, fatPercent: 20.0), yearText: "2020", dateText: "12/31", timeText: "23:59"))
    }
}
