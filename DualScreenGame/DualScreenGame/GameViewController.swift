//
//  GameViewController.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 29.03.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let scene = GameScene()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScene()
    }
    
    func setScene() {
        
        let skView = SKView(frame: view.frame)
        self.view.addSubview(skView)
        
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
    }
    
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
