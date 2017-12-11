//
//  WDZombieBehavior.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/25.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDZombieBehavior: WDBaseNodeBehavior {

    weak var zombieNode:WDZombieNode! = nil
  
    
    override func moveAction(direction: NSString) {
        
        if zombieNode?.canMove == true {
            let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: zombieNode.speed, node: zombieNode!)
            zombieNode.position = point
            zombieNode.zPosition = 3 * 667 - zombieNode.position.y;
            
            if !direction.isEqual(to: zombieNode.direction as String) || !zombieNode.isMove {
                
                WDAnimationTool.moveAnimation(direction: direction, dic: zombieNode.moveDic,node:zombieNode)
                zombieNode.direction = direction
                zombieNode.isMove = true
            }
        }
    
        
    }
    
    override func attackAction(node: WDBaseNode) {
        
        let personNode:WDPersonNode = node as! WDPersonNode
        WDAnimationTool.zomAttackAnimation(zombieNode: zombieNode, personNode: personNode)
      
    }
    
    func redAttackAction(node: WDBaseNode)  {
        let personNode:WDPersonNode = node as! WDPersonNode
        WDAnimationTool.magicAnimation(zom: zombieNode, person: personNode)
    }
    
    override func beAattackAction(attackNode: WDBaseNode, beAttackNode: WDBaseNode) {
        zombieNode.wdBlood -= attackNode.wdAttack
        if zombieNode.wdBlood <= 0 {
            self.diedAction()
         }
        WDAnimationTool.bloodAnimation(node:beAttackNode)
        if zombieNode.isBoss {
            return
        }
        
        WDAnimationTool.beAttackAnimationForZom(attackNode: attackNode as! WDPersonNode, beAttackNode: beAttackNode as! WDZombieNode)
        
    }
    
    override func stopMoveAction(direction: NSString) {
        
        zombieNode.canMove = false
        zombieNode.direction = direction
        zombieNode.isMove = false
    }
    
    override func diedAction() -> Void {
        
        zombieNode.removeAllActions()
        zombieNode.canMove = false
        zombieNode.physicsBody = nil
        zombieNode.zPosition = 1
        let diedAction = SKAction.animate(with: zombieNode.diedArr as! [SKTexture], timePerFrame: 0.2)
        zombieNode.run(diedAction) {
            self.alreadyDied?(self.zombieNode)
            self.zombieNode.removeFromParent()
        }
    
    }

    
}
