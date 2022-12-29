//
//  MainView.swift
//  ConvertTiles(Beta)
//
//  Created by Jason Koehn on 12/26/22.
//

import SwiftUI

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("pro") var pro : Bool = false
    @State private var converters: [Converter] = []
    @State private var showAddATileView: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var presentPurchaseSheet: Bool = false
    @FocusState var isInputActive: Bool
    @State private var editMode: EditMode = .inactive
    @State private var isEditing: Bool = false
    @State private var accentColor: Color = decodeUDColor(key: "accentColor")
    private var columns = [GridItem(.adaptive(minimum: 335))]
    @State private var saveNewUnits: Bool = false
    @State private var newUnits: [NewUnits] = []
    @State private var numOfNewUnits: Int = 0
    var body: some View {
        NavigationStack {
            ZStack {
                if isEditing {
                    List {
                        ForEach(converters, id: \.id) { converter in
                            Text(converter.name)
                                .foregroundColor(converter.hasCustomAccentColor ? decodeColor(color: converter.customAccentColor) : accentColor)
                                .font(.system(size: 20))
                        }
                        .onMove { indexSet, offset in
                            converters.move(fromOffsets: indexSet, toOffset: offset)
                        }
                        .onDelete { indexSet in
                            converters.remove(atOffsets: indexSet)
                        }
                    }
                    .environment(\.editMode, $editMode)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(converters, id: \.id) { converter in
                                TileView(name: converter.name, id: converter.id, group: converter.group, unitsAmount: converter.unitsAmount, units: converter.units, inUnit: converter.inUnit, outUnit: converter.outUnit, hasCustomAccentColor: converter.hasCustomAccentColor, customAccentColor: converter.customAccentColor, accentColor: $accentColor, pro: $pro, isInputActive: _isInputActive, saveNewUnits: $saveNewUnits, newUnits: $newUnits, numOfNewUnits: $numOfNewUnits)
                            }
                        }
                        .padding(.horizontal, 7)
                    }
                }
            }
            .navigationTitle("Converters")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettingsView.toggle()
                    }) {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        isEditing.toggle()
                        editMode = isEditing ? .active : .inactive
                        if isEditing == false {
                            saveToArray(converters: converters)
                        }
                    }) {
                        if isEditing {
                            Text("Done")
                        } else {
                            Text("Edit")
                        }
                    }
                    Button(action: {
                        if pro {
                            showAddATileView.toggle()
                        } else {
                            if converters.count > 2 {
                                presentPurchaseSheet.toggle()
                            } else {
                                showAddATileView.toggle()
                            }
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isInputActive = false
                    }
                }
            }
        }
        .sheet(isPresented: $showAddATileView) {
            NavigationStack {
                AddATileView(converters: $converters, accentColor: accentColor)
            }
        }
        .sheet(isPresented: $showSettingsView) {
            NavigationStack {
                SettingsView(accentColor: $accentColor)
            }
        }
        .fullScreenCover(isPresented: $presentPurchaseSheet) {
            NavigationStack {
                InAppPurchaseView()
            }
        }
        .task {
            // Retrieve Arrays
            let manager = FileManager.default
            let decoder = PropertyListDecoder()
            guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            let convertersUrl = url.appendingPathComponent("converters.plist")
            if let data = try? Data(contentsOf: convertersUrl) {
                if let response = try? decoder.decode([Converter].self, from: data) {
                    converters = response
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if pro {
                if phase == .background {
                    saveNewUnits = true
                }
            }
        }
        .onChange(of: numOfNewUnits) { num in
            if num == converters.count {
                var newConverters: [Converter] = []
                for converter in converters {
                    for unit in newUnits {
                        if unit.id == converter.id {
                            newConverters.append(Converter(name: converter.name, id: converter.id, group: converter.group, unitsAmount: converter.unitsAmount, units: converter.units, inUnit: unit.inUnit, outUnit: unit.outUnit, hasCustomAccentColor: converter.hasCustomAccentColor, customAccentColor: converter.customAccentColor))
                        }
                    }
                }
                saveToArray(converters: newConverters)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
