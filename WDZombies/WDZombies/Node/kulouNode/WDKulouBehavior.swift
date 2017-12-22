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

    @objc func hitTheTarget(personNode:WDPersonNode)  {
        if personNode.isBlink == false && kulouNode != nil{
            let distance:CGFloat = WDTool.calculateNodesDistance(point1:self.kulouNode.position,point2:personNode.position)
            
            let dis = personNode.size.width / 2.0 + kulouNode.size.width / 2.0
            print(dis,distance)
            
            if distance < dis {
                personNode.personBehavior.beAattackAction(attackNode: self.kulouNode, beAttackNode: personNode)
            }
        }
    }
    
    
    override func attackAction(node: WDBaseNode) {
        
        kulouNode.removeAction(forKey: "move")
        kulouNode.canMove = false
        kulouNode.isMove  = false
        
        let attackAction = SKAction.animate(with: kulouNode.model.attack1Arr, timePerFrame: 0.15)

   
        self.perform(#selector(hitTheTarget(personNode:)), with: node, afterDelay: 0.25)
        kulouNode.run(attackAction) {
        
            self.kulouNode.canMove = true
        }
    }
    
    func attack2Action(personNode:WDPersonNode) {
        
        kulouNode.canMove = false
        kulouNode.alpha = 0.5
        var page:CGFloat = 80 / 2.0 + 20 / 2.0
        if kulouNode.position.x < personNode.position.x {
            page *= -1
        }
        
        let position = CGPoint(x:personNode.position.x + page,y:personNode.position.y)
        
        let moveA = SKAction.move(to: position, duration: 0.5)
        kulouNode.removePhy()
        self.perform(#selector(setPhy), with: nil, afterDelay: 0.7)
        kulouNode.run(moveA) {
            self.kulouNode.canMove = true
            self.kulouNode.alpha = 1
        }
        
    }
    
    @objc func setPhy()  {
        if kulouNode != nil{
            kulouNode.setPhy()
        }
    }
    
    override func beAattackAction(attackNode: WDBaseNode, beAttackNode: WDBaseNode) {
        
        kulouNode.wdBlood -= attackNode.wdAttack
        blood += NSInteger(attackNode.wdAttack)
        
        
        self.reduceBloodLabel(node: kulouNode, attackNode: attackNode)
        
        if kulouNode.wdBlood <= 0 {
            self.diedAction()
            kulouNode.setPhysicsBody(isSet: false)
            return
        }
        
        if blood >= 10 && kulouNode.canMove == true{
            
            kulouNode.removeAllActions()
            kulouNode.canMove = false
            kulouNode.isMove = false
            blood = 0
            kulouNode.texture = kulouNode.model.beAttackTexture
            self.perform(#selector(canMove), with: nil, afterDelay: 0.5)
        }
   
    }
    
    
    @objc func canMove()  {
        if kulouNode != nil {
            kulouNode.canMove = true
            kulouNode.timerCount = 0
            kulouNode.texture = kulouNode.model.moveArr[0]
            kulouNode.attack2(kulouNode)
        }
       
    }
    
    override func diedAction() {
        
        kulouNode.removeAllActions()
        
        let diedAction = SKAction.animate(with: kulouNode.model.diedArr , timePerFrame: 0.2)
        kulouNode.run(diedAction) {
            self.alreadyDied?(self.kulouNode)
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
                
                let moveAction = SKAction.animate(with: kulouNode.model.moveArr, timePerFrame: 0.2)
                let repeatAction = SKAction.repeatForever(moveAction)
                if bossDirection.isEqual(to: kLeft as String){
                    kulouNode.xScale = xScale
                    kulouNode.yScale = yScale
                }else{
                    kulouNode.xScale = -1 * xScale
                    kulouNode.yScale = yScale
                }
                
                kulouNode.run(repeatAction, withKey: "move")
                kulouNode.direction = bossDirection
                kulouNode.isMove = true
                
            }
        }
        
     
    }
}
