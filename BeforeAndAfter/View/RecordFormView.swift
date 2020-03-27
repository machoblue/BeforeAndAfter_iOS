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
    
    var weightBinding: Binding<String> {
        Binding<String>(
            get: {
                self.weightText
            },
            set: {
                self.weightText = $0
                self.record.weight = Float(self.weightText) ?? 0
            }
        )
    }

    var fatPercentBinding: Binding<String> {
        Binding<String>(
            get: {
                self.fatPercentText
            },
            set: {
                self.fatPercentText = $0
                self.record.fatPercent = Float(self.fatPercentText) ?? 0
            }
        )
    }

    var body: some View {
        List {
            Section(header: Text("record_form_weight_header".localized)) {
                HStack {
                    TextField("record_form_weight_placeholder".localized, text: weightBinding)
                        .keyboardType(.decimalPad)
                    Stepper(onIncrement: {
                        let currentValue = Float(self.weightText) ?? 0
                        let newValue = currentValue + 0.1
                        self.record.weight = newValue
                        self.weightText = String(format: "%.2f", newValue)
                    }, onDecrement: {
                        let currentValue = Float(self.weightText) ?? 0
                        let newValue = currentValue - 0.1
                        self.record.weight = newValue
                        self.weightText = String(format: "%.2f", newValue)
                    }) {
                        Text("") // ダミー。TextFieldをここにおくべきだが、変な動作をするので、外に出した。
                    }
                }
            }
            
            Section(header: Text("record_form_fat_percent_header".localized)) {
                HStack {
                    TextField("record_form_fat_percent_placeholder".localized, text: fatPercentBinding)
                        .keyboardType(.decimalPad)
                    Stepper(onIncrement: {
                        let currentValue = Float(self.fatPercentText) ?? 0
                        let newValue = currentValue + 0.1
                        self.record.fatPercent = newValue
                        self.fatPercentText = String(format: "%.2f", newValue)
                    }, onDecrement: {
                        let currentValue = Float(self.fatPercentText) ?? 0
                        let newValue = currentValue - 0.1
                        self.record.fatPercent = newValue
                        self.fatPercentText = String(format: "%.2f", newValue)
                    }) {
                        Text("")
                    }
                }
            }

            Section(header: Text("record_form_note_header".localized)) {
                TextField("record_form_note_placeholder".localized, text: $record.note.bound)
            }

        }
        .listStyle(GroupedListStyle())
        .onAppear() {
            self.weightText = String(format: "%.2f", self.record.weight ?? 0)
            self.fatPercentText = String(format: "%.2f", self.record.fatPercent ?? 0)
        }
    }
}

struct RecordFormView_Previews: PreviewProvider {
    static var previews: some View {
        RecordFormView(record: .constant(Record(time: Date().timeIntervalSince1970)))
    }
}
