//
//  ContentView.swift
//  Shared
//
//  Created by Aaron Vegh on 2021-05-31.
//

import SwiftUI
import FunLittleAdsSDK

struct ContentView: View {
    @State var presentingFLASheet = false

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    ForEach((1...10), id: \.self) { n in
                        Text("Item #\(n)")
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(Color.green)
                    }
                }

                AdContainerView(adController: AdUnitController(adId: "8c9a5649-64d8-40fa-8c38-8231e759502a")).frame(height: 85)

                #if os(macOS)
                AboutFLAViewButton().padding()
                #elseif os(iOS)
                Button("About FunLittleAds") {
                    presentingFLASheet = true
                }
                #endif
            }.sheet(isPresented: $presentingFLASheet) {
                AboutFLAView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
