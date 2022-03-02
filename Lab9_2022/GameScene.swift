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
    
    var score: UInt = 0
    var scoreLabel: SKLabelNode!
    
    let spriteCategory1: UInt32 = 0b1
    let spriteCategory2: UInt32 = 0b10
    
    override func didMove(to view: SKView) {
        sprite = SKSpriteNode(imageNamed: "PlayerSprite")
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        sprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(sprite)
        
        opponentSprite = SKSpriteNode(imageNamed: "OpponentSprite")
        opponentSprite.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        opponentSprite.position = CGPoint(x: size.width / 2, y: size.height)
        addChild(opponentSprite)
        
        sprite.physicsBody?.categoryBitMask = spriteCategory1
        sprite.physicsBody?.contactTestBitMask = spriteCategory1
        sprite.physicsBody?.collisionBitMask = spriteCategory1
        
        opponentSprite.physicsBody?.categoryBitMask = spriteCategory1
        opponentSprite.physicsBody?.contactTestBitMask = spriteCategory1
        opponentSprite.physicsBody?.collisionBitMask = spriteCategory1
        
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
        let randomX = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.width))
        let randomY = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.height))
        let movement = SKAction.move(to: CGPoint(x: randomX, y: randomY), duration: 1)
        opponentSprite.run(movement, completion: { self.moveOpponent() })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Hit!")
        score += 1
        scoreLabel.text = "Score \(score)"
    }
    
    func touchDown(atPoint pos : CGPoint) {
        sprite.run(SKAction.move(to: pos, duration: 1))
    }
    
    func touchMoved(toPoint pos : CGPoint){
    }
    
    func touchUp(atPoint pos : CGPoint) {
        sprite.run(SKAction.move(to: pos, duration: 1))
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
    }
}
