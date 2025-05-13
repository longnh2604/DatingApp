//
//  Color+Extensions.swift
//  CogSmart
//
//  Created by longnh on 2023/04/17.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    public static let green6FCF97 = Color(hex: "6FCF97")
    public static let yellowFFF6D4 = Color(hex: "FFF6D4")
    public static let redFE5C5C = Color(hex: "FE5C5C")
    public static let redF84243 = Color(hex: "F84243")
    public static let redFF9A9F = Color(hex: "FF9A9F")
    public static let redF64742 = Color(hex: "F64742")
    public static let gray8E8E8E = Color(hex: "8E8E8E")
    public static let grayF5F5F5 = Color(hex: "F5F5F5")
    public static let grayF5F7FB = Color(hex: "F5F7FB")
    public static let gray949497 = Color(hex: "949497")
    public static let grayDBDBDB = Color(hex: "DBDBDB")
    public static let redFF134C = Color(hex: "FF134C")
    public static let redEB5757 = Color(hex: "#EB5757")
    public static let redFFE4EB = Color(hex: "#FFE4EB")
    public static let black1E1E1E = Color(hex: "1E1E1E")
    public static let black121212 = Color(hex: "121212")
    public static let blue18ABFD = Color(hex: "18ABFD")
    public static let blue1868FD = Color(hex: "1868FD")
    public static let blue1983FE = Color(hex: "1983FE")
    public static let blueE8F0FF = Color(hex: "E8F0FF")
    public static let blueD2E2FF = Color(hex: "D2E2FF")
    public static let poor = Color(hex: "EBE8FF")
    public static let average = Color(hex: "BEE7FF")
    public static let good = Color(hex: "D3FFBE")
    public static let veryGood = Color(hex: "FFC4A3")
    public static let excellent = Color(hex: "FFE8AE")
    public static let poorBorder = Color(hex: "CBC2FF")
    public static let averageBorder = Color(hex: "8CD5FF")
    public static let goodBorder = Color(hex: "AAEE8A")
    public static let veryGoodBorder = Color(hex: "FFAE80")
    public static let excellentBorder = Color(hex: "FFAE80")
    public static let orangeFDA118 = Color(hex: "FDA118")
    public static let buttonEnabled = Color(#colorLiteral(red: 0.8509803922, green: 0.02352941176, blue: 0.08235294118, alpha: 1))
    public static let buttonDisabled = Color(#colorLiteral(red: 0.9607843137, green: 0.5764705882, blue: 0.5607843137, alpha: 1))
}
