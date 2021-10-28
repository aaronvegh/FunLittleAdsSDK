//
//  View+Visible.swift
//  
//
//  Created by Aaron Vegh on 2021-10-25.
//

import Foundation

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

#if os(macOS)
extension NSView {
    var isVisibleToUser: Bool {

        if isHidden || alphaValue == 0 || superview == nil {
            return false
        }

        guard NSApplication.shared.isActive == true else { return false }

        guard let window = self.window else { return false }

        guard window.isMainWindow else { return false }

        guard let rootViewController = window.contentViewController else {
            return false
        }

        let viewFrame = convert(bounds, to: rootViewController.view)

        let topSafeArea: CGFloat
        let bottomSafeArea: CGFloat

        if #available(macOS 11.0, *) {
            topSafeArea = rootViewController.view.safeAreaInsets.top
            bottomSafeArea = rootViewController.view.safeAreaInsets.bottom
        } else {
            topSafeArea = rootViewController.view.frame.minY
            bottomSafeArea = rootViewController.view.frame.maxY
        }

        return viewFrame.minX >= 0 &&
            viewFrame.maxX <= rootViewController.view.bounds.width &&
            viewFrame.minY >= topSafeArea &&
            viewFrame.maxY <= rootViewController.view.bounds.height - bottomSafeArea
    }
}
#endif

#if os(iOS)
extension UIView {
    var isVisibleToUser: Bool {

        if isHidden || alpha == 0 || superview == nil {
            return false
        }

        guard let window = self.window else { return false }

        guard let rootViewController = window.rootViewController else {
            return false
        }

        let viewFrame = convert(bounds, to: rootViewController.view)

        let topSafeArea: CGFloat
        let bottomSafeArea: CGFloat

        if #available(iOS 11.0, *) {
            topSafeArea = rootViewController.view.safeAreaInsets.top
            bottomSafeArea = rootViewController.view.safeAreaInsets.bottom
        } else {
            topSafeArea = rootViewController.topLayoutGuide.length
            bottomSafeArea = rootViewController.bottomLayoutGuide.length
        }

        return viewFrame.minX >= 0 &&
            viewFrame.maxX <= rootViewController.view.bounds.width &&
            viewFrame.minY >= topSafeArea &&
            viewFrame.maxY <= rootViewController.view.bounds.height - bottomSafeArea
    }
}
#endif
