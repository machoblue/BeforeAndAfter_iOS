//
//  TargetView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/08.
//

import SwiftUI

struct TargetView: View {
    @State var weightTarget: String = ""
    @State var fatPercentTarget: String = ""
    var body: some View {
        VStack {
            Text("インストールありがとうございます。")
            Spacer()
                .frame(width: 10, height: 24)
            Text("まず、目標を入力してください。")
            
            Spacer()
                .frame(width: 10, height: 48)
            
            HStack {
                TextField("目標体重", text: $weightTarget)
                    .frame(width: 160)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("kg")
            }
            
            Spacer()
                .frame(width: 10, height: 24)
            
            HStack {
                TextField("目標体脂肪率", text: $fatPercentTarget)
                    .frame(width: 160)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("%")
            }
            
            Spacer()
                .frame(width: 10, height: 64)

            Button(action: {
                
            }) {
                HStack {
                    Spacer()
                    Text("次へ")
                    Spacer()
                }
                .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
            }
            .accentColor(.white)
            .background(Color.blue)
            .cornerRadius(8)

            Button(action: {
                
            }) {
                Text("スキップ")
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
        }
        .padding(EdgeInsets(top: 0, leading: 36, bottom: 0, trailing: 36))
    }
}

struct TargetView_Previews: PreviewProvider {
    static var previews: some View {
        TargetView()
    }
}
