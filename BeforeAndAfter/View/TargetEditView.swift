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
            Section(header: Text("target_weight_section_header".localized)) {
                HStack {
                    TextField("target_weight_placeholder".localized, text: $viewModel.weightTargetText)
                        .keyboardType(.decimalPad)
                    Stepper(onIncrement: {
                        let currentValue = Float(self.viewModel.weightTargetText) ?? 0
                        let newValue = currentValue + 0.1
                        self.viewModel.weightTargetText = String(format: "%.2f", newValue)
                    }, onDecrement: {
                        let currentValue = Float(self.viewModel.weightTargetText) ?? 0
                        let newValue = currentValue - 0.1
                        self.viewModel.weightTargetText = String(format: "%.2f", newValue)
                    }) {
                        Text("")
                    }
                }
            }

            Section(header: Text("target_fat_percent_section_header".localized)) {
                HStack {
                    TextField("target_fat_percent_placeholder".localized, text: $viewModel.fatPercentTargetText)
                        .keyboardType(.decimalPad)
                    Stepper(onIncrement: {
                        let currentValue = Float(self.viewModel.fatPercentTargetText) ?? 0
                        let newValue = currentValue + 0.1
                        self.viewModel.fatPercentTargetText = String(format: "%.2f", newValue)
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
        .navigationBarTitle("settings_basic_target_title", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.viewModel.apply(.onSaveButtonTapped(weightTarget: Float(self.viewModel.weightTargetText) ?? 0, fatPercentTarget: Float(self.viewModel.fatPercentTargetText) ?? 0))
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("common_save".localized)
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
