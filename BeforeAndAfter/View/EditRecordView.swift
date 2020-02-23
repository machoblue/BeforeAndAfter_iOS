//
//  EditRecordView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/23.
//

import SwiftUI

struct EditRecordView: View {
    @State var record: Record
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddRecordViewModel
    
    var body: some View {
        RecordFormView(record: $record)
            .navigationBarTitle("Edit", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.viewModel.apply(.onSaveButtonTapped(record: self.record))
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            })
    }
}

struct EditRecordView_Previews: PreviewProvider {
    static var previews: some View {
        EditRecordView(record: Record(time: Date().timeIntervalSince1970), viewModel: AddRecordViewModel())
    }
}
