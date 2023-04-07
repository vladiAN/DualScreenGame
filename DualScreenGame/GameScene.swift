//
//  GameScene.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 29.03.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameLevel: Int!
    var startNode: SKNode!
    var pauseButton: PauseButton!
    var gameNodeArray: [SKNode] = []
    
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        setStartScene()
        setPauseButton()
    }
    
    func setStartScene() {
        startNode = StartNode(size: self.size) { level in
            self.removeChildren(in: self.gameNodeArray)
            self.setGame(level: level)
        }
        startNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(startNode)
    }
    
    func setPauseButton() {
        pauseButton = PauseButton(startNode: startNode)
        pauseButton.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
        addChild(pauseButton)
    }
    
    func setGame(level: Int) {
        
        let screenWidth = self.size.width
        let screenHeight = self.size.height
        
        for i in 0..<level {
            let partWidtht = screenWidth / CGFloat(level)
            
            let gameNode = GameNode(size: CGSize(width: partWidtht, height: screenHeight))
            gameNode.position = CGPoint(x: screenWidth - CGFloat(i+1) * partWidtht + partWidtht / 2, y: self.frame.midY)
            addChild(gameNode)
            gameNodeArray.append(gameNode)
        }
    }
    
}
