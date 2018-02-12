//
//  WDDogNode.swift
//  WDZombies
//
//  Created by 吴冬 on 2018/1/21.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDDogNode: WDBaseNode {

    
    var behavior:WDDogBehavior = WDDogBehavior.init()
    var model:WDDogModel = WDDogModel.init()
    
    override func configureModel() {
        model.configureWithZomName(zomName: DOG_NAME)
    }
    
    deinit {
        print("狗释放了！！！！")
    }
    
    func initWithPerson(personNode:WDPersonNode) {
        self.configureModel()
        nodeModel = model
        behavior.setNode(node: self)
        behavior.node = self
        nodeBehavior = behavior
        
        self.name = DOG_NAME
        
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
            self.size = CGSize(width:180 ,height:130)
            self.physicsBody = model.setUsualPhyBody(size: CGSize(width:100,height:100), point: CGPoint(x:10,y:-15))
            self.setPhyBodyColor(size: CGSize(width:100,height:100), point: CGPoint(x:10,y:-15))
            
        }else{
            
            self.wdBlood = 20
            self.size = CGSize(width:180 * 0.6,height:130 * 0.6)
            self.physicsBody = model.setUsualPhyBody(size: CGSize(width:100*0.6,height:100*0.6), point: CGPoint(x:10*0.6,y:-15*0.6))
            self.setPhyBodyColor(size: CGSize(width:100*0.6,height:100*0.6), point: CGPoint(x:10*0.6,y:-15*0.6))
        }
    }
}
