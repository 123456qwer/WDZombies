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
    
    var behavior:WDGreenBehavior! = nil
    var model:WDGreenModel = WDGreenModel.init()
    
    var link:CADisplayLink!
    
    typealias move = (_ greenNode:WDGreenZomNode) -> Void
    typealias attack2 = (_ greenNode:WDGreenZomNode) -> Void
    typealias attack1 = (_ greenNode:WDGreenZomNode) -> Void
    typealias died = (_ greenNode:WDGreenZomNode) -> Void

    var moveAction:move!
    var attack2Action:attack2!
    var attack1Action:attack1!
    var attack2Timer:Timer!
    var attack2Count:NSInteger = 0
    var diedAction:died!
    
    deinit {
        print("绿色僵尸释放了！！！！")
    }
    
    
   
    /// 设置基础属性、图片
    override func configureModel(){
        model.configureWithZomName(zomName: GREEN_ZOM_NAME)
    }
   
    func starMove()  {
        link = CADisplayLink.init(target: self, selector: #selector(linkMove))
        link.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func removeLink()  {
        if link != nil{
            link.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
            link.invalidate()
            link = nil
        }
    }
    
    func removeTimer()  {
        if attack2Timer != nil {
            attack2Timer.invalidate()
            attack2Timer = nil
        }
    }
    
    func clearAction()  {
        
        self.behavior = nil
        self.removeLink()
        self.removeTimer()
    }
    
    @objc func linkMove()  {
        if self.wdBlood <= 0 {
            self.removeLink()
            return
        }
        
        moveAction(self)
    }
    
    @objc func attack2ActionTimer()  {
        if self.canMove {
            attack2Count += 1
            if attack2Count >= 6{
                
                let random = arc4random() % 2
                
                if random == 1{
                    attack1Action(self)
                }else{
                    attack2Action(self)
                }
            
                attack2Count = 0
            }
        }
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
        
        attack2Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(attack2ActionTimer), userInfo: nil, repeats: true)

    
        
        behavior = WDGreenBehavior.init()
        behavior.greenZom = self
        
        self.name = GREEN_ZOM_NAME
        
        
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:40,height:40))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        
        physicsBody.categoryBitMask = GREEN_ZOM_CATEGORY;
        physicsBody.contactTestBitMask = GREEN_ZOM_CONTACT;
        physicsBody.collisionBitMask = GREEN_ZOM_COLLISION;
        physicsBody.isDynamic = true;
        
        let x:CGFloat = CGFloat(arc4random() % UInt32(kScreenHeight*2));
        let y:CGFloat = CGFloat(arc4random() % UInt32(kScreenWidth*2));
        
        self.position = CGPoint(x:x, y:y);
        self.zPosition = 3 * 667 - y;
        
        self.physicsBody = physicsBody
        self.direction = kLeft
        self.wdFire_impact = 100
        self.position = CGPoint(x:600,y:600)
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
