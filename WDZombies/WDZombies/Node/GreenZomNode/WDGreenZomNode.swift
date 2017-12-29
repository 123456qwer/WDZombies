//
//  WDGreenZomNode.swift
//  WDZombies
//
//  Created by wudong on 2017/12/7.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit


class WDGreenZomNode: WDBaseNode{
    
    var behavior:WDGreenBehavior! = WDGreenBehavior.init()
    var model:WDGreenModel = WDGreenModel.init()

    
    deinit {
        print("绿色僵尸释放了！！！！")
    }
   
    /// 设置基础属性、图片
    override func configureModel(){
        model.configureWithZomName(zomName: GREEN_ZOM_NAME)
    }
 
    override func clearAction()  {
        self.behavior.clearTimer()
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
    
    func initWithPersonNode(personNode:WDPersonNode) -> Void {
        
        self.configureModel()
        nodeModel = model
        
        behavior.setNode(node: self)
        behavior.node = self
        
        
        self.name = GREEN_ZOM_NAME
       
        
        self.position = model.randomBornPosition()
        self.zPosition = 3 * 667 - self.position.y
        
        
        self.physicsBody = model.physics()
        self.direction = kLeft
        self.wdFire_impact = 100
        self.wdBlood = 50
        
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
