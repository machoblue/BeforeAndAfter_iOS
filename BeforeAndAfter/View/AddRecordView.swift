//
//  EditAddRecordView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/18.
//

import SwiftUI
import StoreKit

struct AddRecordView: View {
    @State var record: Record
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EditAddRecordViewModel

    var body: some View {
        NavigationView {
            RecordFormView(record: $record)
                .navigationBarTitle("record_add_title", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("common_cancel".localized)
                    },
                    trailing: Button(action: {
                        self.viewModel.apply(.onSaveButtonTapped(record: self.record))
                        self.presentationMode.wrappedValue.dismiss()
                        StoreReviewUtils.requestReviewIfNeeded()
                    }) {
                        Text("common_save".localized)
                    }
                )
        }
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView(record: Record(time: Date().timeIntervalSince1970), viewModel: EditAddRecordViewModel())
    }
}
