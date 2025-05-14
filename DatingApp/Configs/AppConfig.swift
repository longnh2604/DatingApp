//
//  AppConfig.swift
//  SwiftUIBase
//
//  Created by LongNH8 on 12/5/25.
//

import Foundation

enum AppConfig {
    enum API {
        static var endPoint: String {
            return Utils.shared.infoForKey("API_ENDPOINT")
        }
        
        static var version: String {
            return Utils.shared.infoForKey("API_VERSION")
        }
    }
    
    enum App {
        static var appName: String {
            return Utils.shared.infoForKey("CFBundleDisplayName") // or "CFBundleName"
        }
    }
}
