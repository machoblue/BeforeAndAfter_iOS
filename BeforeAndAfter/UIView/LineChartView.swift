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
    
    // Chart size
    var width: CGFloat = 0
    var height: CGFloat = 0
    var graphWidth: CGFloat = 0
    var graphHeight: CGFloat = 0
    var graphOffsetX: CGFloat = 0
    var graphOffsetY: CGFloat = 0

    // YAxis range
    var weightLowerLimit: Float = 0
    var weightUpperLimit: Float = 0
    var fatPercentLowerLimit: Float = 0
    var fatPercentUpperLimit: Float = 0
    
    // XAxis range
    var fromTime: TimeInterval = 0
    var toTime: TimeInterval = 0
    
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
        width = rect.width
        height = rect.height
        let xAxisLabelHeight = height * 0.05
        graphOffsetX = self.marginLeading
        graphOffsetY = self.marginTop
        graphWidth = width - (self.marginLeading + self.marginTrailing)
        graphHeight = height - (xAxisLabelHeight + self.marginTop + self.marginBottom)
        
        drawChartFrame(rect: rect)
        
        calculateYAxisRange()
        calculateXAxisRange()
        
        drawWeightChart(rect: rect)
    }

    private func drawChartFrame(rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: graphOffsetX, y: graphOffsetY))
        path.addLine(to: CGPoint(x: graphOffsetX, y: graphOffsetY + graphHeight)) // Y Axis1
        path.addLine(to: CGPoint(x: graphOffsetX + graphWidth, y: graphOffsetY + graphHeight)) // XAxis
        path.addLine(to: CGPoint(x: graphOffsetX + graphWidth, y: graphOffsetY)) // YAxis 2
        UIColor.black.set()
        path.stroke()
    }
    
    private func calculateYAxisRange() {
        let sortedByWeight = self.records.sorted { ($0.weight ?? 0) < ($1.weight ?? 0) }
        let weightMax = sortedByWeight.last?.weight ?? 0
        let weightMin = sortedByWeight.first?.weight ?? 0
        let sortedByFatPercent = self.records.sorted { ($0.fatPercent ?? 0) < ($1.fatPercent ?? 0) }
        let fatPercentMax = sortedByFatPercent.last?.fatPercent ?? 0
        let fatPercentMin = sortedByFatPercent.first?.fatPercent ?? 0
        
        weightUpperLimit = ceil(weightMax) + 1
        weightLowerLimit = floor(weightMin) - 1
        fatPercentUpperLimit = ceil(fatPercentMax) + 1
        fatPercentLowerLimit = floor(fatPercentMin) - 1
        let weightRange = weightUpperLimit - weightLowerLimit
        let fatPercentRange = fatPercentUpperLimit - fatPercentLowerLimit
        if (weightRange > fatPercentRange) {
            fatPercentLowerLimit = fatPercentLowerLimit - Float(Int(weightRange - fatPercentRange) / 2)
            fatPercentUpperLimit = fatPercentLowerLimit + weightRange
        } else {
            weightLowerLimit = weightLowerLimit - Float(Int(fatPercentRange - weightRange) / 2)
            weightUpperLimit = weightLowerLimit + fatPercentRange
        }
    }
    
    private func calculateXAxisRange() {
//        let offset = Double(60 * 60 * 24)
        let offset = self.mode.time * 0.05
        toTime = Date().timeIntervalSince1970 + offset
        fromTime = toTime - (self.mode.time + offset)
    }
    
    private func drawWeightChart(rect: CGRect) {
        let lineChartPath = UIBezierPath()
        for (index, record) in self.records.enumerated() {
            guard let weight = record.weight else { return }
            let x = self.marginLeading + self.graphWidth * CGFloat((record.time - fromTime) / (toTime - fromTime))
            
            let y = self.marginTop + self.graphHeight * CGFloat((self.weightUpperLimit - weight) / (self.weightUpperLimit - self.weightLowerLimit))
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
