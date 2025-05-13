//
//  NotificationHelper.swift
//  SwiftUIBase
//
//  Created by LongNH8 on 12/5/25.
//

import Foundation

extension Notification.Name {
    static let errorNetworkNoti = Notification.Name("notification_error_network")
    static let errorCommonNoti = Notification.Name("notification_error_common")
    static let changeLanguageNoti = Notification.Name("app_language_change")
    static let tokenExpiredNoti = Notification.Name("token_expired")
}
