//
//  WDSquidNode.swift
//  WDZombies
//
//  Created by wudong on 2017/12/26.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

class WDSquidNode: WDBaseNode {

    var behavior:WDSquidBehavior = WDSquidBehavior.init()
    var model:WDSquidModel = WDSquidModel.init()
    
    override func configureModel() {
        model.configureWithZomName(zomName: SQUID_NAME)
    }
    
    func initWithPerson(personNode:WDPersonNode) {
        self.configureModel()
        nodeModel = model
        behavior.setNode(node: self)
        behavior.node = self
        
        
        self.name = SQUID_NAME
        
        
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
        }else{
            self.wdBlood = 20
            behavior.xScale = 0.6
            behavior.yScale = 0.6
        }
    
    }
}
