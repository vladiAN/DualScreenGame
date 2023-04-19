//
//  StartNode.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 04.04.2023.
//

import Foundation
import SpriteKit

class StartNode: SKNode {
    
    let levelCountCallBack: (Int) -> ()
    let musicSoundEffects = MusicManager.shared
    let playButton = SKSpriteNode(imageNamed: "playButton")
    let musicButton = SKSpriteNode()
    let defaults = MusicManager.shared.defaults
    
    init(size: CGSize, levelCountCallBack: @escaping (Int) -> ()) {
        self.levelCountCallBack = levelCountCallBack
        super.init()
        self.zPosition = 100
        self.isUserInteractionEnabled = true
        startNode(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startNode(size: CGSize) {
        
        let backgroundNode = SKShapeNode(rectOf: size)
        backgroundNode.fillColor = .black
        backgroundNode.zPosition = -2
        addChild(backgroundNode)
        
        let startNode = SKSpriteNode(imageNamed: "startBackground")
        startNode.size = size
        startNode.zPosition = -1

        addChild(startNode)
        
        let buttonNames = ["2x", "3x", "4x"]
        let buttonColor = [#colorLiteral(red: 0.2086621225, green: 0.4848608971, blue: 0.6918790936, alpha: 1), #colorLiteral(red: 0.4912056923, green: 0.635033071, blue: 0.1864731908, alpha: 1), #colorLiteral(red: 0.7202162743, green: 0.4364849031, blue: 0.1123431996, alpha: 1)]
        let buttonSpacing: CGFloat = 15
        let totalButtonHeight = CGFloat(buttonNames.count) * (50 + buttonSpacing) - buttonSpacing
        var currentY: CGFloat = totalButtonHeight/2 - 50/2
        
        buttonNames.enumerated().forEach { index, buttonName in
            let button = SKShapeNode(rectOf: CGSize(width: 190, height: 55), cornerRadius: 10)
            button.name = buttonName
            button.fillColor = buttonColor[index]
            button.lineWidth = 0
            button.position = CGPoint(x: 0, y: currentY)
            let label = SKLabelNode(text: buttonName)
            label.name = buttonName
            label.fontName = "Helvetica-Bold"
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
            button.addChild(label)
            startNode.addChild(button)
            currentY -= 50 + buttonSpacing
        }
        
        setPlayButton(size: size)
        setMusicButton(size: size)
    }
    
    func setPlayButton(size: CGSize) {
        playButton.name = "playButton"
        playButton.size = CGSize(width: 35, height: 35)
        playButton.position = CGPoint(x: -size.width / 2 + 40, y: size.height / 2 - 40)
        playButton.isHidden = true
        addChild(playButton)
    }
    
    func setMusicButton(size: CGSize) {
        let imageButton = defaults.musicEffectsIsOn ? "musicOn" : "musicOff"
        musicButton.texture = SKTexture(imageNamed: imageButton)
        musicButton.name = "music"
        musicButton.size = CGSize(width: 35, height: 35)
        musicButton.position = CGPoint(x: -size.width / 2 + 40, y: size.height / 2 - 80)
        addChild(musicButton)
    }
    
    func selectButton(level: Int) {
        musicSoundEffects.soundEffects(fileName: "click")
        levelCountCallBack(level)
        scene?.isPaused = false
        self.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes {
                switch node.name {
                case "2x":
                    selectButton(level: 2)
                case "3x":
                    selectButton(level: 3)
                case "4x":
                    selectButton(level: 4)
                case "playButton":
                    musicSoundEffects.soundEffects(fileName: "click")
                    scene?.isPaused = false
                    self.isHidden = true
                case "music":
                    musicSoundEffects.soundEffects(fileName: "click")
                    UserDefaultManager.shared.musicEffectsIsOn.toggle()
                    if defaults.musicEffectsIsOn {
                        musicButton.texture = SKTexture(imageNamed: "musicOn")
                        MusicManager.shared.defaults.musicEffectsIsOn = true
                        MusicManager.shared.playBackgroundMusic()
                    } else {
                        musicButton.texture = SKTexture(imageNamed: "musicOff")
                        MusicManager.shared.defaults.musicEffectsIsOn = false
                        MusicManager.shared.stopBackgroundMusic()
                    }
                default: return
                }
            }
        }
    }
}

