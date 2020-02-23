//
//  RecordFormView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/19.
//

import SwiftUI

struct RecordFormView: View {
    @Binding var record: Record
    @State var weightText: String = ""
    @State var fatPercentText: String = ""
    
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
                if let weight = self.record.weight {
                    return String(format: "%.02f", weight)
                } else {
                    return ""
                }
            },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.record.weight = value.floatValue
                }
            }
        )
    }
    
    var fatPercentProxy: Binding<String> {
        Binding<String>(
            get: {
                if let fatPercent = self.record.fatPercent {
                    return String(format: "%.02f", fatPercent)
                } else {
                    return ""
                }
            },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.record.fatPercent = value.floatValue
                }
            }
        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Weight(kg)")) {
                HStack {
                    Stepper(onIncrement: {
                        self.record.weight = (self.record.weight ?? 0) + 0.1
                    }, onDecrement: {
                        self.record.weight = (self.record.weight ?? 0) - 0.1
                    }) {
//                        TextField("Enter your weight in kg.", value: $record.weight, formatter: numberFormatter)
                        TextField("Enter your weight in kg.", text: weightProxy)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            
            Section(header: Text("Fat Percent")) {
                HStack {
                    Stepper(onIncrement: {
                        self.record.fatPercent = (self.record.fatPercent ?? 0) + 0.1
                    }, onDecrement: {
                        self.record.fatPercent = (self.record.fatPercent ?? 0) - 0.1
                    }) {
                        TextField("Enter your fat percent.", text: fatPercentProxy)
                            .keyboardType(.decimalPad)
                    }
                }
            }

            Section(header: Text("Note")) {
                TextField("Note", text: $record.note.bound)
            }

        }
        .listStyle(GroupedListStyle())
    }
}

struct RecordFormView_Previews: PreviewProvider {
    static var previews: some View {
        RecordFormView(record: .constant(Record(time: Date().timeIntervalSince1970)))
    }
}
