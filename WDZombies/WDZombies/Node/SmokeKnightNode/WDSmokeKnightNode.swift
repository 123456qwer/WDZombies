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

    var behavior:WDKnightBehavior! = WDKnightBehavior.init()
    var model:WDKnightModel = WDKnightModel.init()
    
    deinit {
        print("雾骑士释放了！！！！！！！")
    }
    
    
    
    override func clearAction()  {
        self.behavior.clearAction()
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
        nodeModel = model
        behavior.setNode(node: self)
        behavior.node = self
     
        self.name = KNIGHT_NAME
     
        self.position = model.randomBornPosition()
        self.zPosition = 3 * 667 - self.position.y
        
        self.physicsBody = model.physics()
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
            self.behavior.attackAllCount = 5
        }else{
            self.wdBlood = 20
            behavior.xScale = 0.6
            behavior.yScale = 0.6
            self.behavior.attackAllCount = 20
        }
    }
}
