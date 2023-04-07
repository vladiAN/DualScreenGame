//
//  GameNode.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 04.04.2023.
//

import Foundation
import SpriteKit

class GameNode: SKNode {
    
    init(size: CGSize) {
        super.init()
        self.name = "GameNode"
        self.zPosition = 1
        self.isUserInteractionEnabled = true
        setupNode(size: size)
        setHero()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNode(size: CGSize) {
        let shapeNode = SKShapeNode(rectOf: size)
        shapeNode.fillColor = .white
        shapeNode.strokeColor = .black
        shapeNode.zPosition = 1
        addChild(shapeNode)
        
    }
    
    func setHero() {
        let hero = SKShapeNode(circleOfRadius: 30)
        hero.fillColor = .blue
        hero.strokeColor = .clear
        hero.position = CGPoint(x: frame.maxX, y: 80)
        print(frame.maxX, self.frame.minX)
        hero.zPosition = 5
        addChild(hero)
    }
    
    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let randomColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return randomColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let shapeNode = children.first as? SKShapeNode {
            shapeNode.fillColor = randomColor()
        }
    }
    
}
