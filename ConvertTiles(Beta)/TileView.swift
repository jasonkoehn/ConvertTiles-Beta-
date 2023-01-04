//
//  TileView.swift
//  ConvertTiles(Beta)
//
//  Created by Jason Koehn on 12/26/22.
//

import SwiftUI

struct TileView: View {
    var name: String
    var id: UUID
    var group: String
    var unitsAmount: String
    var units: [String]
    @State var inUnit: String
    @State var outUnit: String
    var hasCustomAccentColor: Bool
    var customAccentColor: [CGFloat]
    @Binding var accentColor: Color
    @Binding var pro: Bool
    @FocusState var isInputActive: Bool
    @Binding var saveNewUnits: Bool
    @Binding var newUnits: [NewUnits]
    @Binding var numOfNewUnits: Int
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
                                .foregroundColor(hasCustomAccentColor ? decodeColor(color: customAccentColor) : accentColor)
                                .padding(.vertical, 5)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Picker("Unit", selection: $inUnit) {
                                ForEach(units, id: \.self) { unit in
                                    Text(unit).tag(unit)
                                }
                            }
                            .accentColor(hasCustomAccentColor ? decodeColor(color: customAccentColor) : accentColor)
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
                    if pro {
                        let inu = inUnit
                        let outu = outUnit
                        inUnit = outu
                        outUnit = inu
                    }
                }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(hasCustomAccentColor ? decodeColor(color: customAccentColor) : accentColor)
                        .font(.system(size: 23))
                }
                Spacer().overlay {
                    VStack {
                        if unitsAmount == "Single" {
                            Text(outUnit)
                                .foregroundColor(hasCustomAccentColor ? decodeColor(color: customAccentColor) : accentColor)
                                .padding(.vertical, 5)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Picker("Unit", selection: $outUnit) {
                                ForEach(units, id: \.self) { unit in
                                    Text(unit).tag(unit)
                                }
                            }
                            .accentColor(hasCustomAccentColor ? decodeColor(color: customAccentColor) : accentColor)
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
        .onChange(of: saveNewUnits) { save in
            if save {
                newUnits.append(NewUnits(id: id, inUnit: inUnit, outUnit: outUnit))
                numOfNewUnits += 1
            }
        }
        .background(Color(.systemGray5))
        .cornerRadius(12)
    }
}
