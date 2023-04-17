//
//  GameNode.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 04.04.2023.
//

import Foundation
import SpriteKit

struct BitMasks {
    static let hero: UInt32 = 1
    static let bonusCoinGold: UInt32 = 2
    static let bonusCoin: UInt32 = 4
    static let enemyBox: UInt32 = 8
    static let enemyStone: UInt32 = 16
}

class GameNode: SKSpriteNode {
    
    private var hero: SKSpriteNode!
    private var bonusCoinGold: SKSpriteNode!
    private var bonusCoin: SKSpriteNode!
    private var enemyBox: SKSpriteNode!
    private var enemyStone: SKSpriteNode!
    var leftPositionX = Bool.random()
    let sizeNode: CGSize
    let sizeElement = CGSize(width: 50, height: 50)
    var speedElement: Double = 6
    
    let musicSoundEffects = MusicManager.shared
    
    init(size: CGSize, heroNameImage: String) {
        self.sizeNode = size
        super.init(texture: nil, color: .clear, size: size)
        self.name = "GameNode"
        self.zPosition = 1
        self.isUserInteractionEnabled = true
        
        setupNode(size: size)
        
        setHero(size: size, positionX: randomPositionX(), nameImage: heroNameImage)
        createElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNode(size: CGSize) {
        let shapeNode = SKShapeNode(rectOf: size)
        shapeNode.fillColor = .clear
        shapeNode.lineWidth = 0
        shapeNode.zPosition = 0
        addChild(shapeNode)
        
    }
    
    private func randomPositionX() -> CGFloat {
        let minX: CGFloat = -30
        let maxX: CGFloat = 30
        let positionX = leftPositionX ? minX : maxX
        return positionX
        
    }
    
    func setHero(size: CGSize, positionX: CGFloat, nameImage: String) {
        hero = SKSpriteNode(imageNamed: nameImage)
        hero.size = sizeElement
        hero.position = CGPoint(x: positionX, y: -size.height / 2 + hero.frame.height + 10)
//        hero.zPosition = 2
        hero.physicsBody = SKPhysicsBody(circleOfRadius: sizeElement.width / 2)
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.categoryBitMask = BitMasks.hero
        hero.physicsBody?.contactTestBitMask = BitMasks.bonusCoin | BitMasks.bonusCoinGold | BitMasks.enemyStone | BitMasks.enemyBox
        hero.physicsBody?.collisionBitMask = 0
        addChild(hero)
    }
    
    func setPhysicsBody(body: SKSpriteNode, categoryBitMask: UInt32) {
        body.physicsBody = SKPhysicsBody(circleOfRadius: sizeElement.width / 2)
        body.physicsBody?.categoryBitMask = categoryBitMask
        body.physicsBody?.isDynamic = false
        body.physicsBody?.contactTestBitMask = BitMasks.hero
        body.physicsBody?.collisionBitMask = 1
        addChild(body)
    }
    
    func createBonusCoinGold() {
        bonusCoinGold = BonusEnemyFactory(sceneSize: sizeNode,
                                          sizeElement: sizeElement,
                                          imageName: "bonusCoinGold",
                                          speedElement: speedElement)
        setPhysicsBody(body: bonusCoinGold, categoryBitMask: BitMasks.bonusCoinGold)
    }
    
    func createBonusCoin() {
        bonusCoin = BonusEnemyFactory(sceneSize: sizeNode,
                                      sizeElement: sizeElement,
                                      imageName: "bonusCoin",
                                      speedElement: speedElement)
        setPhysicsBody(body: bonusCoin, categoryBitMask: BitMasks.bonusCoin)
    }
    
    func createEnemyBox() {
        enemyBox = BonusEnemyFactory(sceneSize: sizeNode,
                                     sizeElement: sizeElement,
                                     imageName: "enemyBox",
                                     speedElement: speedElement)
        setPhysicsBody(body: enemyBox, categoryBitMask: BitMasks.enemyBox)
    }
    
    func createEnemyStone() {
        enemyStone = BonusEnemyFactory(sceneSize: sizeNode,
                                       sizeElement: sizeElement,
                                       imageName: "enemyStone",
                                       speedElement: speedElement)
        setPhysicsBody(body: enemyStone, categoryBitMask: BitMasks.enemyStone)
    }
    
    func createElements() {
        
        let delayCreate = SKAction.wait(forDuration: TimeInterval(Double.random(in: 0...2)))
        let createElement = SKAction.run {
            let random = Int.random(in: 0...3)
            switch random {
            case 0: self.createBonusCoinGold()
            case 1: self.createBonusCoin()
            case 2: self.createEnemyBox()
            case 3: self.createEnemyStone()
            default: return
            }
        }
        let delay = SKAction.wait(forDuration: TimeInterval(speedElement - Double.random(in: 0...speedElement/2)))
        let sequence = SKAction.sequence([
            delayCreate,
            createElement,
            delay
        ])
        let repeatSequence = SKAction.repeatForever(sequence)
        self.run(repeatSequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        musicSoundEffects.soundEffects(fileName: "tap")
        leftPositionX.toggle()
        hero.position.x = CGFloat(leftPositionX ? -30 : 30)
    }
    
}


