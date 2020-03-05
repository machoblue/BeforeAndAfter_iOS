//
//  SettingsView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/05.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Basic")) {
                    NavigationLink(destination: TargetEditView()) {
                        Text("Target")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
