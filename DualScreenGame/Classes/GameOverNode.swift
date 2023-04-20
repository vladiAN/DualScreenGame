//
//  GameOverNode.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 11.04.2023.
//

import Foundation
import SpriteKit

class GameOverNode: SKNode {
    
    let setSceneCallBack: () -> ()
    let startNode: StartNode
    let musicSoundEffects = MusicManager.shared
    
    init(size: CGSize, startNode: SKNode, score: Int, level: Int, setSceneCallBack: @escaping () -> ()) {
        self.startNode = startNode as! StartNode
        self.setSceneCallBack = setSceneCallBack
        super.init()
        self.zPosition = 100
        self.alpha = 0
        self.isUserInteractionEnabled = true
        
        self.run(.sequence([
            .wait(forDuration: 2),
            .fadeIn(withDuration: 1.5)
        ]))
        
        setNode(size: size, score: score, level: level)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNode(size: CGSize, score: Int, level: Int) {
        let gameOverNode = SKSpriteNode(imageNamed: "gameOverBackground")
        gameOverNode.size = size
        gameOverNode.zPosition = -1
        
        addChild(gameOverNode)
        
        var gameOverImageTexture = SKTexture()
        let scoreText: String
        let recordLevel = UserDefaults.standard.integer(forKey: "bestScoreForLevel\(level)Key")
        
        if score >= recordLevel {
            gameOverImageTexture = SKTexture(imageNamed: "winner")
            UserDefaults.standard.set(score, forKey: "bestScoreForLevel\(level)Key")
            scoreText = "NEW RECORD FOR \(level)x: \(score)"
        } else {
            gameOverImageTexture = SKTexture(imageNamed: "lose")
            scoreText = "SCORE: \(score), RECORD FOR \(level)x: \(recordLevel)"
        }
        
        let gameOverImage = SKSpriteNode(texture: gameOverImageTexture)
        gameOverImage.size = CGSize(width: 460, height: 134)
        gameOverImage.position = CGPoint(x: 0, y: 100)
        
        addChild(gameOverImage)
        
        let scoreLabel = SKLabelNode(text: scoreText)
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        
        let scoreTextShape = SKShapeNode(rectOf: CGSize(width: scoreLabel.frame.size.width + 20, height: 55), cornerRadius: 10)
        scoreTextShape.fillColor = #colorLiteral(red: 0.9935365319, green: 0.4001332521, blue: 0, alpha: 0.5)
        scoreTextShape.lineWidth = 0
        scoreTextShape.position = CGPoint(x: 0, y: gameOverImage.position.y - gameOverImage.size.height/2 - scoreTextShape.frame.size.height/2 - 10)
        
        scoreTextShape.addChild(scoreLabel)
        addChild(scoreTextShape)
        
        let buttonNames = ["MENU","AGAIN"]
        let buttonSpacing: CGFloat = 20
        let totalButtonHeight = CGFloat(buttonNames.count) * (50 + buttonSpacing) - buttonSpacing
        var currentY: CGFloat = scoreTextShape.position.y - scoreTextShape.frame.size.height/2 - totalButtonHeight/2 - buttonSpacing - 30

        buttonNames.enumerated().forEach { index, buttonName in
            let button = SKShapeNode(rectOf: CGSize(width: 190, height: 55), cornerRadius: 10)
            button.name = buttonName
            button.fillColor = #colorLiteral(red: 0.9978829026, green: 0.3996573687, blue: 0, alpha: 1)
            button.lineWidth = 0
            button.position = CGPoint(x: 0, y: currentY)
            let label = SKLabelNode(text: buttonName)
            label.name = buttonName
            label.fontName = "Helvetica-Bold"
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
            button.addChild(label)
            gameOverNode.addChild(button)
            currentY += 50 + buttonSpacing
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes {
                switch node.name {
                case "AGAIN":
                    musicSoundEffects.soundEffects(fileName: "click")
                    setSceneCallBack()
                    scene?.isPaused = false
                    self.isHidden = true
                case "MENU":
                    musicSoundEffects.soundEffects(fileName: "click")
                    startNode.isHidden = false
                    startNode.playButton.isHidden = true
                    musicSoundEffects.playBackgroundMusic()
                    self.isHidden = true
                default: return
                }
            }
        }
    }
}

