//
//  TwoScaleLineGraph.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/24.
//

import SwiftUI

struct TwoScaleLineGraph: View {
    @Binding var mode: GraphDisplayMode
    @Binding var records: [Record]
    var body: some View {
        Text("\(mode.title) is selected!")
    }
}

struct TwoScaleLineGraph_Previews: PreviewProvider {
    static var previews: some View {
        TwoScaleLineGraph(mode: .constant(GraphDisplayMode.threeWeeks), records: .constant([]))
    }
}
