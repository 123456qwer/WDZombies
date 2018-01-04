//
//  WDOXBehavior.swift
//  WDZombies
//
//  Created by wudong on 2018/1/4.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDOXBehavior: WDBaseNodeBehavior {

    weak var oxNode:WDOXNode!
    var isAttack:Bool = false
    var isAttackIng:Bool = false
    
    
    //MARK:复写方法
    override func attack(direction: NSString, nodeDic: NSDictionary) {
        
        if isAttackIng {
            let personNode:WDPersonNode = nodeDic.object(forKey: "personNode") as! WDPersonNode
            WDAnimationTool.bloodAnimation(node:personNode)
            personNode.personBehavior.reduceBlood(number:1)
            return
        }
        
        if isAttack {
            return
        }
        
        isAttack = true
        
        oxNode.canMove = false
        oxNode.isMove  = false
        
        //8张
        let stayA = SKAction.animate(with: oxNode.model.stayArr, timePerFrame: 0.1)
        let rep = SKAction.repeat(stayA, count: 3)
        
        oxNode.run(rep) {
            let x:CGFloat = self.oxNode.position.x - 300 * self.oxNode.xScale  
            let point = CGPoint(x:x,y:self.oxNode.position.y)
            let attackA = SKAction.animate(with: self.oxNode.model.moveArr, timePerFrame: 0.1)
            let move    = SKAction.move(to: point, duration: 0.1 * 6)
            let group = SKAction.group([attackA,move])
            self.isAttackIng = true
            self.oxNode.run(group, completion: {
                self.oxNode.canMove = true
                self.isAttack = false
                self.isAttackIng = false

            })
        }
        
        
    }
    
    override func setNode(node: WDBaseNode) {
        oxNode = node as! WDOXNode
    }
    
    
    override func move(direction: NSString, nodeDic: NSDictionary) {
        if node.wdBlood <= 0 {
            self.node.canMove = false
            self.clearAction()
            return
        }
        
        if node.canMove == true {
            
            let personNode:WDPersonNode = nodeDic.object(forKey: "personNode") as! WDPersonNode
            let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: 2, node: node)
            node.position = point
            node.zPosition = 3 * 667 - node.position.y;
            let bossDirection = WDTool.calculateDirectionForBoss1(bossPoint: node.position, personPoint: personNode.position)
            
            if !bossDirection.isEqual(to: node.direction as String) || !node.isMove {
                
                node.removeAction(forKey: "move")
                let moveAction = SKAction.animate(with: oxNode.model.moveArr, timePerFrame: 0.1)
                let repeatAction = SKAction.repeatForever(moveAction)
                if bossDirection.isEqual(to: kLeft as String){
                    node.xScale = xScale
                    node.yScale = yScale
                }else{
                    node.xScale = -1 * xScale
                    node.yScale = yScale
                }
                
                node.run(repeatAction, withKey: "move")
                node.direction = bossDirection
                node.isMove = true
            }
        }
    }
 
}
