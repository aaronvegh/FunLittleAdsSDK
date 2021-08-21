//
//  ColorSet.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-05-29.
//

import Foundation
import SwiftUI

struct ColorSet: Decodable {
    let textColor: Color
    let backgroundColor: Color
    let accentColor: Color

    enum CodingKeys: String, CodingKey {
        case textColor
        case backgroundColor
        case accentColor
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let textColorString = try container.decode(String.self, forKey: .textColor)
        textColor = Color(hex: textColorString)
        let backgroundColorString = try container.decode(String.self, forKey: .backgroundColor)
        backgroundColor = Color(hex: backgroundColorString)
        let accentString = try container.decode(String.self, forKey: .accentColor)
        accentColor = Color(hex: accentString)
    }
}
