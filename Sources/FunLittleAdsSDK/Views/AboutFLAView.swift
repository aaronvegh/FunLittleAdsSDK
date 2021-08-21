//
//  AboutFLAView.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-06-28.
//

import SwiftUI

public struct AboutFLAView: View {
    @ObservedObject var viewModel:  AuditLogViewModel
    @Environment(\.presentationMode) var presentationMode
    var dismissAction: (() -> Void)?
    var bundle: Bundle?

    public init(isPresented: Bool = false) {
        self.viewModel = AuditLogViewModel()
        self.bundle = Bundle(identifier: "com.innoveghtive.FunLittleAds")
    }

    @ViewBuilder
    var main: some View {
        ScrollView {
            VStack {
                #if os(iOS)
                HStack {
                    Spacer()
                    Button("Dismiss") {
                        self.dismissAction?()
                        presentationMode.wrappedValue.dismiss()
                    }.padding()
                }
                #endif
                Image("FLA-Logo", bundle: bundle)
                    .renderingMode(.original)
                    .padding()
                HStack {
                Text("Hey, thanks for reading. FunLittleAds is a privacy-first ad network meant to serve the needs of small developers and small advertisers alike. It's a way to both support great apps like this one, and give you a chance to learn about apps from other developers! Win win!")
                    Spacer()
                }
                .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))

                HStack {
                    Text("Privacy first? But I thought all ad network were scammy privacy vampires?")
                        .bold()
                    Spacer()
                }
                .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))

                HStack {
                    Text("That's what makes this different. We don't collect personally identifiable information. We don't care about that stuff. We only want to make a fun little ad network.")
                    Spacer()
                }
                .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))

                HStack {
                    Text("Prove it!")
                        .bold()
                    Spacer()
                }
                .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))

                HStack {
                    Text("Okay! Here's an audit of all the data that is sent to our server. This local log is kept for one day, then deleted.")
                    Spacer()
                }
                .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }


            ForEach(viewModel.logModels, id: \.self) { model in
                AboutFLADetailView(adReportRecord: model)
            }

            HStack {
                Button("FunLittleAds.com") {
                    #if os(iOS)
                    UIApplication.shared.open(URL(string: "https://funlittleads.com")!)
                    #elseif os(macOS)
                    NSWorkspace.shared.open(URL(string: "https://funlittleads.com")!)
                    #endif
                }.padding()
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
        }
        .background(Color.white)
    }

    public var body: some View {
        #if os(macOS)
        main
            .background(Color.white)
            .frame(minWidth: 300, minHeight: 450)
        #elseif os(iOS)
        main
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        #endif

    }
}

struct AboutFLAView_Previews: PreviewProvider {
    static var previews: some View {
        AboutFLAView()
    }
}
