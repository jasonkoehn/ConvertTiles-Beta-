//
//  IAPurchaseView.swift
//  ConvertTiles(Beta)
//
//  Created by Jason Koehn on 12/23/22.
//

import SwiftUI

struct InAppPurchaseView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Text("Purchase Pro!")
                .font(.system(size: 45))
                .fontDesign(.serif)
                .fontWeight(.semibold)
                .padding(.bottom)
            VStack(spacing: 10) {
                Text("Advantages of pro:")
                    .font(.system(size: 25))
                    .italic()
                Text("20 converter groups.")
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                    .fontDesign(.rounded)
                Text("More than three tiles at a time.")
                    .foregroundColor(.mint)
                    .font(.system(size: 23))
                Text("More units in the original converter groups.")
                    .foregroundColor(.orange)
                    .font(.system(size: 21))
                Text("Custom Accent Colors.")
                    .foregroundColor(.red)
                    .font(.system(size: 23))
                    .fontDesign(.rounded)
                Text("Custom Unit Selection.")
                    .foregroundColor(.cyan)
                    .font(.system(size: 23))
                    .fontDesign(.serif)
                Text("Single unit selection option.")
                    .foregroundColor(.indigo)
                    .font(.system(size: 23))
                Text("Saving of last used unit.")
                    .foregroundColor(.blue)
                    .font(.system(size: 23))
                Text("And more!")
                    .foregroundColor(.green)
                    .font(.system(size: 25))
                    .fontDesign(.monospaced)
            }
            Spacer()
            HStack{Spacer()}
            Button(action: {
                // Monthly Purchase
            }) {
                VStack {
                    Text("$0.99")
                        .foregroundColor(.black)
                        .font(.system(size: 22))
                    Text("Per Month")
                        .foregroundColor(.white)
                        .italic()
                }
                .frame(width: 330, height: 60)
                .background(.indigo)
                .cornerRadius(8)
            }
            Button(action: {
                // Yearly Purchase
            }) {
                VStack {
                    Text("$9.99")
                        .foregroundColor(.black)
                        .font(.system(size: 22))
                    Text("Per Month")
                        .foregroundColor(.white)
                        .italic()
                }
                .frame(width: 330, height: 60)
                .background(.indigo)
                .cornerRadius(8)
            }
            Spacer()
        }
        .padding(.vertical, 30)
        .preferredColorScheme(.dark)
        .background(Color(.systemGray5))
        .toolbar {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 25))
            }
        }
    }
}
