//
//  BATabView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/15.
//

import SwiftUI

struct BATabView: View {
    var body: some View {
        TabView {
            HistoryView(viewModel: HistoryViewModel(recordRepository: RecordRepository()))
                .tabItem {
                    Image("history-24px")
                        .renderingMode(.template)
                        .foregroundColor(.blue)
                    Text("History")
                }
            GraphView()
                .tabItem {
                    Image("show_chart-24px")
                        .renderingMode(.template)
                        .foregroundColor(.blue)
                    Text("Graph")
            }
        }
    }
}

struct BATabView_Previews: PreviewProvider {
    static var previews: some View {
        BATabView()
    }
}
