//
//  WDZombieNode.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/25.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit
class WDZombieNode: WDBaseNode {

    var behavior:WDZombieBehavior! = nil
    var _zomType:zomType! = nil
    var link:CADisplayLink!
    typealias move = (_ zom:WDZombieNode) -> Void
    typealias died = () -> Void
    typealias redAttack = (_ zom:WDZombieNode) -> Void
    
    var redZomAttackCount:NSInteger = 0
    var redZomTimer:Timer!
    var moveAction:move!
    var redAttackAction:redAttack!
    
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
        if redZomTimer != nil {
            redZomTimer.invalidate()
            redZomTimer = nil
        }
    }
    
    func diedA()  {
        self.clearAction()
    }
    
    override func clearAction()  {
        
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
    
    /// 设置物理碰撞
    func setPhy() -> Void {
        self.physicsBody?.categoryBitMask = NORMAL_ZOM_CATEGORY;
        self.physicsBody?.contactTestBitMask = NORMAL_ZOM_CONTACT;
        self.physicsBody?.collisionBitMask = NORMAL_ZOM_COLLISION;
    }
    
    deinit {
        WDLog(item: "怪物node释放了！！！！！！！！！！！！！！！！！！！！！！！！！")
    }
    
    
    /// 移除物理碰撞
    func removePhy() -> Void {
        self.physicsBody?.categoryBitMask = 0;
        self.physicsBody?.contactTestBitMask = 0;
        self.physicsBody?.collisionBitMask = 0;
    }
    
    //远距离攻击，5秒出发一次
    @objc func redMoveTime()  {
      
        if self.canMove {
            redZomAttackCount += 1
            if redZomAttackCount >= 5{
                redAttackAction(self)
                redZomAttackCount = 0
            }
        }
    }
    
    func initWithZomType(type:zomType) -> Void {
        
        behavior = WDZombieBehavior.init()
        behavior.zombieNode = self
        _zomType = type
        
        if type == .Normal {
            moveDic = WDMapManager.sharedInstance.textureDic.object(forKey: "normalZomMove") as! NSMutableDictionary
            attackDic = WDMapManager.sharedInstance.textureDic.object(forKey: "normalZomAttack") as! NSMutableDictionary
            diedArr   = WDMapManager.sharedInstance.textureDic.object(forKey: "normalZomDied") as! NSMutableArray
            self.name = NORMAL_ZOM

        }else if type == .Red{
            moveDic = WDMapManager.sharedInstance.textureDic.object(forKey: "redNormalZomMove") as! NSMutableDictionary
            attackDic = WDMapManager.sharedInstance.textureDic.object(forKey: "redNormalZomAttack") as! NSMutableDictionary
            diedArr   = WDMapManager.sharedInstance.textureDic.object(forKey: "redNormalZomDied") as! NSMutableArray
            redZomTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(redMoveTime), userInfo: nil, repeats: true)
            self.name = RED_ZOM

        }
        
       
      
        direction = kLeft
        
        
        let x:CGFloat = CGFloat(arc4random() % UInt32(kScreenHeight*2));
        let y:CGFloat = CGFloat(arc4random() % UInt32(kScreenWidth*2));
        
        self.position = CGPoint(x:x, y:y);
        self.zPosition = 3 * 667 - y;
        
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:20,height:20))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        
        physicsBody.categoryBitMask = NORMAL_ZOM_CATEGORY;
        physicsBody.contactTestBitMask = NORMAL_ZOM_CONTACT;
        physicsBody.collisionBitMask = NORMAL_ZOM_COLLISION;
        physicsBody.isDynamic = true;
        
        self.physicsBody = physicsBody
        self.wdFire_impact = 30
        
        self.attribute(isBoss: isBoss)
    }
    
    func bossPhy(){
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:40,height:40))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        
        physicsBody.categoryBitMask = NORMAL_ZOM_CATEGORY;
        physicsBody.contactTestBitMask = NORMAL_ZOM_CONTACT;
        physicsBody.collisionBitMask = NORMAL_ZOM_COLLISION;
        physicsBody.isDynamic = true;
        
        self.physicsBody = physicsBody
    }
    

    
    //属性
    func attribute(isBoss:Bool) -> Void {
        
        if _zomType == .Normal {
            self.wdBlood = 5
            self.speed = 1
            self.experience = 5
        }else if _zomType == .Red{
            self.wdBlood = 10
            self.speed = 2
            self.experience = 10
        }
        
        if isBoss {
            self.wdBlood = 100
            self.xScale = 1.5
            self.yScale = 1.5
            self.bossPhy()
        }
    }
    
    
}
