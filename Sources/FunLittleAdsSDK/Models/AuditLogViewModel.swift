//
//  AuditLogViewModel.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-06-28.
//

import Foundation

struct AdReportRecord: Hashable {
    let dateString: String
    let adReports: [AdReport]

    func hash(into hasher: inout Hasher) {
        hasher.combine(dateString)
    }

    static func == (lhs: AdReportRecord, rhs: AdReportRecord) -> Bool {
        return lhs.dateString == rhs.dateString
    }
}

class AuditLogViewModel: ObservableObject {

    var logModels: [AdReportRecord] {
        var models = [AdReportRecord]()
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .medium
            return df
        }()

        guard let appSupport = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return models }
        let destinationPath = appSupport.appendingPathComponent("com.funlittleads")
        guard let directoryContents = try? FileManager.default.contentsOfDirectory(at: destinationPath, includingPropertiesForKeys: [.creationDateKey]) else { return models }
        let sortedContents = directoryContents.map { url in
            (url, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
        }
        .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
        .map { $0.0 } // extract file names
        for file in sortedContents {
            let dateString = file.lastPathComponent.replacingOccurrences(of: ".json", with: "")
            if let dateInterval = TimeInterval(dateString) {
                let fileDate = Date(timeIntervalSince1970: dateInterval)
                let readableString = dateFormatter.string(from: fileDate)
                do {
                    let adReports = try JSONDecoder().decode([AdReport].self, from: Data(contentsOf: file))
                    let reportRecord = AdReportRecord(dateString: readableString, adReports: adReports)
                    models.append(reportRecord)
                } catch (let error) {
                    print("Error decoding: \(error)")
                    continue
                }
            }
        }
        return models
    }

}
