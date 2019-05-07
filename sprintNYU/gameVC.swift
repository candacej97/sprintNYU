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

        
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
    }
    
    func showWinAlert() {
        let alert = UIAlertController(title: "You Won!", message: "You've made it to your class!", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Play Next Level", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Main Menu",
                                      style: UIAlertAction.Style.default,
                                      handler: {
                                        (_: UIAlertAction!) in
                                        
                                        self .dismiss(animated: true, completion: nil)

                                        //Sign out action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoseAlert() {
        let alert = UIAlertController(title: "Yikesss 🙃", message: "You've been hit by a car.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Start Over", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Main Menu",
                                      style: UIAlertAction.Style.default,
                                      handler: {
                                        (_: UIAlertAction!) in
                                        
                                        self .dismiss(animated: true, completion: nil)
                                        
                                        //Sign out action
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
