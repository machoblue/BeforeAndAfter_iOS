//
//  GraphView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/24.
//

import SwiftUI

enum GraphDisplayMode: Int, CaseIterable, Identifiable {
    case threeWeeks
    case threeMonths
    case oneYear
    
    var title: String {
        switch self {
        case .threeWeeks:
            return "3 Weeks"
        case .threeMonths:
            return "3 Months"
        case .oneYear:
            return "1 Year"
        }
    }
    
    var id: Int {
        return self.rawValue
    }
}

struct GraphView: View {
    @ObservedObject var viewModel: GraphViewModel
    @State private var mode: GraphDisplayMode = .threeWeeks

    init(viewModel: GraphViewModel = GraphViewModel()) {
        self.viewModel = viewModel
        self.mode = GraphDisplayMode(rawValue: UserDefaults.graphDisplayMode) ?? .threeWeeks
    }
    
    var body: some View {
        VStack {
            Picker("Mode", selection: $mode) {
                ForEach(GraphDisplayMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }.pickerStyle(SegmentedPickerStyle())
            TwoScaleLineGraph(mode: $mode, records: $viewModel.records)
        }
        .onAppear {
            self.viewModel.apply(.onAppear)
        }
        .onDisappear {
            UserDefaults.graphDisplayMode = self.mode.rawValue // This should be executed when unloading.
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
