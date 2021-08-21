//
//  ViewController.swift
//  Demo-iOS
//
//  Created by Aaron Vegh on 2021-05-28.
//

import UIKit
import FunLittleAds

class ViewController: UIViewController {

    @IBOutlet weak var funLittleAdView: UIView!

    var funLittleController = AdUnitController(adId: "8c9a5649-64d8-40fa-8c38-8231e759502a")

    override func viewDidLoad() {
        super.viewDidLoad()

        funLittleController.embedAdUnit(for: funLittleAdView)
    }

    @IBAction func showFLAAuditView(sender: UIButton) {
        AboutFLAController().showFLAAuditView(from: self)
    }
}
