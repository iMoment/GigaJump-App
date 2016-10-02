
import SpriteKit

class EndGame: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let flower = SKSpriteNode(imageNamed: "flower")
        flower.position = CGPoint(x: 25, y: self.size.height - 30)
        addChild(flower)
        
        let flowersLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        flowersLabel.fontSize = 30
        flowersLabel.fontColor = SKColor.white
        flowersLabel.position = CGPoint(x: 50, y: self.size.height - 40)
        flowersLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        flowersLabel.text = "  \(GameHandler.sharedInstance.flowers)"
        addChild(flowersLabel)
        
  
        let scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: 300)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        addChild(scoreLabel)
        

        let highScoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        highScoreLabel.fontSize = 30
        highScoreLabel.fontColor = SKColor.red
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: 450)
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        highScoreLabel.text = "\(GameHandler.sharedInstance.highScore)"
        addChild(highScoreLabel)
        
        let tryAgainLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        tryAgainLabel.fontSize = 30
        tryAgainLabel.fontColor = SKColor.white
        tryAgainLabel.position = CGPoint(x: self.size.width / 2, y: 50)
        tryAgainLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tryAgainLabel.text = "Tap To Play Again"
        addChild(tryAgainLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
}
