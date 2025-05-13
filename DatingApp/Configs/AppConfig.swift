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
            return infoForKey("API_ENDPOINT")
        }
        
        static var version: String {
            return infoForKey("API_VERSION")
        }
    }
    
    enum App {
        static var appName: String {
            return infoForKey("CFBundleDisplayName") // or "CFBundleName"
        }
    }
}
