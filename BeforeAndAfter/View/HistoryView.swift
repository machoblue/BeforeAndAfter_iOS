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
            List {
                ForEach(viewModel.records) { record in
                    NavigationLink(destination: EditRecordView(record: record.record, viewModel: EditAddRecordViewModel())) {
                        HistoryRow(record: record)
                    }
                }
                .onDelete { indexSet in
                    guard let index = indexSet.first else { return }
                    self.viewModel.apply(.onDelete(record: self.viewModel.records[index]))
                }
            }
            .navigationBarTitle("history_title", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showEditAdd.toggle()
                }) {
                    Text("common_add".localized)
                }.sheet(isPresented: $showEditAdd) {
                    AddRecordView(record: Record(time: Date().timeIntervalSince1970, weight: UserDefaults.latestWeight, fatPercent: UserDefaults.latestFatPercent),
                                  viewModel: EditAddRecordViewModel())
                }
            )
            
            Text("common_no_item_is_selected".localized) // For iPad
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())  // For iPad
        .padding(.leading, 0.25) // Workaround for DoubleColumnNavigationViewStyle not working issue
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
