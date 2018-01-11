//
//  WDPhyContactModel.swift
//  WDZombies
//
//  Created by wudong on 2018/1/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit
class WDPhyContactModel: NSObject {

    static func phyContactAction(contact: SKPhysicsContact) -> SKSpriteNode{
        
        let A:SKSpriteNode = contact.bodyA.node as! SKSpriteNode;
        let B:SKSpriteNode = contact.bodyB.node as! SKSpriteNode;
        var node:SKSpriteNode!
        
        if (A.name?.isEqual(KULOU_KNIGHT_NAME))! {
            node = A
        }
        
        if (B.name?.isEqual(KULOU_KNIGHT_NAME))! {
            node = B
        }
        
        return node
    }
    
}
