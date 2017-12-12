//
//  WDSmokeKnightNode.swift
//  WDZombies
//
//  Created by wudong on 2017/12/12.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDSmokeKnightNode: WDBaseNode {

    var behavior:WDKnightBehavior!
    var moveArr:NSMutableArray! = nil
    var attack1Arr:NSMutableArray! = nil
    var attack2Arr:NSMutableArray! = nil
    var beAttackTexture:SKTexture! = nil
    
    var link:CADisplayLink!
    var attack2Timer:Timer!
    var attack2Count:NSInteger = 0

    
    typealias move = (_ knightNode:WDSmokeKnightNode) -> Void
    typealias attack2 = (_ knightNode:WDSmokeKnightNode) -> Void
    typealias attack1 = (_ knightNode:WDSmokeKnightNode) -> Void
    typealias died = (_ knightNode:WDSmokeKnightNode) -> Void
    
    var moveAction:move!
    var attack2Action:attack2!
    var attack1Action:attack1!
    var diedAction:died!

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
    
    @objc func attack2ActionTimer()  {
        if self.canMove {
            attack2Count += 1
            if attack2Count >= 6{
                
                let random = arc4random() % 2
                
                if random == 1{
                    attack2Action(self)
                }else{
                    attack2Action(self)
                }
                
                attack2Count = 0
            }
        }
    }
    
    func initWithPersonNode(personNode:WDPersonNode) {
        
        attack2Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(attack2ActionTimer), userInfo: nil, repeats: true)
        
        moveArr = WDMapManager.sharedInstance.textureDic.object(forKey: KNIGHT_MOVE) as! NSMutableArray
        attack1Arr = WDMapManager.sharedInstance.textureDic.object(forKey: KNIGHT_ATTACK1) as! NSMutableArray
        attack2Arr = WDMapManager.sharedInstance.textureDic.object(forKey: KNIGHT_ATTACK2) as! NSMutableArray
        diedArr = WDMapManager.sharedInstance.textureDic.object(forKey: KNIGHT_DIED) as! NSMutableArray
        
        
        behavior = WDKnightBehavior.init()
        behavior.kNight = self
        
        self.name = KNIGHT_NAME
        
        let textures = SKTextureAtlas.init(named: "knightNodePic")
        beAttackTexture = textures.textureNamed("wuqishi_bAttack")
        
        
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
        self.texture = moveArr.object(at: 0) as? SKTexture
        self.position = CGPoint(x:600,y:600)
        self.wdBlood = 50
        
    }
}
