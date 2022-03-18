//
//  GameScene.swift
//  Lab9_2022
//
//  Created by ICS 224 on 2022-03-02.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sprite: SKSpriteNode!
    var opponentSprite: SKSpriteNode!
    
    var score: Int = 0
    var scoreLabel: SKLabelNode!
    
    var highscore: Int = 0
    
    let spriteCategory1: UInt32 = 0b1
    let spriteCategory2: UInt32 = 0b10
    
    override func didMove(to view: SKView) {
        sprite = SKSpriteNode(imageNamed: "PlayerSprite")
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        sprite.position = CGPoint(x: size.width / 2, y: 30)
        addChild(sprite)
        
        opponentSprite = SKSpriteNode(imageNamed: "OpponentSprite")
        opponentSprite.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        opponentSprite.position = CGPoint(x: size.width / 2, y: size.height)
        addChild(opponentSprite)
        
        sprite.physicsBody?.categoryBitMask = spriteCategory1
        sprite.physicsBody?.contactTestBitMask = spriteCategory1
        sprite.physicsBody?.collisionBitMask = spriteCategory1
        
        opponentSprite.physicsBody?.categoryBitMask = spriteCategory1
        opponentSprite.physicsBody?.contactTestBitMask = spriteCategory2
        opponentSprite.physicsBody?.collisionBitMask = spriteCategory2
        
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontColor = SKColor.gray
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        
        addChild(scoreLabel)
        
//        let downMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: 0), duration: 3)
//        let upMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height), duration: 2)
//        let movement = SKAction.sequence([downMovement, upMovement])
//        opponentSprite.run(SKAction.repeatForever(movement))
        moveOpponent()

    }
    
    func moveOpponent() {
        let randomSpeed = Double(GKRandomSource.sharedRandom().nextInt(upperBound: 2))
        let movement = SKAction.move(to: CGPoint(x: opponentSprite.position.x, y: opponentSprite.position.y - (size.height - 5)), duration: randomSpeed + 2)
        opponentSprite.run(movement)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
//        print("Hit!")
        if opponentSprite != nil {
            score += 1
        }
        updateScore()
        
        spawnOpponent()
    }
    
    func spawnOpponent() {
        opponentSprite.removeAllActions()
        opponentSprite.removeFromParent()
        let randomX = GKRandomSource.sharedRandom().nextInt(upperBound: 500) + 250
        opponentSprite.position = CGPoint(x: Double(randomX), y: size.height)
        addChild(opponentSprite)
        moveOpponent()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let newPos = CGPoint(x: pos.x, y: 30)
        sprite.run(SKAction.move(to: newPos, duration: 1))
    }
    
    func touchMoved(toPoint pos : CGPoint){
    }
    
    func touchUp(atPoint pos : CGPoint) {
        let newPos = CGPoint(x: pos.x, y: 30)
        sprite.run(SKAction.move(to: newPos, duration: 1))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if opponentSprite.position.y < 30 || opponentSprite.position.x < 0 || opponentSprite.position.x > size.width {
            score -= 1
            spawnOpponent()
            updateScore()
        }
        if score < 0 {
            // Game Over
            opponentSprite.removeAllActions()
            opponentSprite.removeFromParent()
            sprite.isPaused = true
            scoreLabel.text = "Your highscore was \(highscore)"
        }
    }
    
    func updateScore()
    {
        if score >= highscore {
            highscore = score
        }
        scoreLabel.text = "Score: \(score)"
    }
}
