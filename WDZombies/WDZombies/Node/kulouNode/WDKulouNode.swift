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
        
        self.name = KULOU_NAME
        
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:80,height:80))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        
        physicsBody.categoryBitMask = KULOU_CATEGORY;
        physicsBody.contactTestBitMask = KULOU_CONTACT;
        physicsBody.collisionBitMask = KULOU_COLLISION;
        physicsBody.isDynamic = true;
        
        let x:CGFloat = CGFloat(arc4random() % UInt32(kScreenHeight*2));
        let y:CGFloat = CGFloat(arc4random() % UInt32(kScreenWidth*2));
        
        self.position = CGPoint(x:x, y:y);
        self.zPosition = 3 * 667 - y;
        
        self.physicsBody = physicsBody
        self.direction = kLeft
        self.wdFire_impact = 100
        self.wdAttack = 3
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
