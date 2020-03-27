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
                Section(header: Text("settings_basic".localized)) {
                    NavigationLink(destination: TargetEditView()) {
                        Text("settings_basic_target".localized)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("settings_title", displayMode: .inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
