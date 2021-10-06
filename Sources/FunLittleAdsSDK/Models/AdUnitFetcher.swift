//
//  AdUnitFetcher.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-05-28.
//

import Foundation

enum AdFetchError: Error {
    case serverError
}

struct AdUnitFetcher {

    let endpoint: URL
    let accessKey: String
    public let session: URLSession

    public init(accessKey: String) {
        self.endpoint = URL(string: "https://funlittleads.com")!
        self.accessKey = accessKey
        self.session = URLSession(configuration: URLSessionConfiguration.default)

    }

    func fetchAds(completion: @escaping ((Result<AdUnit, AdFetchError>) -> Void)) {
        var request = URLRequest(url: endpoint.appendingPathComponent("/api/v1/fetch"))
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue(accessKey, forHTTPHeaderField: "X-FLA-Token")
        #if os(iOS)
            let platform = "iOS"
        #elseif os(macOS)
            let platform = "macOS"
        #endif
        request.addValue(platform, forHTTPHeaderField: "X-FLA-Platform")
        #if IS_RELEASE
        request.addValue(true, forHTTPHeaderField: "X-FLA-RELEASE")
        #endif
        let task = session.dataTask(with: request, completionHandler: { (responseData, response, error) in
            DispatchQueue.main.async {
                guard let data = responseData,
                      let decoded = try? JSONDecoder().decode(AdUnit.self, from: data) else { completion(.failure(.serverError)); return }
                
                return completion(.success(decoded))
            }
        })
        task.resume()
    }

}
