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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    
    var currentMaxY: Int!
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.white
        let levelData = GameHandler.sharedInstance.levelData!
        currentMaxY = 80
        GameHandler.sharedInstance.score = 0
        gameOver = false
        endOfGamePosition = levelData["EndOfLevel"] as! Int
        
        scaleFactor = self.size.width / 320
        
        background = createBackground()
        addChild(background)
        
        midground = createMidground()
        addChild(midground)
        
        foreground = SKNode()
        addChild(foreground)
        
        hud = SKNode()
        addChild(hud)
        startButton.position = CGPoint(x: self.size.width / 2, y: 180)
        hud.addChild(startButton)
        
        let flower = SKSpriteNode(imageNamed: "flower")
        flower.position = CGPoint(x: 25, y: self.size.height - 30)
        hud.addChild(flower)
        
        flowerLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        flowerLabel.fontSize = 30
        flowerLabel.fontColor = SKColor.white
        flowerLabel.position = CGPoint(x: 50, y: self.size.height - 40)
        flowerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        flowerLabel.text = "  \(GameHandler.sharedInstance.flowers)"
        hud.addChild(flowerLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width - 20, y: self.size.height - 40)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        scoreLabel.text = "0"
        hud.addChild(scoreLabel)
        
        player = createPlayer()
        foreground.addChild(player)
        
        let platforms = levelData["Platforms"] as! NSDictionary
        let platformPatterns = platforms["Patterns"] as! NSDictionary
        let platformPositions = platforms["Positions"] as! [NSDictionary]
        
        for platformPosition in platformPositions {
            let x = platformPosition["x"] as! Float
            let y = platformPosition["y"] as! Float
            let pattern = platformPosition["pattern"] as! NSString
            
            let platformPattern = platformPatterns[pattern] as! [NSDictionary]
            for platformPoint in platformPattern {
                let xValue = platformPoint["x"] as! Float
                let yValue = platformPoint["y"] as! Float
                let type = PlatformType(rawValue: platformPoint["type"] as! Int)
                let xPosition = CGFloat(xValue + x)
                let yPosition = CGFloat(yValue + y)
                
                let platformNode = createPlatformAtPosition(position: CGPoint(x: xPosition, y: yPosition), ofType: type!)
                foreground.addChild(platformNode)
            }
        }
       
        let flowers = levelData["Flowers"] as! NSDictionary
        let flowerPatterns = flowers["Patterns"] as! NSDictionary
        let flowerPositions = flowers["Positions"] as! [NSDictionary]
        
        for flowerPosition in flowerPositions {
            let x = flowerPosition["x"] as! Float
            let y = flowerPosition["y"] as! Float
            let pattern = flowerPosition["pattern"] as! NSString
            
            let flowerPattern = flowerPatterns[pattern] as! [NSDictionary]
            for flowerPoint in flowerPattern {
                let xValue = flowerPoint["x"] as! Float
                let yValue = flowerPoint["y"] as! Float
                let type = FlowerType(rawValue: flowerPoint["type"] as! Int)
                let xPosition = CGFloat(xValue + x)
                let yPosition = CGFloat(yValue + y)
                
                let flowerNode = createFlowerAtPosition(position: CGPoint(x: xPosition, y: yPosition), ofType: type!)
                foreground.addChild(flowerNode)
            }
        }
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        physicsWorld.contactDelegate = self
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = (CGFloat(acceleration.x) * 0.75 + (self.xAcceleration * 0.25))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didSimulatePhysics() {
        player.physicsBody?.velocity = CGVector(dx: xAcceleration * 400, dy: player.physicsBody!.velocity.dy)
        
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        } else if (player.position.x > self.size.width + 20) {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var updateHUD = false
        var otherNode: SKNode!
        
        if contact.bodyA.node != player {
            otherNode = contact.bodyA.node
        } else {
            otherNode = contact.bodyB.node
        }
        
        updateHUD = (otherNode as! GenericNode).collisionWithPlayer(player: player)
        
        if updateHUD {
            flowerLabel.text = "  \(GameHandler.sharedInstance.flowers)"
            scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (player.physicsBody?.isDynamic)! {
            return
        }
        
        startButton.removeFromParent()
        player.physicsBody?.isDynamic = true
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameOver {
            return
        }
        
        foreground.enumerateChildNodes(withName: "PLATFORMNODE") { (node, stop) in
            let platform = node as! PlatformNode
            platform.shouldRemoveNode(playerY: self.player.position.y)
        }
        
        foreground.enumerateChildNodes(withName: "FLOWERNODE") { (node, stop) in
            let flower = node as! FlowerNode
            flower.shouldRemoveNode(playerY: self.player.position.y)
        }
        
        if player.position.y > 200 {
            background.position = CGPoint(x: 0, y: -((player.position.y - 200) / 10))
            midground.position = CGPoint(x: 0, y: -((player.position.y - 200) / 4))
            foreground.position = CGPoint(x: 0, y: -((player.position.y - 200)))
        }
        
        if Int(player.position.y) > currentMaxY {
            GameHandler.sharedInstance.score += Int(player.position.y) - currentMaxY
            currentMaxY = Int(player.position.y)
            scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        }
        
        if Int(player.position.y) > endOfGamePosition {
            endGame()
        }
        
        if Int(player.position.y) < currentMaxY - 800 {
            endGame()
        }
    }
    
    func endGame() {
        gameOver = true
        GameHandler.sharedInstance.saveGameStats()
        
        let transition = SKTransition.fade(withDuration: 0.5)
        let endGameScene = EndGame(size: self.size)
        self.view?.presentScene(endGameScene, transition: transition)
    }
}











