//
//  AddATileView.swift
//  ConvertTiles(Beta)
//
//  Created by Jason Koehn on 12/26/22.
//

import SwiftUI

struct AddATileView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("pro") var pro: Bool = false
    @Binding var converters: [Converter]
    @State var accentColor: Color
    @State private var name: String = ""
    @State private var group: String = "Acceleration"
    @State private var unitsAmount: String = "Multiple"
    @State private var units: [String] = []
    @State private var inUnit: String = ""
    @State private var outUnit: String = ""
    @State private var hasCustomAccentColor: Bool = false
    @State private var hasCustomUnits: Bool = false
    @State private var customUnits: [String] = []
    var body: some View {
//        VStack(spacing: 1) {
//            TileViewPreview(name: $name, group: $group, unitsAmount: $unitsAmount, units: hasCustomUnits ? $customUnits : $units, inUnit: $inUnit, outUnit: $outUnit, accentColor: accentColor)
//                .padding(.horizontal, 7)
        Form {
            if pro {
                // Pro
                //Selection of the Group
                Picker("Group:", selection: $group) {
                    ForEach(convertersList, id: \.group) { converter in
                        Text(converter.group).tag(converter.group)
                            .task {
                                name = converter.group
                                units = converter.units
                                inUnit = units.first ?? ""
                                outUnit = units.first ?? ""
                            }
                            .onChange(of: group) { group in
                                customUnits = []
                                if hasCustomUnits {
                                    inUnit = ""
                                    outUnit = ""
                                }
                            }
                    }
                }
                .pickerStyle(.navigationLink)
                // Name Slot
                HStack {
                    Text("Name:")
                    TextField(group, text: $name)
                    ZStack {
                        Button(action: {
                            name = ""
                        }) {
                            Image(systemName: "multiply")
                                .foregroundColor(.blue)
                                .font(.system(size: 24))
                        }
                    }
                }
                // UnitsAmount Picker
                Picker("", selection: $unitsAmount) {
                    Text("Multiple Units").tag("Multiple")
                    Text("Single Selections").tag("Single")
                }
                .pickerStyle(.segmented)
                // Custom Color Toggle
                Toggle("Custom Accent Color?", isOn: $hasCustomAccentColor)
                if hasCustomAccentColor {
                    ColorPicker("Custom Accent Color:", selection: $accentColor)
                }
                // Conditional Pickers
                if unitsAmount == "Multiple" {
                    Toggle("Custom Units?", isOn: $hasCustomUnits)
                    if hasCustomUnits {
                        NavigationLink("Select Units:") {
                            List {
                                ForEach(units, id: \.self) { unit in
                                    Button(action: {
                                        if customUnits.contains(unit) {
                                            customUnits.removeAll(where: {$0 == unit})
                                        } else {
                                            customUnits.append(unit)
                                        }
                                    }) {
                                        HStack {
                                            Text(unit)
                                                .foregroundColor(accentColor)
                                            if customUnits.contains(unit) {
                                                Spacer()
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            }
                            .task {
//                                if inUnit == "" {
                                    inUnit = customUnits.first ?? ""
                                    outUnit = customUnits.first ?? ""
//                                }
                            }
                        }
                        if customUnits != [] {
                            Picker("Initial In Unit:", selection: $inUnit) {
                                ForEach(customUnits, id: \.self) { unit in
                                    Text(unit).tag(unit)
                                }
                            }
                            .pickerStyle(.menu)
                            Picker("Initial Out Unit:", selection: $outUnit) {
                                ForEach(customUnits, id: \.self) { unit in
                                    Text(unit).tag(unit)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    } else {
                        Picker("Initial In Unit:", selection: $inUnit) {
                            ForEach(units, id: \.self) { unit in
                                Text(unit).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                        Picker("Initial Out Unit", selection: $outUnit) {
                            ForEach(units, id: \.self) { unit in
                                Text(unit).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                } else if unitsAmount == "Single" {
                    Picker("In Unit:", selection: $inUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                    .pickerStyle(.menu)
                    Picker("Out Unit:", selection: $outUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                    .pickerStyle(.menu)
                }
            } else {
                // Basic
                Picker("Group:", selection: $group) {
                    ForEach(basicConverters, id: \.group) { converter in
                        Text(converter.group).tag(converter.group)
                            .task {
                                name = converter.group
                                units = converter.units
                                inUnit = converter.inUnit
                                outUnit = converter.outUnit
                            }
                    }
                }
                .pickerStyle(.navigationLink)
            }
        }
//        }
        .navigationTitle("Add A Tile")
        .accentColor(accentColor)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    converters.append(Converter(name: name, id: UUID(), group: group, unitsAmount: unitsAmount, units: hasCustomUnits ? customUnits : units, inUnit: inUnit, outUnit: outUnit, hasCustomAccentColor: hasCustomAccentColor, customAccentColor: encodeColor(color: accentColor)))
                    saveToArray(converters: converters)
                    dismiss()
                }) {
                    Text("Save")
                }
            }
        }
    }
}



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
