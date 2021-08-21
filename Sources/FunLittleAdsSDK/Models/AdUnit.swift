//
//  AdUnit.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-05-28.
//

import Foundation

public struct AdUnit: Decodable {
    let adId: String
    let title: String
    let descriptionText: String
    let imageURL: URL?
    let linkURL: URL?
    let colorSet: ColorSet

    enum CodingKeys: String, CodingKey {
        case adId = "id"
        case title
        case descriptionText = "description"
        case imageURL = "image"
        case linkURL = "link"
        case colorSet = "color_set"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adId = try values.decode(String.self, forKey: .adId)
        title = try values.decode(String.self, forKey: .title)
        descriptionText = try values.decode(String.self, forKey: .descriptionText)
        let imagePath = try values.decode(String.self, forKey: .imageURL)
        let linkPath = try values.decode(String.self, forKey: .linkURL)
        imageURL = URL(string: imagePath)
        linkURL = URL(string: linkPath)
        colorSet = try values.decode(ColorSet.self, forKey: .colorSet)
    }
}
