//
//  menuVC.swift
//  sprintNYU
//
//  Created by Candace Johnson on 4/22/19.
//

import UIKit
import SpriteKit

class menuVC: UIViewController {

    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var cashIconImg: UIImageView!
    @IBOutlet weak var alarmClockSprite: SKView!
    
    // create player node
//    self.alarmClockSprite = SKSpriteNode(imageNamed: "clock-red_1")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        // create sprite for the alarm clock
        
    }

    @IBAction func onSettingsBtnPressed(_ sender: Any) {
        // show the settings view controller
    }
    
    @IBAction func onStoreBtnPressed(_ sender: Any) {
        // show the store view controller
    }
    
    @IBAction func onPlayBtnPressed(_ sender: Any) {
        // show the gameplay view controller
    }
    
}

