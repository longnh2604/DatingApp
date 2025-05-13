//
//  DestinationHostingController.swift
//  SwiftUIBase
//
//  Created by LongNH8 on 12/5/25.
//

import SwiftUI

// MARK: - Protocol
public protocol DestinationView {
    var navigationBarTitleConfiguration: NavigationBarTitleConfiguration { get }
}

// MARK: - DestinationHostingController
open class DestinationHostingController<T: View>: UIHostingController<T> {
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let rootMirror = Mirror(reflecting: rootView)

        let storageMirror = rootView is AnyView ? rootMirror : Mirror(reflecting: rootMirror.descendant("content")!)
        let navigationTitleConfiguration = extractNavigationTitleConfiguration(storageMirror: storageMirror)

        if let navigationTitleConfiguration = navigationTitleConfiguration {
            navigationItem.title = navigationTitleConfiguration.title
            navigationItem.largeTitleDisplayMode = navigationTitleConfiguration.displayMode.uikitDisplayMode
        }
    }

    private func extractNavigationTitleConfiguration(storageMirror: Mirror) -> NavigationBarTitleConfiguration? {
        guard let storage = storageMirror.descendant("storage") else { return nil }
        let storageMirror = Mirror(reflecting: storage)

        guard let swiftUIView = storageMirror.descendant("view") else { return nil }
        if let view = swiftUIView as? DestinationView {
            return view.navigationBarTitleConfiguration
        }

        return nil
    }
}

// MARK: - NavigationBarTitleConfiguration
public struct NavigationBarTitleConfiguration {
    public let title: String
    public let displayMode: NavigationBarItem.TitleDisplayMode

    public init(title: String, displayMode: NavigationBarItem.TitleDisplayMode) {
        self.title = title
        self.displayMode = displayMode
    }
}

extension NavigationBarItem.TitleDisplayMode {
    var uikitDisplayMode: UINavigationItem.LargeTitleDisplayMode {
        switch self {
        case .automatic: return .automatic
        case .inline: return .never
        case .large: return .always
        @unknown default: return .automatic
        }
    }
}
