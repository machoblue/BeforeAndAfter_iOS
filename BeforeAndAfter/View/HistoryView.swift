//
//  HistoryView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/15.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var viewModel: HistoryViewModel
    @State var showEditAdd = false
    
    var body: some View {
        NavigationView {
            List (viewModel.records) { record in
                HistoryRow(record: record)
            }
            .navigationBarTitle("History", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showEditAdd.toggle()
                }) {
                    Text("Add")
                }.sheet(isPresented: $showEditAdd) {
                    EditAddRecordView()
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
