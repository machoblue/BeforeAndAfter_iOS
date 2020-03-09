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
            Text("インストールありがとうございます。")
            Text("まず、目標を入力してください。")
                .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))

            HStack {
                TextField("目標体重", text: $weightTarget)
                    .frame(width: 160)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("kg")
            }
            .padding(EdgeInsets(top: 48, leading: 0, bottom: 0, trailing: 0))

            HStack {
                TextField("目標体脂肪率", text: $fatPercentTarget)
                    .frame(width: 160)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("%")
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
                    Text("保存")
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
                Text("スキップ")
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
