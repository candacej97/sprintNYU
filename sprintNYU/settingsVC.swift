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
    @IBOutlet weak var musicBtn: UIButton!
    @IBOutlet weak var soundBtn: UIButton!
    
    var mute_music = UIImage(named: "mute_music")
    var mute_sound = UIImage(named: "mute_sound")
    
    var play_music = UIImage(named: "music")
    var play_sound = UIImage(named: "sound")
    
    // STATE
    struct allSound {
        static var music = true
        static var sound = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onBackBtnPressed(_ sender: Any) {
        // exit view controller
        self .dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onMusicBtnPressed(_ sender: Any) {
        // find out if music is on or not
        if allSound.music {
            // switch image
            musicBtn.setImage(mute_music, for: .normal)
            // switch state of music
            allSound.music = false
        }
        else {
            musicBtn.setImage(play_music, for: .normal)
        }
    }
    
    @IBAction func onSoundBtnPressed(_ sender: Any) {
        // find out if sound is on or not
        if allSound.sound {
            // switch image
            soundBtn.setImage(mute_sound, for: .normal)
            // switch state of sound
            allSound.sound = false
        }
        else {
            soundBtn.setImage(play_sound, for: .normal)
        }
    }
}
