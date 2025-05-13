//
//  Navigation.swift
//  SwiftUIBase
//
//  Created by LongNH8 on 12/5/25.
//

import Foundation
import SwiftUI

public var navigation: Navigation?

public class Navigation: ObservableObject {
    public let window: UIWindow
    private var currentNavigationController: UINavigationController?

    // MARK: - Init
    public init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Present
    public func presentOnRoot(_ view: AnyView, isFullScreen: Bool = false, animated: Bool = true) {
        let viewController = DestinationHostingController(rootView: view.environmentObject(self))
        if isFullScreen {
            viewController.modalPresentationStyle = .fullScreen
        }
        window.rootViewController?.present(viewController, animated: true)
    }

    public func presentWithNavigation(_ view: AnyView, animated: Bool = true) {
        let destinationController = DestinationHostingController(rootView: view.environmentObject(self))
        currentNavigationController = UINavigationController(rootViewController: destinationController)
        if let navigationController = currentNavigationController {
            window.rootViewController?.present(navigationController, animated: animated)
        }
    }

    // MARK: - Push
    public func pushView(_ view: AnyView, animated: Bool = true) {
        let destinationViewController = DestinationHostingController(rootView: view.environmentObject(self))
        pushViewController(destinationViewController, animated: animated)
    }

    private func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        let currentNavigationViewController = window.rootViewController?.children.first as? UINavigationController
        currentNavigationController = currentNavigationViewController
        currentNavigationController?.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - Pop
    public func popView(animated: Bool = true) {
        currentNavigationController?.popViewController(animated: animated)
    }
    
    public func popToRootView(animated: Bool = true) {
        currentNavigationController?.popToRootViewController(animated: animated)
    }
    
    public func popToView(index: Int, animated: Bool = true) {
        if let viewController = currentNavigationController?.viewControllers[index] {
            print(currentNavigationController?.viewControllers as Any)
            currentNavigationController?.popToViewController(viewController, animated: true)
        }
    }
    
    // MARK: - Dismiss
    public func dismissViewOnRoot() {
        window.rootViewController?.dismiss(animated: true)
    }
}
