//
//  AdReporter.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-05-31.
//

import Foundation
#if os(iOS)
import UIKit
#endif
#if os(macOS)
import IOKit
#endif

enum AdReportAction: String, Codable {
    case impression = "impression"
    case interaction = "interaction"
}

class AdReporterData {
    var country: String = "Undetermined"
    var device: String = "Undetermined"
    var os: String = "Undetermined"

    init() {
        device = deviceName()
        os = osNameVersion()
        country = getLocation()
    }
}

extension AdReporterData {

    func getLocation() -> String {
        return NSLocale.current.regionCode ?? "Undetermined"
    }

    func osNameVersion() -> String {
        #if os(iOS)
        return "iOS \(ProcessInfo.processInfo.operatingSystemVersionString)"
        #endif

        #if os(macOS)
        return "macOS \(ProcessInfo.processInfo.operatingSystemVersionString)"
        #endif
    }

    func deviceName() -> String {
        #if os(iOS)
        return iOSMachineName()
        #elseif os(macOS)
        return macOSMachineName()
        #endif
    }

    #if os(iOS)
    func iOSMachineName() -> String {
      var systemInfo = utsname()
      uname(&systemInfo)
      let machineMirror = Mirror(reflecting: systemInfo.machine)
      return machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
      }
    }
    #endif

    #if os(macOS)
    func macOSMachineName() -> String {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault,
            IOServiceMatching("IOPlatformExpertDevice"))
        var modelIdentifier: String?
        if let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data {
            modelIdentifier = String(data: modelData, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters)
        }

        IOObjectRelease(service)
        return modelIdentifier ?? "Undetermined"
    }
    #endif
}

struct AdReport: Codable {
    let adId: String
    let action: AdReportAction
    let country: String?
    let device: String
    let os: String
    let timestamp: Double

    enum CodingKeys: String, CodingKey {
        case adId = "ad_id"
        case action = "event_type"
        case country = "location"
        case device = "device_type"
        case os = "operating_system"
        case timestamp = "event_timestamp"
    }

    init(adId: String, action: AdReportAction,  timestamp: Date) {
        let reportData = AdReporterData()
        self.adId = adId
        self.action = action
        self.timestamp = timestamp.timeIntervalSince1970
        self.country = reportData.country
        self.os = reportData.os
        self.device = reportData.device
    }

    var prettyDate: String {
        let timestampDate = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: timestampDate)
    }
}

extension AdReport: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(adId)
    }
}

class AdReporter {
    var adReports = [AdReport]()

    var timer: Timer?

    let endpoint: URL
    let accessKey: String
    public let session: URLSession

    init(accessKey: String) {
        self.endpoint = URL(string: "https://funlittleads.com")!
        self.accessKey = accessKey
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { [weak self] _ in
            self?.sendReports()
        })
    }

    deinit {
        timer?.invalidate()
    }

    @objc private func sendReports() {
        // send report to server
        guard let payload = try? JSONEncoder().encode(adReports) else { return }
        var request = URLRequest(url: endpoint.appendingPathComponent("/api/v1/report"))
        request.addValue(accessKey, forHTTPHeaderField: "X-FLA-Token")
        request.httpMethod = "POST"
        request.httpBody = payload
        let task = session.dataTask(with: request) { (responseData, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 204 {
                    self.archive(self.adReports)
                    self.adReports.removeAll()
                }
            }
        }
        task.resume()
    }

    func report(_ report: AdReport) {
        adReports.append(report)
    }
}

extension AdReporter {
    private func archive(_ adReports: [AdReport]) {
        guard let appSupport = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return }
        var isDir: ObjCBool = false
        let destinationPath = appSupport.appendingPathComponent("com.funlittleads")
        if !FileManager.default.fileExists(atPath: destinationPath.path, isDirectory: &isDir) {
            try? FileManager.default.createDirectory(atPath: appSupport.appendingPathComponent("com.funlittleads").path, withIntermediateDirectories: true, attributes: nil)
        }

        do {
            let thisFileName = "\(Date().timeIntervalSince1970).json"
            let data = try JSONEncoder().encode(adReports)
            try data.write(to: destinationPath.appendingPathComponent(thisFileName))
        } catch(let error) {
            print("Error writing audit: \(error.localizedDescription)")
            return
        }

        clearOldLogs(from: destinationPath)

    }

    // Remove logs that are older than one day
    private func clearOldLogs(from directory: URL) {
        guard let directoryContents = try? FileManager.default.contentsOfDirectory(atPath: directory.path),
              let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()),
              let cutOffDate = Calendar.current.date(byAdding: .day, value: -1, to: noon) else { return }

        for file in directoryContents {
            let dateString = file.replacingOccurrences(of: ".json", with: "")
            if let dateInterval = TimeInterval(dateString) {
                let fileDate = Date(timeIntervalSince1970: dateInterval)
                if fileDate < cutOffDate {
                    let deletePath = directory.appendingPathComponent(file)
                    try? FileManager.default.removeItem(at: deletePath)
                }
            }
        }
    }
}
