//
//  LineChart.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/29.
//

import SwiftUI

struct LineChart: UIViewRepresentable {
    
    @Binding var mode: ChartRange
    @Binding var records: [Record]
    
    func makeUIView(context: Context) -> LineChartView {
        return LineChartView(frame: .zero)
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart(mode: .constant(.threeWeeks), records: .constant([]))
    }
}
