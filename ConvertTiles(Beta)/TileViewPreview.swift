//
//  TileViewPreview.swift
//  ConvertTiles(Beta)
//
//  Created by Jason Koehn on 1/4/23.
//

import SwiftUI

struct TileViewPreview: View {
    @Binding var name: String
    @Binding var group: String
    @Binding var unitsAmount: String
    @Binding var units: [String]
    @Binding var inUnit: String
    @Binding var outUnit: String
    var accentColor: Color
    @FocusState var isInputActive: Bool
    @State private var firstAmount: Double = 1
    var body: some View {
        VStack {
            Text(name)
                .font(.system(size: 25))
                .frame(height: 20)
                .padding(.top, 15)
            HStack {
                Spacer().overlay {
                    VStack {
                        if unitsAmount == "Single" {
                            Text(inUnit)
                                .foregroundColor(accentColor)
                                .padding(.vertical, 5)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Picker("Unit", selection: $inUnit) {
                                ForEach(units, id: \.self) { unit in
                                    Text(unit).tag(unit)
                                }
                            }
                            .accentColor(accentColor)
                            .pickerStyle(.menu)
                            .padding(.vertical, 5)
                        }
                        TextField("Value", value: $firstAmount, formatter: Formatter.inNumberFormat)
                            .onTapGesture {
                                firstAmount = 0
                            }
                            .onChange(of: isInputActive) { input in
                                if input == false && firstAmount == 0 {
                                    firstAmount = 1
                                }
                            }
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .focused($isInputActive)
                            .frame(width: 100)
                    }
                }
                Button(action: {
                        let inu = inUnit
                        let outu = outUnit
                        inUnit = outu
                        outUnit = inu
                }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(accentColor)
                        .font(.system(size: 23))
                }
                Spacer().overlay {
                    VStack {
                        if unitsAmount == "Single" {
                            Text(outUnit)
                                .foregroundColor(accentColor)
                                .padding(.vertical, 5)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Picker("Unit", selection: $outUnit) {
                                ForEach(units, id: \.self) { unit in
                                    Text(unit).tag(unit)
                                }
                            }
                            .accentColor(accentColor)
                            .pickerStyle(.menu)
                            .padding(.vertical, 5)
                        }
                        Text(FormatAnswer(from: Measurement(value: firstAmount, unit: SwitchToUnits(string: inUnit)).converted(to: SwitchToUnits(string: outUnit)).value as NSNumber))
                            .font(.system(size: 25))
                            .textSelection(.enabled)
                    }
                }
            }
            .padding(.top, 30)
            .padding(.bottom, 53)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputActive = false
                }
            }
        }
        .background(Color(.systemGray5))
        .cornerRadius(12)
    }
}
