//
//  settingsVC.swift
//  sprintNYU
//
//  Created by Candace Johnson on 4/24/19.
//

import UIKit
import SpriteKit

class settingsVC: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBackBtnPressed(_ sender: Any) {
        // exit view controller
        self .dismiss(animated: true, completion: nil)
    }
}
