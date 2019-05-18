//
//  ClockScene.swift
//  sprintNYU
//
//  Created by Candace Johnson on 5/17/19.
//

import Foundation
import SpriteKit

class ClockScene: SKScene {

    var clock = SKSpriteNode()
    var clockFrames: [SKTexture] = []

    override func didMove(to view: SKView) {
        backgroundColor = .white
        buildClock()
        animateClock()
    }

    func buildClock() {
        let clockAnimatedAtlas = SKTextureAtlas(named: "clock-sprite")
        var theseFrames: [SKTexture] = []

        let numImages = clockAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let clockTextureName = "clock\(i)"
            theseFrames.append(clockAnimatedAtlas.textureNamed(clockTextureName))
        }
        clockFrames = theseFrames

        let firstFrameTexture = clockFrames[0]
        clock = SKSpriteNode(texture: firstFrameTexture)
        clock.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(clock)

    }

    func animateClock() {
        clock.run(SKAction.repeatForever(
            SKAction.animate(with: clockFrames,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),
                 withKey:"movingClock")
    }


}
