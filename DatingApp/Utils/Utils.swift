//
//  Utils.swift
//  SwiftUIBase
//
//  Created by LongNH8 on 12/5/25.
//

import Foundation

func infoForKey(_ key: String) -> String {
    guard let value = Bundle.main.infoDictionary?[key] as? String else {
        print("⚠️ Missing key: \(key) in Info.plist")
        return ""
    }
    return value
}
