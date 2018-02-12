//
//  WDKulouNode.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/11/17.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit
class WDKulouNode: WDBaseNode {

   
    var behavior:WDKulouBehavior! = WDKulouBehavior.init()
    var model:WDKulouModel = WDKulouModel.init()
    var isCall:Bool = false //是否是骷髅骑士召唤出来的
    
    deinit {
        print("骷髅释放了！！")
    }
    
    override func configureModel() {
        model.configureWithZomName(zomName: KULOU_NAME)
    }

    override func clearAction()  {
        self.behavior.clearAction()
    }
    
    
    func initWithPersonNode(personNode:WDPersonNode) -> Void {
        self.setAttribute(isBoss: self.isBoss)

        //设置图片
        self.configureModel()
        nodeModel = model
        
        behavior.setNode(node:self)
        behavior.node = self
        nodeBehavior = behavior
        
        self.name = KULOU_NAME
        
        
       

        
        let x:CGFloat = CGFloat(arc4random() % UInt32(kScreenHeight*2));
        let y:CGFloat = CGFloat(arc4random() % UInt32(kScreenWidth*2));
        
        self.position = CGPoint(x:x, y:y);
        self.zPosition = 3 * 667 - y;
        
        self.direction = kLeft
        self.wdFire_impact = 100
        self.wdAttack = 3
        
        self.experience = 15
       
    }
    
    
    func setAttribute(isBoss:Bool)  {

        if isBoss{
            self.wdBlood = 100
            self.size = CGSize(width:110 ,height:130)
           
            let physicsBody:SKPhysicsBody = model.setUsualPhyBody(size:CGSize(width:80,height:80),point:CGPoint(x:0,y:0))
            self.physicsBody = physicsBody
            
            self.setPhyBodyColor(size:CGSize(width:80,height:80),point:CGPoint(x:0,y:0))

        }else{
            
            self.wdBlood = 20
            self.size = CGSize(width:110 * 0.6,height:130 * 0.6)
            let physicsBody:SKPhysicsBody = model.setUsualPhyBody(size:CGSize(width:80*0.6,height:80*0.6),point:CGPoint(x:0,y:0))
            self.physicsBody = physicsBody
            
            self.setPhyBodyColor(size:CGSize(width:80*0.6,height:80*0.6),point:CGPoint(x:0,y:0))

        }
    }
    
  
    
    func setPhysicsBody(isSet:Bool) -> Void {
        if isSet {
            self.setPhy()
        }else{
            self.removePhy()
        }
    }
    
    func setPhy() -> Void {
        self.physicsBody?.categoryBitMask = KULOU_CATEGORY
        self.physicsBody?.contactTestBitMask = KULOU_CONTACT
        self.physicsBody?.collisionBitMask = KULOU_COLLISION
    }
    
    
    func removePhy() -> Void {
        self.physicsBody?.categoryBitMask = 0;
        self.physicsBody?.contactTestBitMask = 0;
        self.physicsBody?.collisionBitMask = 0;
    }

    
}
