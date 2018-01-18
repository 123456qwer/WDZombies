//
//  WDOXNode.swift
//  WDZombies
//
//  Created by wudong on 2018/1/4.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit

class WDOXNode: WDBaseNode {
    
    var behavior:WDOXBehavior = WDOXBehavior.init()
    var model:WDOXModel = WDOXModel.init()
    
    deinit {
        print("公牛释放了！！！！")
    }
    
    override func configureModel() {
        model.configureWithZomName(zomName: OX_NAME)
    }
    
    func initWithPerson(personNode:WDPersonNode) {
        self.configureModel()
        nodeModel = model
        behavior.setNode(node: self)
        behavior.node = self
        nodeBehavior = behavior

        self.name = OX_NAME
        
        self.position = model.randomBornPosition()
        self.zPosition = 3 * 667 - self.position.y
        
        self.physicsBody = model.physics()
        self.direction = kLeft
        self.wdFire_impact = 200
        self.wdBlood = 100
        self.wdAttack = 3
        
        self.setAttribute(isBoss: self.isBoss)
        
        //self.addChild(model.phyColorNode())
        
    }
    
    override func clearAction() {
        self.behavior.clearAction()
    }
    
    func setAttribute(isBoss:Bool)  {
        if isBoss{
            self.wdBlood = 100
            self.size = CGSize(width:200 * 0.8 ,height:250 * 0.8)

        }else{
            self.wdBlood = 20
            self.size = CGSize(width:200 * 0.6 ,height:250 * 0.6)

        }
        
    }
    
}
