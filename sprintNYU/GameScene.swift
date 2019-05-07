//
//  GameScene.swift
//  sprintNYU
//
//  Created by Anisa Matthews on 4/18/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import SpriteKit
//import GameplayKit

class GameScene: SKScene {
    
    // create player node
    let player = SKSpriteNode(imageNamed: "back0")
    
    // create background node
    let background = SKSpriteNode()
    
    //create pin node
    let pin = SKSpriteNode(imageNamed: "pin")
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let playerMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint.zero
    let playableRect: CGRect
//    let leftAnim: SKAction
//    let downAnim: SKAction
//    let rightAnim: SKAction
    let defAnim: SKAction
    var count = 0

    var lastTouchLocation: CGPoint?
    let playerRotateRadiansPerSec:CGFloat = 4.0 * .pi
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0 // 1
        let playableHeight = size.width / maxAspectRatio // 2
        let playableMargin = (size.height-playableHeight)/2.0 // 3
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight) // 4
        
        var textures:[SKTexture] = []
        for i in 0...3 {
            textures.append(SKTexture(imageNamed: "back\(i)"))
        }
        defAnim = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
        
        super.init(size: size) // 5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        /* Setup scene here */
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = SKColor.white //turn into maze
        
        // set up player
        player.position = CGPoint(x: 0, y: -300)
        player.setScale(0.20)
      
        // set up background & pin
        createBackground()
        createPin()
        
        // add player to SKView
        self.addChild(player)
        startPlayerAnimation()
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func sceneTouched(_ touchLocation:CGPoint) {
        
        lastTouchLocation = touchLocation
        
        moveToward(touchLocation)
    }
    
    func moveToward(_ location: CGPoint) {
        startPlayerAnimation()
        let offset = CGPoint(x: location.x - player.position.x,
                             y: location.y - player.position.y)
        let length = sqrt(
            Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length),
                                y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * playerMovePointsPerSec,
                           y: direction.y * playerMovePointsPerSec)
        
        // keep player moving forward
        startPlayerAnimation()
        
    }
    
    func startPlayerAnimation() {
        if player.action(forKey: "animation") == nil {
            player.run(
                SKAction.repeatForever(defAnim),
                withKey: "animation")
        }
    }
    
    func stopPlayerAnimation() {
        player.removeAction(forKey: "animation")
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        if let lastTouch = lastTouchLocation {
            let diff = lastTouch - player.position
            if (diff.length() <= playerMovePointsPerSec * CGFloat(dt)) {
                player.position = lastTouchLocation!
                velocity = CGPoint.zero
            } else {
                moveSprite(player, velocity: velocity)
            }
        }
        
        moveBackground()
        count += 1
        
        // 1 minute of gameplay
        if count > 1000 {
            // finish game
            // make the pin show up/move toward the player
            movePin()
            
            // determine collision of user and pin
            
            // stop background scrolling
            
            // stop pin scrolling
            
            // stop player animation
            
            // show endgame card
            
        }
        
        
    }
    
    func moveSprite(_ sprite: SKSpriteNode, velocity: CGPoint) {
        // 1
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                   y: velocity.y * CGFloat(dt))
        print("Amount to move: \(amountToMove)")
        
        sprite.position = CGPoint(
           x: sprite.position.x + amountToMove.x,
           y: sprite.position.y + amountToMove.y)
    }
    
    func createBackground() {
        for i in 0...3 {
            
            let bkg = SKSpriteNode(imageNamed: "newer_bg")
            bkg.name = "background"
            bkg.size = CGSize(width: (3.25*(self.scene?.size.width)!), height: 2600)
            bkg.zPosition = -1000
            bkg.anchorPoint = CGPoint(x: 0.25, y: 1)
            bkg.position = CGPoint(x: -(1.75*self.frame.size.width), y: CGFloat(i) * bkg.size.height)

            self.addChild(bkg)
        
        }
    }
    
    func moveBackground() {
        
        self.enumerateChildNodes(withName: "background", using: ({
            (node, error) in
            node.position.y -= 2
            if node.position.y < -(self.scene?.size.height)! {
                node.position.y += (self.scene?.size.height)! * 3
            }
        }))
        
    }
    
    func createPin() {
        
            let pin = SKSpriteNode(imageNamed: "pin")
            pin.name = "pin"
            pin.position = CGPoint(x: 150, y: 400)
            pin.setScale(0.60)
            pin.isHidden = true
        
            self.addChild(pin)
    
    }
    
    func movePin() {
        
        self.enumerateChildNodes(withName: "pin", using: ({
            
            (node, error) in
            
            node.isHidden = false
            
            node.position.y -= 2
            
            if node.position.y < -(self.scene?.size.height)! {
                node.position.y += (self.scene?.size.height)! * 3
            }
        }))
        
    }
        
}
