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
    
    @Binding var mode: GraphDisplayMode
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
                }
                .stroke(lineWidth: 2.5)
            }
        }
    }
}

struct TwoScaleLineGraph_Previews: PreviewProvider {
    static var previews: some View {
        TwoScaleLineGraph(mode: .constant(GraphDisplayMode.threeWeeks), records: .constant([]))
    }
}
