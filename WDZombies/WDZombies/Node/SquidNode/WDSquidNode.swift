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
    
    deinit {
        WDLog(item: "鱿鱼哥被释放了")
    }
    
    override func configureModel() {
        model.configureWithZomName(zomName: SQUID_NAME)
    }
    
    func initWithPerson(personNode:WDPersonNode) {
        self.configureModel()
        nodeModel = model
        behavior.setNode(node: self)
        behavior.node = self
        nodeBehavior = behavior

        
        self.name = SQUID_NAME
        
        
        self.position = model.randomBornPosition()
        self.zPosition = 3 * 667 - self.position.y
        
        self.direction = kLeft
        self.wdFire_impact = 200
        self.wdBlood = 100
        self.wdAttack = 3
        self.experience = 30
        
        self.setAttribute(isBoss: self.isBoss)
        
    }
    
    override func clearAction() {
        self.behavior.clearAction()
    }
    
    func setAttribute(isBoss:Bool)  {
        if isBoss{
            self.wdBlood = 100
            self.size = CGSize(width:140 ,height:100)
            self.physicsBody = model.setUsualPhyBody(size: CGSize(width:60,height:80), point: CGPoint(x:0,y:0))
            self.setPhyBodyColor(size: CGSize(width:60,height:80), point: CGPoint(x:0,y:0))
            
        }else{
            self.wdBlood = 20
            self.size = CGSize(width:140 * 0.6 ,height:100 * 0.6)
            self.physicsBody = model.setUsualPhyBody(size: CGSize(width:60*0.6,height:80*0.6), point: CGPoint(x:0,y:0))
            self.setPhyBodyColor(size: CGSize(width:60*0.6,height:80*0.6), point: CGPoint(x:0,y:0))
        }
    
    }
}
