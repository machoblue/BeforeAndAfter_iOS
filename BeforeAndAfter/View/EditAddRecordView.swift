//
//  EditAddRecordView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/18.
//

import SwiftUI

struct EditAddRecordView: View {
    @State var record: Record
    var body: some View {
        NavigationView {
            RecordFormView(record: $record)
                .navigationBarTitle("Edit", displayMode: .inline)
        }
    }
}

struct EditAddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        EditAddRecordView(record: Record(time: Date().timeIntervalSince1970))
    }
}
