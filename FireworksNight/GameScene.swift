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
    let rightEdge = 1024 + 22
    
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
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y >= 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
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
        let movementAmount = CGFloat(1800)
            
        
        switch GKRandomSource.sharedRandom().nextInt(upperBound: 4) {
        case 0:
            //fire five straight up
            createFireworks(xMovement: 0, x: 512, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            //fire 5 in a fan
            createFireworks(xMovement: 0, x: 512, y: bottomEdge)
            createFireworks(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFireworks(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFireworks(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFireworks(xMovement: 200, x: 512 + 200, y: bottomEdge)
        case 2:
            // five from left to right
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3:
            // fire five, from the right to the left
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node is SKSpriteNode {
                let sprite = node as! SKSpriteNode
                if sprite.name == "firework" {
                    sprite.name = "selected"
                    for parent in fireworks {
                        let firework = parent.children[0] as! SKSpriteNode
                        if firework.name == "selected" && firework.color != sprite.color {
                            firework.name = "firework"
                            firework.colorBlendFactor = 1
                        }
                    }
                    sprite.colorBlendFactor = 0
                }
            }
        }
    }
    
    func explode(firework: SKNode) {
        let color = (firework.children[0] as! SKSpriteNode).color
        var emitter: SKEmitterNode
        switch color {
        case UIColor.cyan:
            emitter = SKEmitterNode(fileNamed: "explodeCyan")!
        case UIColor.green:
            emitter = SKEmitterNode(fileNamed: "explodeGreen")!
        case UIColor.red:
            emitter = SKEmitterNode(fileNamed: "explodeRed")!
        default:
            emitter = SKEmitterNode(fileNamed: "explode")!
        }
        
        emitter.position = firework.position
        addChild(emitter)
        
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            let firework = fireworkContainer.children[0] as! SKSpriteNode
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}





