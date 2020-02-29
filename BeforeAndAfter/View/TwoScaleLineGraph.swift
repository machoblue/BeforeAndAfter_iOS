//
//  TwoScaleLineGraph.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/24.
//

import SwiftUI

struct TwoScaleLineGraph: View {
    
    let marginTop = BAMargin.medium
    let marginLeading = BAMargin.medium
    let marginTrailing = BAMargin.medium
    let marginBottom = BAMargin.medium
    
    @Binding var mode: ChartRange
    @Binding var records: [Record]
    
    var body: some View {
        VStack {
            Text("\(mode.title) is selected!")
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let xAxisLabelHeight = height * 0.05
                    let graphOffsetX = self.marginLeading
                    let graphOffsetY = self.marginTop
                    let graphWidth = width - (self.marginLeading + self.marginTrailing)
                    let graphHeight = height - (xAxisLabelHeight + self.marginTop + self.marginBottom)

                    path.move(to: CGPoint(x: graphOffsetX, y: graphOffsetY))
                    path.addLine(to: CGPoint(x: graphOffsetX, y: graphOffsetY + graphHeight)) // Y Axis1
                    path.addLine(to: CGPoint(x: graphOffsetX + graphWidth, y: graphOffsetY + graphHeight)) // XAxis
                    path.addLine(to: CGPoint(x: graphOffsetX + graphWidth, y: graphOffsetY)) // YAxis 2
                    
                    let sortedByWeight = self.records.sorted { ($0.weight ?? 0) < ($1.weight ?? 0) }
                    let weightMax = sortedByWeight.last?.weight ?? 0
                    let weightMin = sortedByWeight.first?.weight ?? 0
                    let sortedByFatPercent = self.records.sorted { ($0.fatPercent ?? 0) < ($1.fatPercent ?? 0) }
                    let fatPercentMax = sortedByFatPercent.last?.fatPercent ?? 0
                    let fatPercentMin = sortedByFatPercent.first?.fatPercent ?? 0
                    print("***", weightMax, weightMin, fatPercentMax, fatPercentMin)
                    var weightUpperLimit = ceil(weightMax) + 1
                    var weightLowerLimit = floor(weightMin) - 1
                    var fatPercentUpperLimit = ceil(fatPercentMax) + 1
                    var fatPercentLowerLimit = floor(fatPercentMin) - 1
                    let weightRange = weightUpperLimit - weightLowerLimit
                    let fatPercentRange = fatPercentUpperLimit - fatPercentLowerLimit
                    if (weightRange > fatPercentRange) {
                        fatPercentLowerLimit = fatPercentLowerLimit - Float(Int(weightRange - fatPercentRange) / 2)
                        fatPercentUpperLimit = fatPercentLowerLimit + weightRange
                    } else {
                        weightLowerLimit = weightLowerLimit - Float(Int(fatPercentRange - weightRange) / 2)
                        weightUpperLimit = weightLowerLimit + fatPercentRange
                    }
                    
                    let offset = Double(60 * 60 * 24)
                    let toTime = Date().timeIntervalSince1970 + offset
                    let fromTime = toTime - (self.mode.time + offset)
                    
                    // move -> addline -> addArc
                    
                    for (index, record) in self.records.enumerated() {
                        guard let weight = record.weight else { return }
                        let x = self.marginLeading + graphWidth * CGFloat((record.time - fromTime) / (toTime - fromTime))
                        let y = self.marginTop + graphHeight * CGFloat((weightUpperLimit - weight) / (weightUpperLimit - weightLowerLimit))
                        let point = CGPoint(x: x, y: y)
                        if record.time >= fromTime, record.time <= toTime {
                            if index == 0 { // 直前のレコードがない
                                path.move(to: point)
                            } else {
                                path.addLine(to: point)
                            }

                        } else {
                            if index + 1 < self.records.count { // 次のrecordがある
                                let nextRecord = self.records[index + 1]
                                if nextRecord.time >= fromTime, nextRecord.time <= toTime { // かつそれが　範囲内
                                    path.move(to: point)
                                }
                            }
                        }
                    }
                }
                .stroke(lineWidth: 2.5)
            }
        }
    }
}

struct TwoScaleLineGraph_Previews: PreviewProvider {
    static var previews: some View {
        TwoScaleLineGraph(mode: .constant(.threeWeeks), records: .constant([
            Record(time: Date().timeIntervalSince1970 - 60 * 60 * 24 * 30, weight: 80),
            Record(time: Date().timeIntervalSince1970 - 60 * 60 * 24 * 20, weight: 70),
            Record(time: Date().timeIntervalSince1970 - 60 * 60 * 24 * 12, weight: 72),
            Record(time: Date().timeIntervalSince1970 - 60 * 60 * 24 * 4, weight: 68),
        ]))
    }
}
