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

    var moveArr:NSMutableArray! = nil
    var attackArr:NSMutableArray! = nil
    var beAttackTexture:SKTexture! = nil
    var behavior:WDKulouBehavior! = nil
    
    
    func setPhy() -> Void {
        
        self.physicsBody?.categoryBitMask = normal_zom;
        self.physicsBody?.contactTestBitMask = player_type;
        self.physicsBody?.collisionBitMask = normal_zom;
        
    }
    
    func removePhy() -> Void {
        self.physicsBody?.categoryBitMask = 0;
        self.physicsBody?.contactTestBitMask = 0;
        self.physicsBody?.collisionBitMask = 0;
    }
    
    func initWithPersonNode(personNode:WDPersonNode) -> Void {
        
        moveArr = NSMutableArray.init()
        diedArr = NSMutableArray.init()
        attackArr = NSMutableArray.init()
        
        
        let textures = SKTextureAtlas.init(named: "kulouPic")
        for index:NSInteger in 0...textures.textureNames.count - 1 {
           
            if index < 4{
                let name = "skull_move_\(index + 1)"
                let temp = textures.textureNamed(name)
                moveArr.add(temp)
    
                let attackName = "kulou_attack_\(index + 1)"
                let temp1 = textures.textureNamed(attackName)
                attackArr.add(temp1)
            }
            
            if index < 5{
                let name = "kulou_died_\(index + 1)"
                let temp = textures.textureNamed(name)
                diedArr.add(temp)
            }
        }
        
        beAttackTexture = textures.textureNamed("kulou_battack")
        
        behavior = WDKulouBehavior.init()
        behavior.kulouNode = self
        
        self.name = "KULOU"
        
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:80,height:80))
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
    
    func setPhysicsBody(isSet:Bool) -> Void {
 
        if isSet {
            self.physicsBody?.categoryBitMask = normal_zom
            self.physicsBody?.contactTestBitMask = player_type
            self.physicsBody?.collisionBitMask = normal_zom
        }else{
            self.physicsBody?.categoryBitMask = 0
            self.physicsBody?.contactTestBitMask = 0
            self.physicsBody?.collisionBitMask = 0
        }
    }
}
