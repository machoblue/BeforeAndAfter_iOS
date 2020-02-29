//
//  LineChartView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/28.
//

import UIKit

class LineChartView: UIView {
    
    let marginTop = BAMargin.medium
    let marginLeading = BAMargin.medium
    let marginTrailing = BAMargin.medium
    let marginBottom = BAMargin.medium
    
    var mode: ChartRange = .threeWeeks {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var records: [Record] = [] {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {

        let width = rect.width
        let height = rect.height
        let xAxisLabelHeight = height * 0.05
        let graphOffsetX = self.marginLeading
        let graphOffsetY = self.marginTop
        let graphWidth = width - (self.marginLeading + self.marginTrailing)
        let graphHeight = height - (xAxisLabelHeight + self.marginTop + self.marginBottom)

        let path = UIBezierPath()
        path.move(to: CGPoint(x: graphOffsetX, y: graphOffsetY))
        path.addLine(to: CGPoint(x: graphOffsetX, y: graphOffsetY + graphHeight)) // Y Axis1
        path.addLine(to: CGPoint(x: graphOffsetX + graphWidth, y: graphOffsetY + graphHeight)) // XAxis
        path.addLine(to: CGPoint(x: graphOffsetX + graphWidth, y: graphOffsetY)) // YAxis 2
        UIColor.black.set()
        path.stroke()
        
        let sortedByWeight = self.records.sorted { ($0.weight ?? 0) < ($1.weight ?? 0) }
        let weightMax = sortedByWeight.last?.weight ?? 0
        let weightMin = sortedByWeight.first?.weight ?? 0
        let sortedByFatPercent = self.records.sorted { ($0.fatPercent ?? 0) < ($1.fatPercent ?? 0) }
        let fatPercentMax = sortedByFatPercent.last?.fatPercent ?? 0
        let fatPercentMin = sortedByFatPercent.first?.fatPercent ?? 0
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

        let lineChartPath = UIBezierPath()
        for (index, record) in self.records.enumerated() {
            guard let weight = record.weight else { return }
            let x = self.marginLeading + graphWidth * CGFloat((record.time - fromTime) / (toTime - fromTime))
            let y = self.marginTop + graphHeight * CGFloat((weightUpperLimit - weight) / (weightUpperLimit - weightLowerLimit))
            let point = CGPoint(x: x, y: y)
            if record.time >= fromTime, record.time <= toTime {
                if index == 0 { // 直前のレコードがない
                    lineChartPath.move(to: point)
                } else {
                    lineChartPath.addLine(to: point)
                }

            } else {
                if index + 1 < self.records.count { // 次のrecordがある
                    let nextRecord = self.records[index + 1]
                    if nextRecord.time >= fromTime, nextRecord.time <= toTime { // かつそれが　範囲内
                        lineChartPath.move(to: point)
                    }
                }
            }
        }
        UIColor.red.set()
        lineChartPath.stroke()
    }

}
