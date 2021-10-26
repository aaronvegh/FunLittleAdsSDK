//
//  AdUnitController.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-05-29.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#endif
#if !os(iOS)
import AppKit
#endif

import Combine

public class AdUnitController: ObservableObject {
    // This identifies the app publisher to FLA
    public let advertiserId: String

    // Fetch 'n' Report:
    let adUnitFetcher: AdUnitFetcher
    let adReporter: AdReporter

    // Placeholder ad unit for initial load. Has an id of 0
    // to trigger the loading animation
    @Published var adUnitInventory = try! AdUnit(from: ["id": "0", "title": "", "description": "", "image": "", "link": "", "color_set": ["textColor": "", "backgroundColor": "", "accentColor": ""]])
    var adInventoryTimer: Timer?

    private var cancellables = Set<AnyCancellable>()

    #if os(iOS)
    lazy var hostingController = {
        UIHostingController<AdUnitA>(rootView: AdUnitA(adController: self))
    }()
    var superviews = [UIView]()
    var isViewVisible: Bool {
        return hostingController.view.isVisibleToUser
    }
    #endif

    #if os(macOS)
    lazy var hostingController = {
        NSHostingController<AdUnitA>(rootView: AdUnitA(adController: self))
    }()
    var superviews = [NSView]()
    var isViewVisible: Bool {
        return hostingController.view.isVisibleToUser
    }
    #endif

    // Initialize the fetcher and reporter
    // Kick off the timer to fetch ads
    // Setup observer to handle changes to ad inventory
    public init(adId: String) {
        self.advertiserId = adId
        self.adUnitFetcher = AdUnitFetcher(accessKey: adId)
        self.adReporter = AdReporter(accessKey: adId)
        updateAdInventory()

        self.$adUnitInventory
            .filter { adInventory in
                adInventory.adId != "0"
            }
            .sink { adInventory in
                #if os(macOS)
                if self.isViewVisible {
                    self.adReporter.report(AdReport(adId: adInventory.adId, action: .impression, timestamp: Date()))
                }
                #elseif os(iOS)
                if self.isViewVisible {
                    self.adReporter.report(AdReport(adId: adInventory.adId, action: .impression, timestamp: Date()))
                }
                #endif
            }
            .store(in: &cancellables)

        adInventoryTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { [weak self] _ in
            self?.updateAdInventory()
        })
    }

    deinit {
        adInventoryTimer?.invalidate()
    }

    // Run on a timer, replaces the local inventory with
    // fresh data from the server as needed
    private func updateAdInventory() {
        adUnitFetcher.fetchAds() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let adUnit):
                self.adUnitInventory = adUnit
                #if os(iOS)
                self.refreshAdViews()
                #endif
                #if !os(iOS)
                self.refreshNSAdViews()
                #endif
            case .failure(let error):
                print("FLA Error: \(error)")
            }
        }
    }
}

// UIKit Extension
#if os(iOS)
extension AdUnitController {

    public func embedAdUnit(for uiKitView: UIView) {
        superviews.append(uiKitView)
        uiKitView.addSubview(hostingController.view, layoutMode: .fill)
    }

    private func refreshAdViews() {
        for view in superviews {
            guard let goingAwayView = view.subviews.first else { return }
            let newSwiftUIView = AdUnitA(adController: self)
            hostingController = UIHostingController<AdUnitA>(rootView: newSwiftUIView)
            view.addSubview(hostingController.view, layoutMode: .fill)
            hostingController.view.alpha = 0
            UIView.transition(with: hostingController.view, duration: 0.5, options: .transitionCrossDissolve) {
                goingAwayView.alpha = 0
                self.hostingController.view.alpha = 1
            } completion: { _ in
                goingAwayView.removeFromSuperview()
            }
        }
    }
}
#endif

#if os(macOS)
// AppKit Extension
extension AdUnitController {
    public func embedAdUnit(for appKitView: NSView) {
        superviews.append(appKitView)
        appKitView.addSubview(hostingController.view, layoutMode: .fill)
    }

    private func refreshNSAdViews() {
        for view in superviews {
            guard let goingAwayView = view.subviews.first else { return }
            let newSwiftUIView = AdUnitA(adController: self)
            self.hostingController = NSHostingController<AdUnitA>(rootView: newSwiftUIView)
            view.addSubview(hostingController.view, layoutMode: .fill)
            hostingController.view.alphaValue = 0

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.5
                context.allowsImplicitAnimation = true

                goingAwayView.alphaValue = 0
                hostingController.view.alphaValue = 1
            }, completionHandler: {
                goingAwayView.removeFromSuperview()
            })
        }
    }
}
#endif
