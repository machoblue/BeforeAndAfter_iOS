//
//  EditAddRecordView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/18.
//

import SwiftUI

struct AddRecordView: View {
    @State var record: Record
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddRecordViewModel

    var body: some View {
        NavigationView {
            RecordFormView(record: $record)
                .navigationBarTitle("Edit", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Close")
                    },
                    trailing: Button(action: {
                        self.viewModel.apply(.onSaveButtonTapped(record: self.record))
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                    }
                )
        }
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView(record: Record(time: Date().timeIntervalSince1970), viewModel: AddRecordViewModel())
    }
}
