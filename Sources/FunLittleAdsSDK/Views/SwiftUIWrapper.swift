//
//  SwiftUIWrapper.swift
//  
//
//  Created by Aaron Vegh on 2021-10-25.
//

import Foundation
import SwiftUI
import Combine

// SwiftUI App implementation views
public struct AdContainerView: View {
    public var adController: AdUnitController

    public init(adController: AdUnitController) {
        self.adController = adController
    }

    public var body: some View {
        SwiftUIRepresentable(adController: adController)
    }
}

#if os(macOS)
public final class SwiftUIRepresentable: NSViewRepresentable {
    var adController: AdUnitController

    init(adController: AdUnitController) {
        self.adController = adController
    }

    public func makeNSView(context: Context) -> some NSView {
        let view = NSView()
        adController.embedAdUnit(for: view)
        return view
    }

    public func updateNSView(_ nsView: NSViewType, context: Context) {

    }
}
#elseif os(iOS)
public struct SwiftUIRepresentable: UIViewRepresentable {
    var adController: AdUnitController

    init(adController: AdUnitController) {
        self.adController = adController
    }

    public func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        adController.embedAdUnit(for: view)
        return view
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}
#endif

public struct AdView: View {
    @EnvironmentObject var adController: AdUnitController

    public var body: some View {
        AdUnitA(adController: adController)
            .animation(.default)
    }
}
