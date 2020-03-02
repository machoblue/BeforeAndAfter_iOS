//
//  ChartView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/24.
//

import SwiftUI

enum ChartRange: Int, CaseIterable, Identifiable {
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
    
    var time: TimeInterval {
        switch self {
        case .threeWeeks:
            return 60 * 60 * 24 * 21
        case .threeMonths:
            return 60 * 60 * 24 * 90
        case .oneYear:
            return 60 * 60 * 24 * 365
        }
    }
    
    var components: DateComponents {
        var components = DateComponents()
        components.nanosecond = 0
        components.second = 0
        components.minute = 0
        components.hour = 0
        switch self {
        case .threeWeeks:
            break
        case .threeMonths:
            components.weekday = 1
        case .oneYear:
            components.weekday = 1
//            components.weekOfMonth = 1
        }
        return components
    }
}

struct ChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    @State private var mode: ChartRange = .threeWeeks

    init(viewModel: ChartViewModel = ChartViewModel()) {
        self.viewModel = viewModel
        self.mode = ChartRange(rawValue: UserDefaults.graphDisplayMode) ?? .threeWeeks
    }
    
    var body: some View {
        VStack {
            Picker("Mode", selection: $mode) {
                ForEach(ChartRange.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }.pickerStyle(SegmentedPickerStyle())
//            TwoScaleLineGraph(mode: $mode, records: $viewModel.records)
            LineChart(mode: $mode, records: $viewModel.records)
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
        ChartView()
    }
}
