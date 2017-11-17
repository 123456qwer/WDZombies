//
//  WDBossNode_1.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/11/13.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDBossNode_1: WDBaseNode {

    var bossBehavior:WDBossBehavior_1! = nil
    var shadowNode:SKSpriteNode! = nil
    
    func dicAction(mDic:NSMutableDictionary,picName:NSString,line:NSInteger,arrange:NSInteger,size:CGSize) {
        let arr:NSMutableArray = WDTool.cutCustomImage(image: UIImage.init(named: picName as String)!, line: line, arrange: arrange, size: size)
        
        let arr2:NSMutableArray = NSMutableArray.init()
        for _:NSInteger in 0...1 {
            let arr3:NSMutableArray = NSMutableArray.init()
            arr2.add(arr3)
        }
        
        
        for index:NSInteger in 0...arr.count - 1 {
            
            let texture:SKTexture = arr.object(at: index) as! SKTexture
            
            if index < arrange{
                let arr_p:NSMutableArray = arr2.object(at: 0) as! NSMutableArray
                arr_p.add(texture)
            }else{
                let arr_p:NSMutableArray = arr2.object(at: 1) as! NSMutableArray
                arr_p.add(texture)
            }
            
        }
        
        for index:NSInteger in 0...arr2.count - 1 {
            if index == 0{
                mDic.setObject(arr2.object(at: index), forKey: kRight)
            }else{
                mDic.setObject(arr2.object(at: index), forKey: kLeft)
            }
        }
    }
    
    func initWithPersonNode(personNode:WDPersonNode) -> Void {
        
        bossBehavior = WDBossBehavior_1.init()
        bossBehavior.bossNode = self
        moveDic = NSMutableDictionary.init()
        attackDic = NSMutableDictionary.init()
        self.direction = kLeft
        
        self.dicAction(mDic: moveDic, picName: "BOSS1_move", line: 2, arrange: 5, size: CGSize(width:183,height:174))
        self.dicAction(mDic: attackDic, picName: "BOSS1_attack", line: 2, arrange: 4, size: CGSize(width:235,height:190))
        
        let leftArr:NSMutableArray = self.attackDic.object(forKey: kLeft) as! NSMutableArray
        leftArr.removeObject(at: 0)
        let rightArr:NSMutableArray = self.attackDic.object(forKey: kRight) as! NSMutableArray
        rightArr.removeObject(at: 0)
        
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:150,height:150))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        
        physicsBody.categoryBitMask = normal_zom;
        physicsBody.contactTestBitMask = player_type;
        physicsBody.collisionBitMask = normal_zom;
        physicsBody.isDynamic = true;
        
        self.physicsBody = physicsBody
        self.name = BOSS1 as String
        self.wdFire_impact = 100
        
        shadowNode = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "boss1_attLeft")!))
        shadowNode.alpha = 0
        shadowNode.zPosition = 100
        self.addChild(shadowNode)
    }
    
}
