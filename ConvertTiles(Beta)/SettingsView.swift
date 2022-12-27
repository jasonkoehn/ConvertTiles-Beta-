//
//  SettingsView.swift
//  ConvertTiles(Beta)
//
//  Created by Jason Koehn on 12/23/22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("pro") var pro: Bool = false
    @Binding var accentColor: Color
    @State private var presentPurchaseSheet: Bool = false
    var body: some View {
        VStack {
            Form {
                Section {
                    if pro == false {
                        Button(action: {
                            presentPurchaseSheet.toggle()
                        }) {
                            Text("Upgrade to Pro")
                        }
                    }
                    if pro {
                        ColorPicker(selection: $accentColor, supportsOpacity: true) {
                            Text("Tiles Accent Color:")
                        }
                    } else {
                        HStack {
                            Text("Tiles Accent Color:")
                            Spacer()
                            Button(action: {
                                presentPurchaseSheet.toggle()
                            }) {
                                Text("Upgrade")
                            }
                        }
                    }
                }
                Section {
                    Button(action: {
                        // Restore Purchase
                        // Debug
                        pro.toggle()
                    }) {
                        Text("Restore Purchase")
                    }
                    Link("GitHub", destination: URL(string: "https://github.com/jasonkoehn/ConvertTiles")!)
                }
            }
            Spacer()
            Text("MIT License")
                .font(.system(size: 12))
            Text("© 2023 Jason Koehn")
                .font(.system(size: 12))
        }
        .navigationTitle("Settings")
        .toolbar {
            Button(action: {
                UserDefaults.standard.set(encodeColor(color: accentColor), forKey: "accentColor")
                dismiss()
            }) {
                Text("Save")
            }
        }
        .fullScreenCover(isPresented: $presentPurchaseSheet) {
            NavigationView {
                InAppPurchaseView()
            }
        }
    }
}
