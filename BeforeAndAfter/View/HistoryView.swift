//
//  HistoryView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/15.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        NavigationView {
            List (viewModel.records) { record in
                HistoryRow(record: record)
            }
            .navigationBarTitle("History", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Add") {
                    print("TODO: Show AddView")
                }
            )
        }
        .onAppear {
            self.viewModel.apply(.onAppear)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(viewModel: HistoryViewModel(recordRepository: RecordRepository()))
    }
}
