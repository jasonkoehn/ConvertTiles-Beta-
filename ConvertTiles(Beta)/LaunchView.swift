//
//  LaunchView.swift
//  ConvertTiles(Beta)
//
//  Created by Jason Koehn on 12/26/22.
//

import SwiftUI

struct LaunchView: View {
    @Binding var hasLaunchedBefore: Bool
    @State private var presentPurchaseSheet: Bool = false
    var body: some View {
        VStack {
            Text("Welcome To")
                .foregroundColor(.white)
                .font(.system(size: 45))
                .fontDesign(.serif)
            Text("ConvertTiles")
                .foregroundColor(.green)
                .font(.system(size: 60))
                .italic()
                .rotationEffect(Angle(degrees: 356))
                .padding(5)
            VStack(spacing: 8) {
                Text("Easy to use.")
                    .foregroundColor(.teal)
                    .font(.system(size: 21))
                    .fontDesign(.monospaced)
                Text("Open Source.")
                    .foregroundColor(.mint)
                    .font(.system(size: 21))
                    .padding(.bottom, 10)
                Text("Thanks for downloading.")
                    .foregroundColor(.cyan)
                    .font(.system(size: 23))
                    .italic()
                Text("Enjoy!")
                    .foregroundColor(.orange)
                    .font(.system(size: 30))
                    .fontDesign(.serif)
            }
            HStack{Spacer()}
            Spacer()
            VStack {
                Text("Purchase Pro?")
                    .font(.system(size: 22))
                HStack {
                    Button(action: {
                        // Monthly Purchase Button
                    }) {
                        VStack {
                            Text("$0.99")
                                .foregroundColor(.black)
                                .font(.system(size: 22))
                            Text("Per Month")
                                .foregroundColor(.white)
                                .italic()
                        }
                        .frame(width: 163, height: 60)
                        .background(.indigo)
                        .cornerRadius(8)
                    }
                    Spacer()
                    Button(action: {
                        // Yearly Purchase Button
                    }) {
                        VStack {
                            Text("$9.99")
                                .foregroundColor(.black)
                                .font(.system(size: 22))
                            Text("Per Year")
                                .foregroundColor(.white)
                                .italic()
                        }
                        .frame(width: 163, height: 60)
                        .background(.indigo)
                        .cornerRadius(8)
                    }
                }
                .frame(width: 340)
                Button(action: {
                    presentPurchaseSheet.toggle()
                }) {
                    Text("Learn More")
                        .foregroundColor(.white)
                        .font(.system(size: 23))
                        .italic()
                        .frame(width: 340, height: 50)
                        .background(.brown)
                        .cornerRadius(8)
                }
                Text("Not Ready for Pro?")
                    .font(.system(size: 22))
                    .padding(.top)
                Button(action: {
                    firstLaunchAction()
                }) {
                    Text("Launch App")
                        .foregroundColor(.white)
                        .font(.system(size: 23))
                        .italic()
                        .frame(width: 340, height: 50)
                        .background(.blue)
                        .cornerRadius(8)
                }
            }
            Spacer()
        }
        .padding(.vertical, 30)
        .preferredColorScheme(.dark)
        .background(Color(.systemGray5))
        .fullScreenCover(isPresented: $presentPurchaseSheet) {
            NavigationView {
                InAppPurchaseView()
            }
        }
    }
    func firstLaunchAction() {
        let initConverters: [Converter] = [Converter(name: "Length", id: UUID(), group: "Length", unitsAmount: "Multiple", units: ["Kilometers", "Decameters", "Meters", "Decimeters", "Centimeters", "Millimeters", "Inches", "Feet", "Yards", "Miles", "Nautical Miles"], inUnit: "Meters", outUnit: "Yards", hasCustomAccentColor: false, customAccentColor: []), Converter(name: "Mass", id: UUID(), group: "Mass", unitsAmount: "Multiple", units: ["Kilograms", "Grams", "Milligrams", "Ounces", "Pounds", "MetricTons", "ShortTons"], inUnit: "Kilograms", outUnit: "Pounds", hasCustomAccentColor: false, customAccentColor: [])]
        saveToArray(converters: initConverters)
        hasLaunchedBefore = true
    }
}
