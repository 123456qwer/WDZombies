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

   
    var behavior:WDKulouBehavior! = nil
    var link:CADisplayLink!
    var model:WDKulouModel = WDKulouModel.init()
    var timer:Timer! = nil
    
    typealias move = (_ kulou:WDKulouNode) -> Void
    typealias attack2Action = (_ kulou:WDKulouNode) -> Void
    
    var attack2:attack2Action!
    var moveAction:move!
    var timerCount:NSInteger = 0
    
    deinit {
        print("骷髅释放了！！")
    }
    
    override func configureModel() {
        model.configureWithZomName(zomName: KULOU_NAME)
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
    
    func removeTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    @objc func linkMove()  {
        if self.wdBlood <= 0 {
            self.removeLink()
            return
        }
        
        moveAction(self)
    }
    
    override func clearAction()  {
        
        self.removeLink()
        self.removeTimer()
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
    
    
    @objc func attack2A() {
        if self.canMove {
            if self.wdBlood <= 0{
                self.removeTimer()
                return
            }
            timerCount += 1
            if timerCount == 5{
                self.attack2(self)
                timerCount = 0
            }
        }
    }
    
    func initWithPersonNode(personNode:WDPersonNode) -> Void {
        
        self.configureModel()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(attack2A), userInfo: nil, repeats: true)
        
        behavior = WDKulouBehavior.init()
        behavior.kulouNode = self
        
        self.name = "KULOU"
        
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
        self.wdBlood = 20
        self.wdAttack = 3
        
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
    
    func setPhysicsBody(isSet:Bool) -> Void {
 
        if isSet {
            self.setPhy()
        }else{
            self.removePhy()
        }
    }
}
