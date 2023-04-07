//
//  PauseButton.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 05.04.2023.
//

import Foundation
import SpriteKit

class PauseButton: SKSpriteNode {
    let startNode: SKNode
    
    init(startNode: SKNode) {
        self.startNode = startNode
        
        let texture = SKTexture(imageNamed: "pauseButton")
        super.init(texture: texture, color: .clear, size: CGSize(width: 50, height: 50))
        self.zPosition = 20
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          guard let touch = touches.first else { return }
          let location = touch.location(in: self.parent!)

          if self.contains(location) {
              startNode.isHidden = !startNode.isHidden
          }
      }
}
