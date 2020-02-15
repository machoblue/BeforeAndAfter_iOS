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
            HistoryView()
                .tabItem {
                    Image("history-24px")
                        .renderingMode(.template)
                        .foregroundColor(.blue)
                    Text("History")
            }
        }
    }
}

struct BATabView_Previews: PreviewProvider {
    static var previews: some View {
        BATabView()
    }
}
