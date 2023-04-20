//
//  GameScene.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 29.03.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var startNode: SKNode!
    var pauseButton: PauseButton!
    var gameNodeArray: [SKNode] = []
    var borderNode = SKShapeNode()
    var borderNodeArray: [SKShapeNode] = []
    let arrayNameImageForHero = Array(1...4).map { int in
        "hero\(int)"
    }
    var level: Int!
    var scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameIsStart = false
    let musicSoundEffects = MusicManager.shared
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setBackground()
        setStartScene()
        setPauseButton()
    }
    
    func setBackground() {
        let backgroundTexture = SKTexture(imageNamed: "gameBackground")
        let backgroundImage = SKSpriteNode(texture: backgroundTexture)
        backgroundImage.size = CGSize(width: self.size.width * 2, height:  self.size.height * 2)
        backgroundImage.position = CGPoint(x: 0, y: 0)
        backgroundImage.zPosition = -1
        addChild(backgroundImage)
    }
    
    func setStartScene() {
        musicSoundEffects.playBackgroundMusic()
        startNode = StartNode(size: self.size) { [weak self] level in
            guard let self else { return }
            self.removeChildren(in: self.gameNodeArray)
            self.removeChildren(in: self.borderNodeArray)
            self.scoreLabel.removeFromParent()
            self.level = level
            self.setGame()
            self.score = 0
        }
        startNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(startNode)
    }
    
    func setGameOverNode() {
        self.removeAllActions()
        self.children.forEach { node in
            node.removeAllActions()
        }
        let gameOverNode = GameOverNode(size: self.size,
                                        startNode: startNode,
                                        score: score,
                                        level: level,
                                        setSceneCallBack: { [weak self] in
            guard let self else { return }
            self.removeChildren(in: self.gameNodeArray)
            self.removeChildren(in: self.borderNodeArray)
            self.scoreLabel.removeFromParent()
            self.setGame()
            self.score = 0
            self.musicSoundEffects.playBackgroundMusic()
        })
        gameOverNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(gameOverNode)
    }
    
    
    func setPauseButton() {
        pauseButton = PauseButton(startNode: startNode)
        
        pauseButton.position = CGPoint(x: frame.minX + 40, y: frame.maxY - 40)
        addChild(pauseButton)
    }
    
    func setScoreLabel() {
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: frame.maxX - 30, y: frame.maxY - 40)
        addChild(scoreLabel)
    }
    
    func setBorder(gameNode: SKSpriteNode, gameNodeWidth: CGFloat) {
        let shapeNodeWidth: CGFloat = 1
        let shapeNodeHeight = self.size.height
        borderNode = SKShapeNode(rectOf: CGSize(width: shapeNodeWidth, height: shapeNodeHeight))
        borderNode.fillColor = #colorLiteral(red: 0.9978829026, green: 0.3996573687, blue: 0, alpha: 1)
        borderNode.strokeColor = #colorLiteral(red: 0.9978829026, green: 0.3996573687, blue: 0, alpha: 1)
        borderNode.position = CGPoint(x: gameNode.position.x + gameNodeWidth / 2 + shapeNodeWidth / 2, y: self.frame.midY)
        addChild(borderNode)
        borderNodeArray.append(borderNode)
    }
    
    func setGame() {
        
        scene?.speed = 1
        setScoreLabel()
        let screenWidth = self.size.width
        let screenHeight = self.size.height
        
        for i in 0..<level {
            let gameNodeWidth = screenWidth / CGFloat(level)
            
            let gameNode = GameNode(size: CGSize(width: gameNodeWidth, height: screenHeight),
                                    heroNameImage: arrayNameImageForHero[i])
            gameNode.position = CGPoint(x: screenWidth - CGFloat(i+1) * gameNodeWidth + gameNodeWidth / 2, y: self.frame.midY)
            addChild(gameNode)
            gameNodeArray.append(gameNode)
            
            
            switch level {
            case 2:
                if i == 1 {
                    setBorder(gameNode: gameNode, gameNodeWidth: gameNodeWidth)
                }
            case 3:
                if i == 1 || i == 2 {
                    setBorder(gameNode: gameNode, gameNodeWidth: gameNodeWidth)
                }
            case 4:
                if i == 1 || i == 2 || i == 3 {
                    setBorder(gameNode: gameNode, gameNodeWidth: gameNodeWidth)
                }
            default: return
            }
        }
        
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let newSpeed = scene!.speed + (0.2   / Double(level))
        var enotherBody: SKPhysicsBody
        var hero: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == BitMasks.hero {
            enotherBody = contact.bodyB
            hero = contact.bodyA
        } else {
            enotherBody = contact.bodyA
            hero = contact.bodyB
        }
        
        func catchCoinEffects(position: CGPoint, node: SKNode) {
            let effect = SKEmitterNode(fileNamed: "MyParticle.sks")!
            let removeEffect = SKAction.sequence([
                .wait(forDuration: 3),
                .removeFromParent()
            ])
            effect.position = position
            effect.zPosition = 100
            effect.run(removeEffect)
            node.addChild(effect)
        }
        
        func coinContactSet() {
            if let parentNode = enotherBody.node?.parent {
                catchCoinEffects(position: enotherBody.node!.position, node: parentNode)
            }
            if let coin = enotherBody.node as? SKSpriteNode {
                coin.removeFromParent()
            }
            scene?.speed = newSpeed
        }
        
        func deathHero() {
            let pulsedRed = SKAction.sequence([
                SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.5),
                SKAction.wait(forDuration: 0.1),
                SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)
            ])
            enotherBody.node?.isPaused = true
            hero.node?.run(pulsedRed)
            musicSoundEffects.soundEffects(fileName: "die")
            musicSoundEffects.soundEffects(fileName: "gameOver")
            musicSoundEffects.stopBackgroundMusic()
            
            func pauseNode(node: SKNode) {
                if enotherBody.node?.parent == node {
                    let nodeFailStop = SKAction.sequence([
                        .wait(forDuration: 1),
                        .run {
                            node.isPaused = true
                        }
                    ])
                    node.run(nodeFailStop)
                } else {
                    node.isPaused = true
                }
            }
            
            let sqnsDealyGameOver = SKAction.sequence([
                .run {
                    self.gameNodeArray.forEach { node in
                        pauseNode(node: node)
                    }
                },
                .wait(forDuration: 2),
                .run  {
                    self.setGameOverNode()
                }
            ])
            self.run(sqnsDealyGameOver)
        }
        
        switch enotherBody.categoryBitMask {
        case BitMasks.bonusCoinGold:
            musicSoundEffects.soundEffects(fileName: "coin2")
            score += 50
            coinContactSet()
        case BitMasks.bonusCoin:
            musicSoundEffects.soundEffects(fileName: "coin1")
            score += 25
            coinContactSet()
        case BitMasks.enemyBox:
            deathHero()
            hero.node?.physicsBody?.isDynamic = false
        case BitMasks.enemyStone:
            deathHero()
            hero.node?.physicsBody?.isDynamic = false
        default:
            print("contact unkmow")
        }
    }
    
}

