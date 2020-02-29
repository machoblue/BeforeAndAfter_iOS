//
//  LineChartView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/28.
//

import UIKit

class LineChartView: UIView {
    
    var mode: ChartRange = .threeWeeks
    var records: [Record] = []

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        let aPath = UIBezierPath()

        aPath.move(to: CGPoint(x: 100, y: 100))

        aPath.addLine(to: CGPoint(x: 200, y: 200))

        aPath.close()

        UIColor.red.set()
        aPath.stroke()
        aPath.fill()
    }

}
