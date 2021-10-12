//
//  ViewController.swift
//  Demo-AppKit
//
//  Created by Aaron Vegh on 2021-05-31.
//

import Cocoa
import FunLittleAdsSDK

class ViewController: NSViewController {
    @IBOutlet var funLittleAdView: NSView!

    var funLittleController = AdUnitController(adId: "8c9a5649-64d8-40fa-8c38-8231e759502a")

    override func viewDidLoad() {
        super.viewDidLoad()

        funLittleController.embedAdUnit(for: funLittleAdView)
    }

    @IBAction func showFLAAuditView(sender: NSButton) {
        AboutFLAController().showFLAAuditView()
    }


}

