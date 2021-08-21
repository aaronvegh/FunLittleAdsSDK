//
//  AboutFLAController.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-06-28.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#endif
#if os(macOS)
import AppKit
#endif

public class AboutFLAController: ObservableObject {

    public init() {
        
    }
}

#if os(iOS)
extension AboutFLAController {
    public func showFLAAuditView(from viewController: UIViewController) {
        let hostingVC = UIHostingController(rootView: AboutFLAView())
        var aboutFLAView = AboutFLAView()
        aboutFLAView.dismissAction = {
            hostingVC.dismiss(animated: true, completion: nil)
        }
        hostingVC.rootView = aboutFLAView
        hostingVC.modalPresentationStyle = .automatic
        viewController.present(hostingVC, animated: true)
    }
}
#endif

#if os(macOS)
extension AboutFLAController {
    public func showFLAAuditView() {
        let hostingVC = NSHostingController(rootView: AboutFLAView())
        let window = NSWindow(contentViewController: hostingVC)
        window.title = "About FunLittleAds"
        window.setFrame(NSRect(origin: window.frame.origin, size: NSSize(width: 380, height: 400)), display: true)
        window.makeKeyAndOrderFront(nil)
    }
}

public final class AboutFLAViewButton: NSViewRepresentable {
    public init() {}
    
    public func updateNSView(_ nsView: NSViewType, context: Context) {

    }

    public func makeNSView(context: Context) -> NSButton {
        let button = NSButton(title: "About FunLittleAds", target: self, action: #selector(openAboutFLA(sender:)))
        return button
    }

    @objc public func openAboutFLA(sender: NSButton) {
        AboutFLAController().showFLAAuditView()
    }
}
#endif
