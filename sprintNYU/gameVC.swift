//
//  GameViewController.swift
//  sprintNYU
//
//  Created by Anisa Matthews on 4/18/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class gameVC: UIViewController {
    
    var level = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        scene.viewController = self // allow game scene to be able to access this
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)

    }
    
    func showWinAlert() {
        if level == 3 {
            let alert = UIAlertController(title: "You Won!", message: "You've made it to class on the entire semester!", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Main Menu",
                                          style: UIAlertAction.Style.default,
                                          handler: {
                                            (_: UIAlertAction!) in
                                            // exit to the main menu
                                            self .dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "You Won!", message: "You've made it to your class!", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Play Next Level",
                                          style: UIAlertAction.Style.default,
                                          handler: {
                                            _ in
                                            // play the next level
                                            self.level+=1
                                            self.viewDidLoad()
            }))
            
            alert.addAction(UIAlertAction(title: "Main Menu",
                                          style: UIAlertAction.Style.default,
                                          handler: {
                                            (_: UIAlertAction!) in
                                            // exit to the main menu
                                            self .dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    func showLoseAlert() {
        let alert = UIAlertController(title: "Yikesss 🙃", message: "You've been hit by a car.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Start Over",
                                      style: UIAlertAction.Style.default,
                                      handler: {
                                        _ in
                                        // Start Over the game
                                        self.viewDidLoad()
        }))
        alert.addAction(UIAlertAction(title: "Main Menu",
                                      style: UIAlertAction.Style.default,
                                      handler: {
                                        (_: UIAlertAction!) in
                                        // exit to the main menu
                                        self .dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
