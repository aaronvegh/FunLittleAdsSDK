//
//  AdUnitA.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-05-28.
//

import SwiftUI

public struct AdUnitA: View {
    @ObservedObject var adController: AdUnitController
    @State var animated = false

    public var body: some View {
        if adController.adUnitInventory.adId == "0" {
            LoadingArcs(isAnimating: $animated, count: 3, width: 3, spacing: 2)
                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .onAppear() {
                    animated = true
                }
        } else {
            GeometryReader { geometry in
                HStack {
                    if let imageURL = adController.adUnitInventory.imageURL {
                        AsyncImage(url: imageURL) {
                            Image("generic-icon")
                        }
                        .aspectRatio(contentMode: .fit)
                            .frame(width: 74, height: 74, alignment: .center)
                    }
                    VStack(alignment: .leading) {
                        stringContent(adUnit: adController.adUnitInventory, colorSet: adController.adUnitInventory.colorSet, size: geometry.size)
                    }
                }
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                .frame(minWidth: 320, maxWidth: .infinity, maxHeight: 84, alignment: .center)
                .background(adController.adUnitInventory.colorSet.backgroundColor)
                .contentShape(Rectangle())
                .onTapGesture {
                    adController.adReporter.report(AdReport(adId: adController.adUnitInventory.adId, action: .interaction, timestamp: Date()))
                    guard let url = adController.adUnitInventory.linkURL else { return }
                    openURL(url)
                }
            }
        }

    }

    private func stringContent(adUnit: AdUnit, colorSet: ColorSet, size: CGSize) -> some View {
        let textSize: CGFloat = size.width > 320 ? 16 : 14
        let string = Text(adUnit.title)
            .foregroundColor(colorSet.textColor)
            .font(.custom("Helvetica-Bold", size: textSize))
            + Text(" - ").foregroundColor(colorSet.textColor)
                .font(.custom("Helvetica", size: textSize))
            + Text(adUnit.descriptionText)
                .foregroundColor(colorSet.textColor)
                .font(.custom("Helvetica", size: textSize))

        return string.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
    }

    private func openURL(_ url: URL) {
        #if os(macOS)
        NSWorkspace.shared.open(url)
        #elseif os(iOS)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        #endif
    }
}

struct AdUnitA_Previews: PreviewProvider {
    static var previews: some View {
        AdUnitA(adController: AdUnitController(adId: "8c9a5649-64d8-40fa-8c38-8231e759502a"))
            .frame(width: 320, height: 84)
    }
}
