//
//  WDSmokeKnightNode.swift
//  WDZombies
//
//  Created by wudong on 2017/12/12.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDSmokeKnightNode: WDBaseNode {

    var behavior:WDKnightBehavior!
   
    
    var link:CADisplayLink!
    var attack2Timer:Timer!
    var attack2Count:NSInteger = 0
   
    
    var model:WDKnightModel = WDKnightModel.init()


    
    typealias move = (_ knightNode:WDSmokeKnightNode) -> Void
    typealias attack2 = (_ knightNode:WDSmokeKnightNode) -> Void
    typealias attack1 = (_ knightNode:WDSmokeKnightNode) -> Void
    typealias died = (_ knightNode:WDSmokeKnightNode) -> Void
    
    var moveAction:move!
    var attack2Action:attack2!
    var attack1Action:attack1!
    var diedAction:died!

    
    func removeTimer()  {
        if attack2Timer != nil {
            attack2Timer.invalidate()
            attack2Timer = nil
        }
    }
    
    @objc func linkMove()  {
        if self.wdBlood <= 0 {
            self.removeLink()
            return
        }
        
        moveAction(self)
    }
    
    func starMove()  {
        link = CADisplayLink.init(target: self, selector: #selector(linkMove))
        link.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func removeLink()  {
        if link != nil{
            link.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
            link.invalidate()
            link = nil
        }
    }
    
    @objc func attack2ActionTimer()  {
        if self.canMove {
            attack2Count += 1
            if attack2Count >= 3{
                                
                attack2Action(self)
                attack2Count = 0
            }
        }
    }
    
    func setPhy() -> Void {
        
        self.physicsBody?.categoryBitMask = GREEN_ZOM_CATEGORY
        self.physicsBody?.contactTestBitMask = GREEN_ZOM_CONTACT
        self.physicsBody?.collisionBitMask = GREEN_ZOM_COLLISION
        
    }
    
    func removePhy() -> Void {
        self.physicsBody?.categoryBitMask = 0;
        self.physicsBody?.contactTestBitMask = 0;
        self.physicsBody?.collisionBitMask = 0;
    }
    
    func setPhysicsBody(isSet:Bool) -> Void {
        
        if isSet {
            self.setPhy()
        }else{
            self.removePhy()
        }
    }
    
    
    override func configureModel() {
        model.configureWithZomName(zomName: KNIGHT_NAME)
    }
    
    func initWithPersonNode(personNode:WDPersonNode) {
        
        self.configureModel()
        
        attack2Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(attack2ActionTimer), userInfo: nil, repeats: true)
        
        behavior = WDKnightBehavior.init()
        behavior.kNight = self
        
        
        self.name = KNIGHT_NAME
       
        
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:40,height:40))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        
        physicsBody.categoryBitMask = GREEN_ZOM_CATEGORY;
        physicsBody.contactTestBitMask = GREEN_ZOM_CONTACT;
        physicsBody.collisionBitMask = GREEN_ZOM_COLLISION;
        physicsBody.isDynamic = true;
        
        let x:CGFloat = CGFloat(arc4random() % UInt32(kScreenHeight*2));
        let y:CGFloat = CGFloat(arc4random() % UInt32(kScreenWidth*2));
        
        self.position = CGPoint(x:x, y:y);
        self.zPosition = 3 * 667 - y;
        
        self.physicsBody = physicsBody
        self.direction = kLeft
        self.wdFire_impact = 200
        self.wdBlood = 100
        self.wdAttack = 3
        
        self.setAttribute(isBoss: self.isBoss)

    }
    
    
    func setAttribute(isBoss:Bool)  {
        if isBoss{
            self.wdBlood = 100
            behavior.xScale = 1
            behavior.yScale = 1
        }else{
            self.wdBlood = 20
            behavior.xScale = 0.6
            behavior.yScale = 0.6
        }
    }
}
