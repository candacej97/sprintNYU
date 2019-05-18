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
    
    // connect game view controller to the game scene
    var viewController: gameVC!
    
    // create player node
    let player = SKSpriteNode(imageNamed: "back0")
    
    // create background node
    let background = SKSpriteNode()
    
    //create pin node
    let pin = SKSpriteNode(imageNamed: "pin")
    
    //create car node
    let car = SKSpriteNode(imageNamed: "car")
    
    //create car node
    let drink = SKSpriteNode(imageNamed: "drink")
    
    // bring in all sound
    let level_success: SKAction = SKAction.playSoundFileNamed("level_success.mp3", waitForCompletion: true)
    let level_fail: SKAction = SKAction.playSoundFileNamed("level_fail.mp3", waitForCompletion: true)
    let level_boost: SKAction = SKAction.playSoundFileNamed("level_boost.mp3", waitForCompletion: true)
    let level_boostMusic: SKAction = SKAction.playSoundFileNamed("level_boostMusic.mp3", waitForCompletion: true)
    
    // set verifiers for playing sound and music
    var playSound = true
    var playMusic = true
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let playerMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint.zero
    let playableRect: CGRect
//    let leftAnim: SKAction
//    let downAnim: SKAction
//    let rightAnim: SKAction
    let defAnim: SKAction
    var cycles = 0
    var maxCycles = 1000
    var gameEnded = false
    var playerSpeed = 1
    var boostEnd = 0

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
        
        self.enumerateChildNodes(withName: "car", using: ({
            
            (node, error) in
            
            // change cycle length depending on the level
            if self.maxCycles != (1000 % self.viewController.getLevel()){
                self.maxCycles %= self.viewController.getLevel()
            }
            
            self.playMusic = settingsVC.allSound.music
            self.playSound = settingsVC.allSound.sound
            
        }))
        
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
        createBoostUp()
        
        // add player to SKView
        self.addChild(player)
        startPlayerAnimation()
        
        // if the game hasn't ended keep running the car obstacle, and randomize it between 5 and 20 seconds
        if !gameEnded {
            run(SKAction.repeatForever( SKAction.sequence([SKAction.run(driveCars), SKAction.wait(forDuration: Double.random(in: 5.0 ..< 10.0))])))
        }
        
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
            player.run(SKAction.repeatForever(defAnim), withKey: "animation")
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
        
        // if the game hasn't ended keep moving the background
        if !gameEnded {
            moveBackground()
            cycles += 1
            
            run(SKAction.repeatForever( SKAction.sequence([SKAction.run(moveBoostUp), SKAction.wait(forDuration: Double.random(in: 10.0 ..< 20.0))])))
            
            if boostEnd != 0 && playMusic {
                run(level_boostMusic, withKey: "boosting")
            }
            
            if cycles == boostEnd {
                self.removeAction(forKey: "boosting")
                print("\(cycles) cycles")
                playerSpeed = 1
                boostEnd = 0
            }
        }

        
        // after maxCycles has become equal to the number of cycles of gameplay (without being hit by a car) we show the pin of the destination, this timing will vary based on other factors: obstacles, boostups, level
        if cycles >= maxCycles && !gameEnded {
            // finish game
            // make the pin show up & move toward the player
            movePin()
            
        }
        
        // determine collision of user and pin
        checkCollisions()
        
    }
    
    func moveSprite(_ sprite: SKSpriteNode, velocity: CGPoint) {
        // 1
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                   y: velocity.y * CGFloat(dt))
        
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
            node.position.y -= (2 * CGFloat(self.playerSpeed))
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
            node.position.y -= (2 * CGFloat(self.playerSpeed))
            if node.position.y < -(self.scene?.size.height)! {
                node.position.y += (self.scene?.size.height)! * 3
            }
        }))
        
    }
    
    func driveCars() {
        
        let car = SKSpriteNode(imageNamed: "car")
        car.name = "car"
        car.position = CGPoint(
            x: CGFloat.random(min: -80, max: 100),
            y: (size.height + car.size.height/2)*2)
        car.setScale(0.5)
        car.zPosition = 15
        
        addChild(car)
        
        let gothere = CGPoint(
            x: car.position.x,
            y: -(car.size.height*4))
        let actionMove = SKAction.move(to: gothere, duration: 3.0)
        let actionRemove = SKAction.removeFromParent()
        car.run(SKAction.sequence([actionMove, actionRemove]))
        
    }
    
    func createBoostUp() {
        
        let drink = SKSpriteNode(imageNamed: "drink")
        drink.name = "drink"
        drink.position = CGPoint(x: CGFloat.random(min: self.frame.minX, max: self.frame.maxX), y: 400)
        drink.setScale(0.60)
        drink.isHidden = true
        
        self.addChild(drink)
        
    }
    
    func moveBoostUp() {
        self.enumerateChildNodes(withName: "drink", using: ({
            (node, error) in
            node.isHidden = false
            node.position.y -= (2 * CGFloat(self.playerSpeed))
            if node.position.y < -(self.scene?.size.height)! {
                node.position.y += (self.scene?.size.height)! * 3
            }
        }))
    }
    
    
    func checkCollisions() {
        
        self.enumerateChildNodes(withName: "drink", using: ({
            
            (node, error) in
            let drink = node as! SKSpriteNode
            if drink.intersects(self.player) {
                self.playerSpeed = self.viewController.getLevel() * 2
                self.boostEnd = Int.random(in: self.cycles ..< self.maxCycles-100)
                print("Boosted! x\(self.playerSpeed)")
                print("Boost end @ \(self.boostEnd) cycles")
                
                if self.playSound {
                    self.run(self.level_boost)
                }
            }
            
        }))
        
        self.enumerateChildNodes(withName: "pin", using: ({
            
            (node, error) in
            let pin = node as! SKSpriteNode
            if pin.intersects(self.player){
                self.gameEnded = true
                self.drink.removeAllActions()
                self.stopPlayerAnimation()
                
                if self.playSound {
                    self.run(self.level_success)
                }
                
                if self.viewController.getLevel() == 3 {
                    self.viewController.showGameWinningAlert()
                } else {
                    self.viewController.showWinAlert()
                }
            }
            
        }))
        
        self.enumerateChildNodes(withName: "car", using: ({
            
            (node, error) in
            let car = node as! SKSpriteNode
            if car.intersects(self.player){
                self.gameEnded = true
                self.drink.removeAllActions()
                self.stopPlayerAnimation()
                
                if self.playSound {
                    self.run(self.level_fail)
                }
                
                self.viewController.showLoseAlert()
            }
            
        }))
    }
    
}
