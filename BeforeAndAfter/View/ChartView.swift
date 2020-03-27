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
            return "chart_range_3_weeks".localized
        case .threeMonths:
            return "chart_range_3_months".localized
        case .oneYear:
            return "chart_range_1_year".localized
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
            components.day = 1
        }
        return components
    }
    
    var unitTime: TimeInterval {
        switch self {
        case .threeWeeks:
            return 60 * 60 * 24
        case .threeMonths:
            return 60 * 60 * 24 * 7
        case .oneYear:
            return 60 * 60 * 24 * 30 // 本当はひと月なので、30とは限らない。ただ、最右のx軸のラベルが収まるかどうかに使うだけなのでアバウトでOK
        }
    }
    
    var format: String {
        switch self {
        case .threeWeeks:
            return "d"
        case .threeMonths:
            return "M/d"
        case .oneYear:
            return "MMM"
        }
    }
    
    var labelMaxLength: Int {
        switch self {
        case .threeWeeks:
            return 2
        case .threeMonths:
            return 5
        case .oneYear:
            return 4 // May(Mは2文字分)
        }
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
        NavigationView {
            VStack {
                Picker("Mode", selection: $mode) {
                    ForEach(ChartRange.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(EdgeInsets(top: BAMargin.medium, leading: BAMargin.medium, bottom: 0, trailing: BAMargin.medium))
            
                LineChart(mode: $mode, records: $viewModel.records)
            }
            .navigationBarTitle("chart_title", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // For iPad
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
