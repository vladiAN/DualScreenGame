//
//  StartNode.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 04.04.2023.
//

import Foundation
import SpriteKit

class StartNode: SKNode {
    
    let setSceneCallBack: (Int) -> ()
    
    init(size: CGSize, setSceneCallBack: @escaping (Int) -> ()) {
        self.setSceneCallBack = setSceneCallBack
        super.init()
        self.zPosition = 100
        self.isUserInteractionEnabled = true
        startNode(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startNode(size: CGSize) {
        let startNode = SKShapeNode(rectOf: size)
        startNode.fillColor = .clear.withAlphaComponent(0.7)
        startNode.lineWidth = 0
        addChild(startNode)
        
        let buttonNames = ["Level 1", "Level 2", "Level 3", "Level 4", "Close"]
        let buttonSpacing: CGFloat = 10
        let totalButtonHeight = CGFloat(buttonNames.count) * (50 + buttonSpacing) - buttonSpacing
        var currentY: CGFloat = totalButtonHeight/2 - 50/2
        
        buttonNames.forEach { buttonName in
            let button = SKLabelNode(text: buttonName)
            button.name = buttonName
            button.position = CGPoint(x: 0, y: currentY)
            startNode.addChild(button)
            currentY -= 50 + buttonSpacing
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes {
                switch node.name {
                case "Level 1":
                    print("1")
                    setSceneCallBack(1)
                    self.isHidden = true
                case "Level 2":
                    print("2")
                    setSceneCallBack(2)
                    self.isHidden = true
                case "Level 3":
                    print("3")
                    setSceneCallBack(3)
                    self.isHidden = true
                case "Level 4":
                    print("4")
                    setSceneCallBack(4)
                    self.isHidden = true
                case "Close":
                    print("close")
                    self.isHidden = true
                default: return
                }
            }
        }
    }
}

