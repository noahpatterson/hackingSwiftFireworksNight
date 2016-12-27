//
//  GameScene.swift
//  FireworksNight
//
//  Created by Noah Patterson on 12/27/16.
//  Copyright © 2016 noahpatterson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer!
    
    //fireworks contain a container node, image node and fuse node
    var fireworks = [SKNode]()
    
    //where the launch the fireworks from
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdget = 1024 + 22
    
    var score: Int = 0 {
        didSet {
           
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func createFireworks(xMovement: CGFloat, x: Int, y: Int) {
        //create container node and place at specified position
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        //create a rocket sprite
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.name = "firework"
        node.addChild(firework)
        
        //give firework a random color
        switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
        case 0:
            firework.color     = .cyan
            firework.colorBlendFactor = 1
        case 1:
            firework.color     = .green
            firework.colorBlendFactor = 1
        case 2:
            firework.color     = .red
            firework.colorBlendFactor = 1
        default:
            break
        }
        
        //path for the movement of the firework
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        //tell container to follow path turning if needed
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        //create particles behind firewoks to make it look like fireworks are lit
        let emitter = SKEmitterNode(fileNamed: "fuse")!
        emitter.position = CGPoint(x: 0, y: -22)
        node.addChild(emitter)
        
        fireworks.append(node)
        addChild(node)
    }
    
    func launchFireworks() {
        
    }
}
