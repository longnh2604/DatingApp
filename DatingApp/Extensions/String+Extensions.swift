//
//  String+Extensions.swift
//  CogSmart
//
//  Created by longnh on 2023/06/01.
//

import Foundation

// MARK: CONVERT DATE
extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}
extension String {
    // Switch Day of Week to Japanese Style
    func onConvertJPDayWeek(content: String) -> String {
        if content.contains("Mon") {
            return content.replacingOccurrences(of: "Mon", with: "月")
        }
        if content.contains("Tue") {
            return content.replacingOccurrences(of: "Tue", with: "火")
        }
        if content.contains("Wed") {
            return content.replacingOccurrences(of: "Wed", with: "水")
        }
        if content.contains("Thu") {
            return content.replacingOccurrences(of: "Thu", with: "木")
        }
        if content.contains("Fri") {
            return content.replacingOccurrences(of: "Fri", with: "金")
        }
        if content.contains("Sat") {
            return content.replacingOccurrences(of: "Sat", with: "土")
        }
        if content.contains("Sun") {
            return content.replacingOccurrences(of: "Sun", with: "日")
        }
        return content
    }
    
    var isContainFullWidth: Bool {
        return self.unicodeScalars.contains { $0.isFullwidth }
    }
    
    var isFullWidth: Bool {
        return self.unicodeScalars.contains { $0.isFullwidth }
    }
}

extension UnicodeScalar {
    var isFullwidth: Bool {
        switch self.value {
        case 0x1100...0x115F: return true
        case 0x2329...0x232A: return true
        case 0x2E80...0x2FFB: return true
        case 0x3000...0x303E: return true
        case 0x3041...0x33FF: return true
        case 0x3400...0x4DB5: return true
        case 0x4E00...0x9FBB: return true
        case 0xA000...0xA4C6: return true
        case 0xAC00...0xD7A3: return true
        case 0xF900...0xFAD9: return true
        case 0xFE10...0xFE19: return true
        case 0xFE30...0xFE6B: return true
        case 0x20000...0x2A6D6: return true
        case 0x2A6D7...0x2F7FF: return true
        case 0x2F800...0x2FA1D: return true
        case 0x2FA1E...0x2FFFD: return true
        case 0x30000...0x3FFFD: return true
            
        case 0xFF01...0xFF60: return true
        case 0xFFE0...0xFFE6: return true
        default:
            return false
        }
    }
}
