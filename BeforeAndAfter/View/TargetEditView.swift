//
//  TargetEditView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/05.
//

import SwiftUI

struct TargetEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TargetViewModel

    init(viewModel: TargetViewModel = TargetViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            Section(header: Text("Weight Target (kg)")) {
                HStack {
                    TextField("Enter your weight in kg.", text: $viewModel.weightTargetText)
                        .keyboardType(.decimalPad)
                    Stepper(onIncrement: {
                        let currentValue = Float(self.viewModel.weightTargetText) ?? 0
                        let newValue = currentValue + 0.1
                        self.viewModel.weightTargetText = String(format: "%.2f", newValue)
                    }, onDecrement: {
                        let currentValue = Float(self.viewModel.fatPercentTargetText) ?? 0
                        let newValue = currentValue - 0.1
                        self.viewModel.fatPercentTargetText = String(format: "%.2f", newValue)
                    }) {
                        Text("")
                    }
                }
            }

            Section(header: Text("Fat Percent Target")) {
                HStack {
                    TextField("Enter your fat percent.", text: $viewModel.fatPercentTargetText)
                        .keyboardType(.decimalPad)
                    Stepper(onIncrement: {
                        let currentValue = Float(self.viewModel.weightTargetText) ?? 0
                        let newValue = currentValue + 0.1
                        self.viewModel.weightTargetText = String(format: "%.2f", newValue)
                    }, onDecrement: {
                        let currentValue = Float(self.viewModel.fatPercentTargetText) ?? 0
                        let newValue = currentValue - 0.1
                        self.viewModel.fatPercentTargetText = String(format: "%.2f", newValue)
                    }) {
                        Text("")
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Target")
        .navigationBarItems(trailing: Button(action: {
            self.viewModel.apply(.onSaveButtonTapped(weightTarget: Float(self.viewModel.weightTargetText) ?? 0, fatPercentTarget: Float(self.viewModel.fatPercentTargetText) ?? 0))
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save")
        })
        .onAppear() {
            self.viewModel.apply(.onAppear)
        }
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        TargetEditView()
    }
}
