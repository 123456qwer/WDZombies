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

    var zombieBehavior:WDZombieBehavior! = nil
    var _zomType:zomType! = nil
    /// 设置物理碰撞
    func setPhy() -> Void {
     
        self.physicsBody?.categoryBitMask = normal_zom;
        self.physicsBody?.contactTestBitMask = player_type;
        self.physicsBody?.collisionBitMask = normal_zom;
        
    }
    
    
    /// 移除物理碰撞
    func removePhy() -> Void {
        self.physicsBody?.categoryBitMask = 0;
        self.physicsBody?.contactTestBitMask = 0;
        self.physicsBody?.collisionBitMask = 0;
    }
    
    func initWithZomType(type:zomType) -> Void {
        
        zombieBehavior = WDZombieBehavior.init()
        zombieBehavior.zombieNode = self
        _zomType = type
        
        if type == .Normal {
            moveDic = WDTool.cutMoveImage(moveImage: UIImage.init(named: "NormalZom.png")!)
            attackDic = WDTool.cutMoveImage(moveImage: UIImage.init(named: "NormalAttack.png")!)
            diedArr   = WDTool.cutCustomImage(image: UIImage.init(named:"NormalDied.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:50))
        }else if type == .Red{
            moveDic = WDTool.cutMoveImage(moveImage: UIImage.init(named: "RedNormalZom.png")!)
            attackDic = WDTool.cutMoveImage(moveImage: UIImage.init(named: "RedNormalAttack.png")!)
            diedArr   = WDTool.cutCustomImage(image: UIImage.init(named:"RedNormalDied.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:50))
        }
        
       
      
        direction = kLeft
        
        
        let x:CGFloat = CGFloat(arc4random() % UInt32(kScreenHeight*2));
        let y:CGFloat = CGFloat(arc4random() % UInt32(kScreenWidth*2));
        
        self.position = CGPoint(x:x, y:y);
        self.zPosition = 3 * 667 - y;
        
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:20,height:20))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        
        physicsBody.categoryBitMask = normal_zom;
        physicsBody.contactTestBitMask = player_type;
        physicsBody.collisionBitMask = normal_zom;
        physicsBody.isDynamic = true;
        
        self.physicsBody = physicsBody
        self.name = ZOMBIE as String
        self.wdFire_impact = 30
        
        self.attribute()
    }
    
    
    //属性
    func attribute() -> Void {
        
        if _zomType == .Normal {
            self.wdBlood = 5
            self.speed = 1
        }else if _zomType == .Red{
            self.wdBlood = 10
            self.speed = 2
        }
        
    }
    
    
}
