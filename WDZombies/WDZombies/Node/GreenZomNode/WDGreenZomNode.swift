//
//  WDGreenZomNode.swift
//  WDZombies
//
//  Created by wudong on 2017/12/7.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDGreenZomNode: WDBaseNode {
    var moveArr:NSMutableArray! = nil
    var attack1Arr:NSMutableArray! = nil
    var attack2Arr:NSMutableArray! = nil
    var beAttackTexture:SKTexture! = nil
    var behavior:WDGreenBehavior! = nil
    var smokeArr:NSMutableArray!
    var isBoss:Bool!

    
    
    var link:CADisplayLink!
    
    typealias move = (_ greenNode:WDGreenZomNode) -> Void
    typealias attack2 = (_ greenNode:WDGreenZomNode) -> Void

    var moveAction:move!
    var attack2Action:attack2!
    var attack2Timer:Timer!
    var attack2Count:NSInteger = 0
    
    func starMove()  {
        link = CADisplayLink.init(target: self, selector: #selector(linkMove))
        link.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func removeLink()  {
        link.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
        link.invalidate()
        link = nil
    }
    
    func removeTimer()  {
        if attack2Timer != nil {
            attack2Timer.invalidate()
            attack2Timer = nil
        }
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
            if attack2Count >= 5{
                attack2Action(self)
                attack2Count = 0
            }
        }
       
    }
    
    func initWithPersonNode(personNode:WDPersonNode) -> Void {
        
        attack2Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(attack2ActionTimer), userInfo: nil, repeats: true)
        
        moveArr = WDMapManager.sharedInstance.textureDic.object(forKey: GREEN_MOVE) as! NSMutableArray
        diedArr = WDMapManager.sharedInstance.textureDic.object(forKey: GREEN_DIED) as! NSMutableArray
        attack1Arr = WDMapManager.sharedInstance.textureDic.object(forKey: GREEN_ATTACK1) as! NSMutableArray
        attack2Arr = WDMapManager.sharedInstance.textureDic.object(forKey: GREEN_ATTACK2) as! NSMutableArray
        smokeArr = WDMapManager.sharedInstance.textureDic.object(forKey: GREEN_SMOKE) as! NSMutableArray
        
        let textures = SKTextureAtlas.init(named: "greenZomPic")
     
        
        beAttackTexture = textures.textureNamed("green_bAttack")
        
        behavior = WDGreenBehavior.init()
        behavior.greenZom = self
        
        self.name = "GREEN_ZOM"
        
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:40,height:40))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        
        physicsBody.categoryBitMask = normal_zom;
        physicsBody.contactTestBitMask = player_type;
        physicsBody.collisionBitMask = normal_zom;
        physicsBody.isDynamic = true;
        
        let x:CGFloat = CGFloat(arc4random() % UInt32(kScreenHeight*2));
        let y:CGFloat = CGFloat(arc4random() % UInt32(kScreenWidth*2));
        
        self.position = CGPoint(x:x, y:y);
        self.zPosition = 3 * 667 - y;
        
        self.physicsBody = physicsBody
        self.direction = kLeft
        self.wdFire_impact = 100
        self.texture = moveArr.object(at: 0) as? SKTexture
        self.position = CGPoint(x:600,y:600)
        self.wdBlood = 100
    }
}
