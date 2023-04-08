//
//  GameNode.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 04.04.2023.
//

import Foundation
import SpriteKit

class GameNode: SKSpriteNode {
    
    let hero = SKShapeNode(circleOfRadius: 30)
    let bonus = SKShapeNode(circleOfRadius: 30)
    var randomBool = Bool.random()
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        self.name = "GameNode"
        self.zPosition = 1
        self.isUserInteractionEnabled = true
        setupNode(size: size)
       
        setHero(size: size, positionX: randomPositionX())
        setBonus(size: size, positionX: randomPositionX())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNode(size: CGSize) {
        let shapeNode = SKShapeNode(rectOf: size)
        shapeNode.fillColor = .white
        shapeNode.strokeColor = .black
        shapeNode.zPosition = 1
        addChild(shapeNode)
        
    }
    
    private func randomPositionX() -> CGFloat {
        let minX: CGFloat = -30
        let maxX: CGFloat = 30
        let positionX = randomBool ? minX : maxX
        return positionX
        
    }
    
    func setHero(size: CGSize, positionX: CGFloat) {
        hero.fillColor = .blue
        hero.strokeColor = .clear

        hero.position = CGPoint(x: positionX, y: -size.height / 2 + hero.frame.height + 10)
        hero.zPosition = 2
        addChild(hero)
    }
    
    func setBonus(size: CGSize, positionX: CGFloat) {
        bonus.fillColor = .red
        bonus.strokeColor = .clear
        bonus.position = CGPoint(x: positionX, y: size.height / 2 + bonus.frame.height)
        bonus.zPosition = 2
        
        let moveBonus = SKAction.moveBy(x: 0, y: -size.height - bonus.frame.height * 2, duration: 6)
        let removeAction = SKAction.removeFromParent()
        let bonusMoveBg = SKAction.repeatForever(SKAction.sequence([moveBonus,removeAction]))
        bonus.run(bonusMoveBg)
        
        addChild(bonus)
        
    }
    
    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let randomColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return randomColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        randomBool.toggle()
        hero.position.x = CGFloat(randomBool ? -30 : 30)
    }
    
}
