//
//  GameScene.swift
//  GigaJump
//
//  Created by Stanley Pan on 02/10/2016.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    var background: SKNode!
    var midground: SKNode!
    var foreground: SKNode!
    
    var hud: SKNode!
    var player: SKNode!
    var scaleFactor: CGFloat!
    var startButton = SKSpriteNode(imageNamed: "TapToStart")
    var endOfGamePosition = 0
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0.0
    var scoreLabel: SKLabelNode!
    var flowerLabel: SKLabelNode!
    
    var playersMaxYValue: Int!
    var gameOver = false
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.white
        scaleFactor = self.size.width / 320
        
        background = createBackground()
        addChild(background)
        
        midground = createMidground()
        addChild(midground)
        
        foreground = SKNode()
        addChild(foreground)
        
        player = createPlayer()
        foreground.addChild(player)
        
        let platform = createPlatformAtPosition(position: CGPoint(x: 160, y: 320), ofType: PlatformType.normalBrick)
        foreground.addChild(platform)
        
        let flower = createFlowerAtPosition(position: CGPoint(x: 160, y: 220), ofType: FlowerType.specialFlower)
        foreground.addChild(flower)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
