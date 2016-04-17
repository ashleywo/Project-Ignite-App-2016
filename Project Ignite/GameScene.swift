//
//  GameScene.swift
//  Project Ignite
//
//  Created by Joseph Aracri on 3/13/16.
//  Copyright (c) 2016 Apps for Charity. All rights reserved.
//

import SpriteKit
var score = 0
let basketBallHoop = "Hoop"
let basketBallName = "Basketball"
let basketBallIndicator = "Indicator"
var isFingerOnBall = false
let basketBallCategory : UInt32 = 0x1 << 0
let indicatorCategory : UInt32 = 0x1 << 1
let scoreBoard = SKLabelNode(fontNamed: "Georgia")
class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
       super.didMoveToView(view)
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        physicsWorld.contactDelegate = self
        
        //Basket Position
       
        let hoop = SKSpriteNode(imageNamed: "Hoop")
        
        func randomInRange(lo: Int, hi : Int) -> Int {
            return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
        }
        let basketY = randomInRange(Int(CGRectGetMinY(self.frame)), hi: Int(CGRectGetMidY(self.frame)))
       
        hoop.position = CGPoint(x: CGFloat(hoop.position.x), y: CGFloat(basketY))
        
        let basketBall = childNodeWithName(basketBallName) as! SKSpriteNode
        let indicator = childNodeWithName(basketBallIndicator) as! SKSpriteNode
        
        basketBall.physicsBody!.categoryBitMask = basketBallCategory
        indicator.physicsBody!.categoryBitMask = indicatorCategory
        
        basketBall.physicsBody!.contactTestBitMask = indicatorCategory
        indicator.physicsBody!.contactTestBitMask = basketBallCategory
//
//        basketBall.physicsBody!.collisionBitMask = 0
        indicator.physicsBody!.collisionBitMask = 0
        NSLog(String(indicator.physicsBody!.collisionBitMask))
        NSLog(String(basketBall.physicsBody!.collisionBitMask))
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        var touch = touches.first as! UITouch?
        var touchLocation = touch!.locationInNode(self)
        //NSLog("touch")
        
        if let body = physicsWorld.bodyAtPoint(touchLocation) {
            if body.node!.name == basketBallName {
                isFingerOnBall = true
                body.node?.physicsBody!.applyForce(CGVector(dx: -(body.node?.physicsBody?.velocity.dx)!, dy: -(body.node?.physicsBody?.velocity.dy)!))
               
                body.node!.physicsBody?.pinned = false
                
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let ball = childNodeWithName(basketBallName) as! SKSpriteNode
        
        if isFingerOnBall {
            var scale = CGFloat(75)
            var touch = touches.first as! UITouch?
            var touchLocation = touch!.locationInNode(self)
            var previousLocation = touch!.previousLocationInNode(self)
            ball.position = touchLocation
            
            ball.physicsBody!.applyForce(CGVector(dx: -(ball.physicsBody?.velocity.dx)!, dy: -(ball.physicsBody?.velocity.dy)!))
            ball.physicsBody!.applyForce(CGVectorMake(scale*(touchLocation.x - previousLocation.x), scale*(touchLocation.y - previousLocation.y)))
        }
        else {
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isFingerOnBall = false
        var touch = touches.first as! UITouch?
        var touchLocation = touch!.locationInNode(self)
        let ball = childNodeWithName(basketBallName) as! SKSpriteNode
        //ball.physicsBody!.applyImpulse(CGVectorMake(15, 42))
    }
    
     func viewDidLoad() {
        
    NSLog("AHHHHHHH")
    
//    let basketBall = childNodeWithName(basketBallName) as! SKSpriteNode
//    let indicator = childNodeWithName(basketBallIndicator) as! SKSpriteNode
//    
//    basketBall.physicsBody!.categoryBitMask = basketBallCategory
//    indicator.physicsBody!.categoryBitMask = indicatorCategory
//    
//    basketBall.physicsBody!.contactTestBitMask = basketBallCategory | indicatorCategory
//    indicator.physicsBody!.contactTestBitMask = basketBallCategory | indicatorCategory
//    
//    basketBall.physicsBody!.collisionBitMask = basketBallCategory | indicatorCategory
//    indicator.physicsBody!.collisionBitMask = 0x0
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //NSLog("thing")
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.contactTestBitMask < contact.bodyB.contactTestBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask == basketBallCategory && secondBody.categoryBitMask == indicatorCategory)
        || (firstBody.categoryBitMask == indicatorCategory && secondBody.categoryBitMask == basketBallCategory){
            NSLog("contact with indicator")
            
//            NSLog(String(firstBody.collisionBitMask))
//            NSLog(String(secondBody.collisionBitMask))
            score = score + 1
           // NSLog(String(score))
            let basketBall = childNodeWithName(basketBallName)
            basketBall!.position.x = 100
            basketBall!.position.y = 100
            basketBall!.physicsBody!.pinned = true
           var scoreString = String(score)
            func update(value:String){
               scoreString = value
               scoreBoard.text = scoreString }
        
        }

        }
   //}

   }


