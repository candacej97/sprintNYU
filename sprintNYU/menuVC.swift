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
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var alarmClockSprite: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = ClockScene(size: alarmClockSprite.bounds.size)
        alarmClockSprite.showsFPS = true
        alarmClockSprite.showsNodeCount = true
        alarmClockSprite.ignoresSiblingOrder = true
        alarmClockSprite.presentScene(scene)
        
    }
    
    @IBAction func onSettingsBtnPressed(_ sender: Any) {
        // show the settings view controller
    }
    
    @IBAction func onPlayBtnPressed(_ sender: Any) {
        // show the gameplay view controller
    }
    
}

