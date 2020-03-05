//
//  TargetEditView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/05.
//

import SwiftUI

struct TargetEditView: View {
    @ObservedObject var viewModel: TargetViewModel
    @State var weightTargetText: String = ""
    @State var fatPercentTargetText: String = ""
    
    init(viewModel: TargetViewModel = TargetViewModel()) {
        self.viewModel = viewModel
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        return formatter
    } ()

    // workaround for SwiftUI's decmail format issue
    // https://stackoverflow.com/questions/56799456/swiftui-textfield-with-formatter-not-working
    var weightProxy: Binding<String> {
        Binding<String>(
            get: {
                if let weight = self.viewModel.weightTarget {
                    return String(format: "%.02f", weight)
                } else {
                    return ""
                }
            },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.viewModel.weightTarget = value.floatValue
                }
            }
        )
    }
    
    var fatPercentProxy: Binding<String> {
        Binding<String>(
            get: {
                if let fatPercent = self.viewModel.fatPercentTarget {
                    return String(format: "%.02f", fatPercent)
                } else {
                    return ""
                }
            },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.viewModel.fatPercentTarget = value.floatValue
                }
            }
        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Weight Target (kg)")) {
                HStack {
                    Stepper(onIncrement: {
                        self.viewModel.weightTarget = (self.viewModel.weightTarget ?? 0) + 0.1
                    }, onDecrement: {
                        self.viewModel.weightTarget = (self.viewModel.weightTarget ?? 0) - 0.1
                    }) {
                        TextField("Enter your weight in kg.", text: weightProxy)
                            .keyboardType(.decimalPad)
                    }
                }
            }

            Section(header: Text("Fat Percent Target")) {
                HStack {
                    Stepper(onIncrement: {
                        self.viewModel.fatPercentTarget = (self.viewModel.fatPercentTarget ?? 0) + 0.1
                    }, onDecrement: {
                        self.viewModel.fatPercentTarget = (self.viewModel.fatPercentTarget ?? 0) - 0.1
                    }) {
                        TextField("Enter your fat percent.", text: fatPercentProxy)
                            .keyboardType(.decimalPad)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Target")
        .navigationBarItems(trailing: Button(action: {
            self.viewModel.apply(.onSaveButtonTapped(weightTarget: self.viewModel.weightTarget, fatPercentTarget: self.viewModel.fatPercentTarget))
            // TODO: close
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
