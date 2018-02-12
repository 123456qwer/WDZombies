//
//  WDKulouKnightNode.swift
//  WDZombies
//
//  Created by wudong on 2018/1/5.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit

class WDKulouKnightNode: WDBaseNode {

    var behavior:WDKulouNightBehavior = WDKulouNightBehavior.init()
    var model:WDKulouNightModel = WDKulouNightModel.init()
    
    override func configureModel() {
        model.configureWithZomName(zomName: KULOU_KNIGHT_NAME)
    }
    
    deinit {
        print("骷髅骑士释放了！！！！")
    }
    
    func initWithPerson(personNode:WDPersonNode) {
        self.configureModel()
        nodeModel = model
        behavior.setNode(node: self)
        behavior.node = self
        nodeBehavior = behavior

        self.name = KULOU_KNIGHT_NAME
        
        self.position = model.randomBornPosition()
        self.zPosition = 3 * 667 - self.position.y
        
        self.direction = kLeft
        self.wdFire_impact = 200
        self.wdBlood = 100
        self.wdAttack = 3
        self.experience = 40
        self.setAttribute(isBoss: self.isBoss)
    }
    
    override func clearAction() {
        self.behavior.clearAction()
    }
    
    func setAttribute(isBoss:Bool)  {
        if isBoss{
            self.wdBlood = 100
            self.size = CGSize(width:170 * 0.8,height:170 * 0.8)
            self.physicsBody = model.setUsualPhyBody(size: CGSize(width:100,height:110), point: CGPoint(x:0,y:-10))
            self.setPhyBodyColor(size: CGSize(width:100,height:110), point: CGPoint(x:0,y:-10))
            
        }else{
            self.wdBlood = 10
            self.size = CGSize(width:170 * 0.6,height:170 * 0.6)
            self.physicsBody = model.setUsualPhyBody(size: CGSize(width:100 * 0.6,height:110 * 0.6), point: CGPoint(x:0,y:-10))
            self.setPhyBodyColor(size: CGSize(width:100 * 0.6,height:110 * 0.6), point: CGPoint(x:0,y:-10))
        }
    }
    
    
}
