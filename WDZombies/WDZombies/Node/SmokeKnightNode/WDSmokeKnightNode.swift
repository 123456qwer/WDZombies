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
        nodeBehavior = behavior

        self.name = KNIGHT_NAME
     
        self.position = model.randomBornPosition()
        self.zPosition = 3 * 667 - self.position.y
        
        self.physicsBody = model.physics()
        self.direction = kLeft
        self.wdFire_impact = 200
        self.wdBlood = 100
        self.wdAttack = 3
        self.experience = 25
        
        self.setAttribute(isBoss: self.isBoss)

    }
    
    
    func setAttribute(isBoss:Bool)  {
        if isBoss{
            self.wdBlood = 100
            self.behavior.attackAllCount = 5
            self.size = CGSize(width:165,height:165)

        }else{
            self.wdBlood = 20
            self.behavior.attackAllCount = 20
            self.size = CGSize(width:165 * 0.6,height:165 * 0.6)

        }
    }
}
