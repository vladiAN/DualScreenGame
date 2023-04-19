//
//  BonusEnemyFactory.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 11.04.2023.
//

import Foundation
import SpriteKit

class BonusEnemyFactory: SKSpriteNode {
    
    init(sceneSize: CGSize, sizeElement: CGSize, imageName: String, speedElement: Double) {
        let positionX: CGFloat = Bool.random() ? 30 : -30
        let texure = SKTexture(imageNamed: imageName)
        super.init(texture: texure, color: .clear, size: CGSize(width: 50, height: 50))
        self.position = CGPoint(x: positionX, y: sceneSize.height / 2 + self.frame.height)
        self.zPosition = 2
        
        let delayMove = SKAction.wait(forDuration: 1)
        let moveElement = SKAction.moveBy(x: 0, y: -sceneSize.height - self.frame.height * 2, duration: TimeInterval(speedElement))
        let removeAction = SKAction.removeFromParent()
        let elementMoveBg = SKAction.repeatForever(SKAction.sequence([delayMove, moveElement, removeAction]))
        self.run(elementMoveBg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
