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
        
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:90,height:90))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        
        physicsBody.categoryBitMask = normal_zom;
        physicsBody.contactTestBitMask = player_type;
        physicsBody.collisionBitMask = normal_zom;
        physicsBody.isDynamic = true;
        
        self.physicsBody = physicsBody
        self.direction = kLeft
        self.wdFire_impact = 100
        self.texture = moveArr.object(at: 0) as? SKTexture
        
        self.wdBlood = 100
    }
    
}
