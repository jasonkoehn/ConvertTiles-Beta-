//
//  Functions.swift
//  ConvertTiles(Beta)
//
//  Created by Jason Koehn on 12/22/22.
//

import SwiftUI

extension Formatter {
    static let inNumberFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.zeroSymbol = ""
        return formatter
    }()
}

func FormatAnswer(from: NSNumber) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 4
    return formatter.string(from: from)!
}

func saveToArray(converters: [Converter]) {
    let manager = FileManager.default
    guard let managerUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
    let encoder = PropertyListEncoder()
    let convertersUrl = managerUrl.appendingPathComponent("converters.plist")
    manager.createFile(atPath: convertersUrl.path, contents: nil, attributes: nil)
    let encodedData = try! encoder.encode(converters)
    try! encodedData.write(to: convertersUrl)
}

func encodeColor(color: Color) -> [CGFloat] {
    let color = UIColor(color).cgColor
    let components = color.components ?? [0.156956285238266, 0.3742818236351013, 0.9598580002784729, 1.0]
    return components
}

func decodeUDColor(key: String) -> Color {
    guard let array = UserDefaults.standard.object(forKey: key) as? [CGFloat] else {return Color.blue}
    let color = Color(red: array[0], green: array[1], blue: array[2], opacity: array[3])
    return color
}

func decodeColor(color: [CGFloat]) -> Color {
    let array = color
    let color = Color(red: array[0], green: array[1], blue: array[2], opacity: array[3])
    return color
}
