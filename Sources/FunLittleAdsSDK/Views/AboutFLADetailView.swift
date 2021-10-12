//
//  AboutFLADetailView.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-07-03.
//

import SwiftUI

struct AboutFLADetailView: View {
    var adReportRecord: AdReportRecord

    init(adReportRecord: AdReportRecord) {
        self.adReportRecord = adReportRecord
    }
    var body: some View {
        VStack {
            ForEach(adReportRecord.adReports, id: \.self) { record in
                VStack {
                    HStack {
                        Text(record.prettyDate)
                            .padding()
                        Spacer()
                    }
                    HStack {
                        Text("Ad ID")
                            .bold()
                            .frame(width: 120.0, alignment: .trailing)
                        Text(record.adId)
                        Spacer()
                    }
                    HStack {
                        Text("Action")
                            .bold()
                            .frame(width: 120.0, alignment: .trailing)
                        Text(record.action.rawValue)
                        Spacer()
                    }
                    HStack {
                        Text("Country")
                            .bold()
                            .frame(width: 120.0, alignment: .trailing)
                        Text(record.country ?? "")
                        Spacer()
                    }
                    HStack {
                        Text("Device")
                            .bold()
                            .frame(width: 120.0, alignment: .trailing)
                        Text(record.device)
                        Spacer()
                    }
                    HStack {
                        Text("OS")
                            .bold()
                            .frame(width: 120.0, alignment: .trailing)
                        Text(record.os)
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }
}

struct AboutFLADetailView_Previews: PreviewProvider {
    static var detail = AdReportRecord(dateString: "July 10, 2021", adReports: [AdReport(adId: "234", action: .impression, timestamp: Date()), AdReport(adId: "234", action: .impression, timestamp: Date()), AdReport(adId: "234", action: .impression, timestamp: Date()), AdReport(adId: "234", action: .impression, timestamp: Date()), AdReport(adId: "234", action: .impression, timestamp: Date()), AdReport(adId: "234", action: .impression, timestamp: Date())])
    static var previews: some View {
        AboutFLADetailView(adReportRecord: detail)
    }
}
