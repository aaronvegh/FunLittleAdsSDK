//
//  NSLayoutConstraintArray+Activate.swift
//  Brooklyn
//
//  Created by Zef Houssney on 4/4/17.
//  Copyright © 2017 Disney. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

#if !os(iOS)
import AppKit
#endif

// 🎉 Thank you Swift 3.1! 🎉
extension Array where Element == NSLayoutConstraint {
    public func activate() {
        NSLayoutConstraint.activate(self)
    }
    public func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
    public func setActive(_ isActive: Bool) {
        if isActive {
            NSLayoutConstraint.activate(self)
        } else {
            NSLayoutConstraint.deactivate(self)
        }
    }
}

