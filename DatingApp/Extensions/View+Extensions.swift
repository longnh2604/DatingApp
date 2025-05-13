//
//  View+Extensions.swift
//  CogSmart
//
//  Created by longnh on 2023/04/18.
//

import SwiftUI

// Detect run background and foreground
extension View {
    func onAppWentToBackground(perform action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            action()
        }
    }
}

extension View {
    /// Hide or show the view based on a boolean value.
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder
    public func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

extension View {
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }

    public func roundCorners(radius: CGFloat = .zero, corners: UIRectCorner = .allCorners) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    public func roundCorners(
        radius: CGFloat = .zero,
        corners: UIRectCorner = .allCorners,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 1
    ) -> some View {
        let roundedRect = RoundedCorner(radius: radius, corners: corners)
        return clipShape(roundedRect)
            .overlay(roundedRect.stroke(borderColor, lineWidth: borderWidth))
    }

    public func roundCorners(
        radius: CGFloat = .zero,
        corners: UIRectCorner = .allCorners,
        borderColor: Color = .clear,
        strokeStyle: StrokeStyle
    ) -> some View {
        let roundedRect = RoundedCorner(radius: radius, corners: corners)
        return clipShape(roundedRect)
            .overlay(roundedRect.stroke(borderColor, style: strokeStyle))
    }
}

public struct RoundedCorner: Shape {
    public var radius: CGFloat = .zero
    public var corners: UIRectCorner = .allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
    
    static var topSafeArea: CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }.last
        
        return (keyWindow?.safeAreaInsets.top) ?? 0
    }
    
    static var bottomSafeArea: CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }.last
        
        return (keyWindow?.safeAreaInsets.bottom) ?? 0
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
