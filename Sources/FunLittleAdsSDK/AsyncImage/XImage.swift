//
//  File.swift
//  
//
//  Created by Aaron Vegh on 2021-08-22.
//

#if os(iOS)
import UIKit

class XImage: UIImage { }

#elseif os(macOS)
import Cocoa

class XImage: NSImage { }
#endif


