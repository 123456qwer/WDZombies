//
//  WDSealNode.swift
//  WDZombies
//
//  Created by wudong on 2018/1/10.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit

class WDSealNode: WDBaseNode {

    
    var behavior:WDSealBehavior = WDSealBehavior.init()
    var model:WDSealModel = WDSealModel.init()
    
    override func configureModel() {
        model.configureWithZomName(zomName: SEAL_NAME)
    }
    
    deinit {
        WDLog(item: "海豹释放了！！！！")
    }
    
    func initWithPerson(personNode:WDPersonNode) {
        self.configureModel()
        nodeModel = model
        behavior.setNode(node: self)
        behavior.node = self
        nodeBehavior = behavior

        self.name = SEAL_NAME
        
        self.position = model.randomBornPosition()
        self.zPosition = 3 * 667 - self.position.y
        
        self.direction = kLeft
        self.wdFire_impact = 200
        self.wdBlood = 100
        self.wdAttack = 3
        self.experience = 45
        
        self.setAttribute(isBoss: self.isBoss)
    }
    
    override func clearAction() {
        self.behavior.clearAction()
    }
    
    func setAttribute(isBoss:Bool)  {
        if isBoss{
            self.wdBlood = 100
            self.size = CGSize(width:130 ,height:150)
            self.physicsBody = model.setUsualPhyBody(size: CGSize(width:90,height:90), point: CGPoint(x:0,y:-20))
            self.setPhyBodyColor(size: CGSize(width:90,height:90), point: CGPoint(x:0,y:-20))
        }else{
            self.wdBlood = 20
            self.size = CGSize(width:130 * 0.6,height:150 * 0.6)
            self.physicsBody = model.setUsualPhyBody(size: CGSize(width:90*0.6,height:90*0.6), point: CGPoint(x:0,y:-20*0.6))
            self.setPhyBodyColor(size: CGSize(width:90*0.6,height:90*0.6), point: CGPoint(x:0,y:-20*0.6))
        }
    }
}
