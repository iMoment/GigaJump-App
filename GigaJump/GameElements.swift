//
//  GameElements.swift
//  GigaJump
//
//  Created by Stanley Pan on 02/10/2016.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    func createBackground() -> SKNode {
        let backgroundNode = SKNode()
        let spacing = 64 * scaleFactor
        
        for index in 0...19 {
            let node = SKSpriteNode(imageNamed: String(format: "Background%02d", index+1))
            node.setScale(scaleFactor)
            node.anchorPoint = CGPoint(x: 0.5, y: 0)
            node.position = CGPoint(x: self.size.width / 2, y: spacing * CGFloat(index))
            
            backgroundNode.addChild(node)
        }
        
        return backgroundNode
    }
    
    func createMidground() -> SKNode {
        let midgroundNode = SKNode()
        var anchor: CGPoint!
        var xPosition: CGFloat!
        
        for index in 0...9 {
            var name: String
            let randomNumber = arc4random() % 2
            
            if randomNumber > 0 {
                name = "cloudLeft"
                anchor = CGPoint(x: 0, y: 0.5)
                xPosition = 0
            } else {
                name = "cloudRight"
                anchor = CGPoint(x: 1, y: 0.5)
                xPosition = self.size.width
            }
            
            let cloudNode = SKSpriteNode(imageNamed: name)
            cloudNode.anchorPoint = anchor
            cloudNode.position = CGPoint(x: xPosition, y: 500 * CGFloat(index))
            
            midgroundNode.addChild(cloudNode)
        }
        
        return midgroundNode
    }
    
    func createPlayer() -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width / 2, y: 80)
        
        let sprite = SKSpriteNode(imageNamed: "Player")
        playerNode.addChild(sprite)
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        playerNode.physicsBody?.isDynamic = false
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.restitution = 1
        playerNode.physicsBody?.friction = 0
        playerNode.physicsBody?.angularDamping = 0
        playerNode.physicsBody?.linearDamping = 0
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        
        playerNode.physicsBody?.categoryBitMask = CollisionBitMask.Player
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = CollisionBitMask.Flower | CollisionBitMask.Brick
        
        return playerNode
    }
    
    func createPlatformAtPosition(position: CGPoint, ofType type: PlatformType) -> PlatformNode {
        let node = PlatformNode()
        let position = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.position = position
        node.name = "PLATFORMNODE"
        node.platformType = type
        
        var sprite: SKSpriteNode
        
        if type == PlatformType.normalBrick {
            sprite = SKSpriteNode(imageNamed: "Platform")
        } else {
            sprite = SKSpriteNode(imageNamed: "PlatformBreak")
        }
        
        node.addChild(sprite)
        node.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionBitMask.Brick
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
}















