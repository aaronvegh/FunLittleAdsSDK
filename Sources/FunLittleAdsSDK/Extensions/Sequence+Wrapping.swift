//
//  Sequence+Wrapping.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-05-29.
//

import Foundation

extension Array {
    subscript (wrapping index: Int) -> Element {
        return self[(index % self.count + self.count) % self.count]
    }
}
