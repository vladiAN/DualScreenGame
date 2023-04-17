//
//  PauseButton.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 05.04.2023.
//

import Foundation
import SpriteKit

class PauseButton: SKSpriteNode {
    let startNode: StartNode
    
    init(startNode: SKNode) {
        self.startNode = startNode as! StartNode
        
        let texture = SKTexture(imageNamed: "pauseButton")
        super.init(texture: texture, color: .clear, size: CGSize(width: 35, height: 35))
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
              MusicManager.shared.soundEffects(fileName: "click")
              startNode.isHidden = !startNode.isHidden
              startNode.playButton.isHidden = false
              self.scene?.isPaused = true
          }
        
      }
}
