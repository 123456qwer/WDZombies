//
//  WDKulouBehavior.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/11/17.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDKulouBehavior: WDBaseNodeBehavior {

    weak var kulouNode:WDKulouNode! = nil

    var blood = 0
    
    override func attackAction(node: WDBaseNode) {
        
        let personNode:WDPersonNode = node as! WDPersonNode
        
        kulouNode.removeAction(forKey: "move")
        kulouNode.canMove = false
        kulouNode.isMove  = false
        
        let attackAction = SKAction.animate(with: kulouNode.attackArr as! [SKTexture], timePerFrame: 0.15)
        kulouNode.run(attackAction) {
            
            if personNode.isBlink == false{
                let distance:CGFloat = WDTool.calculateNodesDistance(point1:self.kulouNode.position,point2:personNode.position)
                
                print(distance)
                
                if distance < 100 {
                    personNode.personBehavior.beAattackAction(attackNode: self.kulouNode, beAttackNode: node)
                }
            }
            
            self.kulouNode.canMove = true
        }
        
    }
    
    override func beAattackAction(attackNode: WDBaseNode, beAttackNode: WDBaseNode) {
        
        kulouNode.wdBlood -= attackNode.wdAttack
        
        blood += 1
        
        if kulouNode.wdBlood <= 0 {
            kulouNode.removePhy()
            self.diedAction()
            return
        }
        
        if blood >= 10 {
            
            
            WDAnimationTool.bloodAnimation(node: self.kulouNode)
            kulouNode.removeAllActions()
            kulouNode.canMove = false
            kulouNode.isMove = false
            blood = 0
            kulouNode.texture = kulouNode.beAttackTexture
            self.perform(#selector(canMove), with: nil, afterDelay: 0.5)
        }
   
    }
    
    @objc func canMove()  {
        kulouNode.canMove = true
    }
    
    override func diedAction() {
        
        kulouNode.removeAllActions()
        
        let diedAction = SKAction.animate(with: kulouNode.diedArr as! [SKTexture], timePerFrame: 0.2)
        kulouNode.run(diedAction) {
            self.kulouNode.removeFromParent()
        }
        
    }
    
    func moveActionForKulou(direction:NSString,personNode:WDPersonNode) -> Void {
        
        if kulouNode.canMove == true {
          
            let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: kulouNode.speed, node: kulouNode)
            kulouNode.position = point
            kulouNode.zPosition = 3 * 667 - kulouNode.position.y;
            let bossDirection = WDTool.calculateDirectionForBoss1(bossPoint: kulouNode.position, personPoint: personNode.position)
            
            if !bossDirection.isEqual(to: kulouNode.direction as String) || !kulouNode.isMove {
                
                kulouNode.removeAction(forKey: "move")
                
                let moveAction = SKAction.animate(with: kulouNode.moveArr as! [SKTexture], timePerFrame: 0.2)
                let repeatAction = SKAction.repeatForever(moveAction)
                if bossDirection.isEqual(to: kLeft as String){
                    kulouNode.xScale = 1
                }else{
                    kulouNode.xScale = -1
                }
                
                kulouNode.run(repeatAction, withKey: "move")
                kulouNode.direction = bossDirection
                kulouNode.isMove = true
                
            }
        }
        
     
    }
}
