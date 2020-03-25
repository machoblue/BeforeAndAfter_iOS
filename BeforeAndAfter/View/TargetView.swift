//
//  TargetView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/08.
//

import SwiftUI

struct TargetView: View {
    @ObservedObject var viewModel: TargetViewModel
    @State var weightTarget: String = ""
    @State var fatPercentTarget: String = ""
    @State var presentTabView = false
    
    init(viewModel: TargetViewModel = TargetViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("intro_target_message_1".localized)
            Text("intro_target_message_2".localized)
                .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))

            HStack {
                TextField("intro_target_weight_placeholder".localized, text: $weightTarget)
                    .frame(width: 160)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("common_kg".localized)
            }
            .padding(EdgeInsets(top: 48, leading: 0, bottom: 0, trailing: 0))

            HStack {
                TextField("intro_target_fat_percent_placeholder".localized, text: $fatPercentTarget)
                    .frame(width: 160)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("common_percent".localized)
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))

            Spacer()
                .frame(width: 10, height: 64)

            Button(action: {
                self.viewModel.apply(.onSaveButtonTapped(weightTarget: Float(self.weightTarget) ?? 0, fatPercentTarget: Float(self.fatPercentTarget) ?? 0))
                self.presentTabView = true
            }) {
                HStack {
                    Spacer()
                    Text("common_save".localized)
                    Spacer()
                }
                .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
            }
            .accentColor(.white)
            .background(Color.blue)
            .cornerRadius(8)

            Button(action: {
                self.presentTabView = true
            }) {
                Text("common_skip".localized)
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
            
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 36, bottom: 0, trailing: 36))
        .overlay(presentTabView ? BATabView() : nil)
    }
}

struct TargetView_Previews: PreviewProvider {
    static var previews: some View {
        TargetView()
    }
}
