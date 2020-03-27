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
    var legendsHeight: CGFloat = 0

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
        legendsHeight = (height - marginTop - marginBottom) * 0.05
        let xAxisLabelHeight = (height - marginTop - marginBottom) * 0.05
        graphOffsetX = self.marginLeading
        graphOffsetY = self.marginTop + legendsHeight
        graphWidth = width - (self.marginLeading + self.marginTrailing)
        graphHeight = height - (self.marginTop + legendsHeight + xAxisLabelHeight + self.marginBottom)
        
        drawChartFrame(rect: rect)
        
        calculateYAxisRange()
        calculateXAxisRange()

        drawWeightChart(rect: rect)
        drawFatPercentChart(rect: rect)
        
        drawHorizontalLines(rect: rect)
        drawVerticalLines(rect: rect)
        
        drawLegends(rect: rect)
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
        
        let minimumScaleNums: Float = 5
        if weightUpperLimit - weightLowerLimit < minimumScaleNums {
            let add = (weightUpperLimit - weightLowerLimit) - minimumScaleNums
            weightLowerLimit += add
            fatPercentLowerLimit += add
        }
    }
    
    private func calculateXAxisRange() {
        let offset = self.mode.time * 0.05
        toTime = Date().timeIntervalSince1970 + offset
        fromTime = toTime - (self.mode.time + offset)
    }
    
    private func drawWeightChart(rect: CGRect) {
        let lineChartPath = UIBezierPath()
        lineChartPath.lineWidth = 1.5
        UIColor.red.withAlphaComponent(0.8).set()
        
        let filteredRecords = records.filter { $0.weight ?? 0 > 0 }.sorted { $0.time < $1.time }
        for (index, record) in filteredRecords.enumerated() {
            guard let weight = record.weight else { return }
            let x = self.marginLeading + self.graphWidth * CGFloat((record.time - fromTime) / (toTime - fromTime))
            let y = self.graphOffsetY + self.graphHeight * CGFloat((self.weightUpperLimit - weight) / (self.weightUpperLimit - self.weightLowerLimit))
            let point = CGPoint(x: x, y: y)
            
            switch record.time {
            case 0..<fromTime:
                guard
                    let nextRecord = filteredRecords.get(at: index + 1),
                    let nextWeight = nextRecord.weight,
                    nextRecord.time >= fromTime, nextRecord.time <= toTime
                else {
                    continue
                }
                
                let weightAtFromTime: Float = weight + (nextWeight - weight) * Float((fromTime - record.time) / (nextRecord.time - record.time))
                let y2 = self.graphOffsetY + self.graphHeight * CGFloat((self.weightUpperLimit - weightAtFromTime) / (self.weightUpperLimit - self.weightLowerLimit))
                let pointAtFromTime = CGPoint(x: graphOffsetX, y: y2)
                lineChartPath.move(to: pointAtFromTime)

            case fromTime...toTime:
                if index == 0 { // 直前のレコードがない
                    lineChartPath.move(to: point)
                } else {
                    lineChartPath.addLine(to: point) 
                }
                
                let dotPath = UIBezierPath()
                dotPath.addArc(withCenter: point, radius: 3, startAngle: 0, endAngle: .pi * 2, clockwise: true)
                dotPath.fill()
                
            default:
                continue
            }
        }
        
        lineChartPath.stroke()
    }
    
    private func drawFatPercentChart(rect: CGRect) {
        let lineChartPath = UIBezierPath()
        lineChartPath.lineWidth = 1.5
        UIColor.blue.withAlphaComponent(0.8).set()
        
        let filteredRecords = records.filter { $0.fatPercent ?? 0 > 0 }.sorted { $0.time < $1.time }
        for (index, record) in filteredRecords.enumerated() {
            guard let fatPercent = record.fatPercent else { return }
            let x = self.marginLeading + self.graphWidth * CGFloat((record.time - fromTime) / (toTime - fromTime))
            let y = self.graphOffsetY + self.graphHeight * CGFloat((self.fatPercentUpperLimit - fatPercent) / (self.fatPercentUpperLimit - self.fatPercentLowerLimit))
            let point = CGPoint(x: x, y: y)
            
            switch record.time {
            case 0..<fromTime:
                guard
                    let nextRecord = filteredRecords.get(at: index + 1),
                    let nextFatPercent = nextRecord.fatPercent,
                    nextRecord.time >= fromTime, nextRecord.time <= toTime
                else {
                    continue
                }
                
                let fatPercentAtFromTime: Float = fatPercent + (nextFatPercent - fatPercent) * Float((fromTime - record.time) / (nextRecord.time - record.time))
                let y2 = self.graphOffsetY + self.graphHeight * CGFloat((self.fatPercentUpperLimit - fatPercentAtFromTime) / (self.fatPercentUpperLimit - self.fatPercentLowerLimit))
                let pointAtFromTime = CGPoint(x: graphOffsetX, y: y2)
                lineChartPath.move(to: pointAtFromTime)

            case fromTime...toTime:
                if index == 0 { // 直前のレコードがない
                    lineChartPath.move(to: point)
                } else {
                    lineChartPath.addLine(to: point)
                }
                
                let dotPath = UIBezierPath()
                dotPath.addArc(withCenter: point, radius: 3, startAngle: 0, endAngle: .pi * 2, clockwise: true)
                dotPath.fill()
                
            default:
                continue
            }
        }
        
        lineChartPath.stroke()
    }
    
    private func drawHorizontalLines(rect: CGRect) {
        let path = UIBezierPath()
        UIColor.lightGray.withAlphaComponent(0.5).set()
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: BAFontSize.medium),
            NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5),
        ]
        
        for i in 1..<Int(weightUpperLimit - weightLowerLimit) {
            let y = graphOffsetY + graphHeight - graphHeight * CGFloat(Float(i) / (weightUpperLimit - weightLowerLimit))
            path.move(to: CGPoint(x: graphOffsetX, y: y))
            path.addLine(to: CGPoint(x: graphOffsetX + graphWidth, y: y))
            
            let leftAxisLabelString = String(format: "%.1f", weightLowerLimit + Float(i)) as NSString
            let leftAxisLabelSize = leftAxisLabelString.size(withAttributes: attributes)
            let leftAxisLabelX = graphOffsetX + 5
            let leftAxisLabelY = y - leftAxisLabelSize.height / 2
            let leftAxisLabelPoint = CGPoint(x: leftAxisLabelX, y: leftAxisLabelY)
            leftAxisLabelString.draw(at: leftAxisLabelPoint, withAttributes: attributes)
            
            let rightAxisLabelString = String(format: "%.1f", fatPercentLowerLimit + Float(i)) as NSString
            let rightAxisLabelSize = rightAxisLabelString.size(withAttributes: attributes)
            let rightAxisLabelX = graphOffsetX + graphWidth - rightAxisLabelSize.width - 5
            let rightAxisLabelY = y - rightAxisLabelSize.height / 2
            let rightAxisLabelPoint = CGPoint(x: rightAxisLabelX, y: rightAxisLabelY)
            rightAxisLabelString.draw(at: rightAxisLabelPoint, withAttributes: attributes)
        }
        path.stroke()
    }
    
    private func drawVerticalLines(rect: CGRect) {
        let path = UIBezierPath()
        UIColor.lightGray.withAlphaComponent(0.5).set()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = mode.format
        
        // calculate textSize
        let widthOfSpaceToPlaceXAxisLabel = graphWidth / CGFloat((toTime - fromTime) / mode.unitTime)
        let leftAndRightMargin: CGFloat = 5
        let fontHeightToWidthRatio: CGFloat = 2 // 半角数字は縦：横＝2:1という想定
        let fontSize = (widthOfSpaceToPlaceXAxisLabel - leftAndRightMargin) / CGFloat(mode.labelMaxLength) * fontHeightToWidthRatio
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.8),
        ]

        let calendar = Calendar(identifier: .gregorian)
        calendar.enumerateDates(startingAfter: Date(timeIntervalSince1970: fromTime), matching: mode.components, matchingPolicy: .nextTime) { (date, matches, stop) in
            guard
                let date = date,
                date.timeIntervalSince1970 <= toTime//,
//                matches
            else {
                stop = true
                return
            }
            
            let x = graphOffsetX + graphWidth * CGFloat((date.timeIntervalSince1970 - fromTime) / (toTime - fromTime))
            path.move(to: CGPoint(x: x, y: graphOffsetY))
            path.addLine(to: CGPoint(x: x, y: graphOffsetY + graphHeight))
            
            // draw label
            let nextTime = date.timeIntervalSince1970 + mode.unitTime
            guard nextTime < toTime else { return }
            
            let xAxisLabelString = dateFormatter.string(from: date) as NSString
            let xAxisLabelX = x + 2
            let xAxisLabelY = graphOffsetY + graphHeight + 5
            let xAxisLabelPoint = CGPoint(x: xAxisLabelX, y: xAxisLabelY)
            xAxisLabelString.draw(at: xAxisLabelPoint, withAttributes: attributes)
        }
        path.stroke()
    }
    
    private func drawLegends(rect: CGRect) {
        let bottomMargin: CGFloat = 6
        let leftMargin: CGFloat = 3
        let fontSize = BAFontSize.small
        
        let bezierPath = UIBezierPath()
        UIColor.red.set()
        let radius = fontSize / 2
        var x = graphOffsetX + leftMargin
        let centerX = x + radius
        let y = graphOffsetY - (bottomMargin + fontSize)
        let centerY = y + radius
        let center = CGPoint(x: centerX, y: centerY)
        bezierPath.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        bezierPath.fill()
        
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ]
        let weightLabel = "chart_legend_weight".localized as NSString
        x += radius * 2 + leftMargin
        let weightLabelPoint = CGPoint(x: x, y: y)
        weightLabel.draw(at: weightLabelPoint, withAttributes: attributes)
        
        let bezierPath2 = UIBezierPath()
        UIColor.blue.set()
        x += weightLabel.size(withAttributes: attributes).width + leftMargin * 2
        let centerX2 = x + radius
        let center2 = CGPoint(x: centerX2, y: centerY)
        bezierPath2.addArc(withCenter: center2, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        bezierPath2.fill()
        
        let fatPercentLabel = "chart_legend_fat_percent".localized as NSString
        x += radius * 2 + leftMargin
        let fatPercentLabelPoint = CGPoint(x: x, y: y)
        fatPercentLabel.draw(at: fatPercentLabelPoint, withAttributes: attributes)
    }
    
}
