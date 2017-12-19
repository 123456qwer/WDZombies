//
//  WDKnightBehavior.swift
//  WDZombies
//
//  Created by wudong on 2017/12/12.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDKnightBehavior: WDBaseNodeBehavior {
    weak var kNight:WDSmokeKnightNode!
    var blood = 0
    
    func moveActionForKnight(direction:NSString,personNode:WDPersonNode)  {
        
        if kNight.canMove == true {
            
            let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: kNight.speed, node: kNight)
            kNight.position = point
            kNight.zPosition = 3 * 667 - kNight.position.y;
            let bossDirection = WDTool.calculateDirectionForBoss1(bossPoint: kNight.position, personPoint: personNode.position)
            
            if !bossDirection.isEqual(to: kNight.direction as String) || !kNight.isMove {
                
                kNight.removeAction(forKey: "move")
                
                let moveAction = SKAction.animate(with: kNight.model.moveArr, timePerFrame: 0.2)
                let repeatAction = SKAction.repeatForever(moveAction)
                if bossDirection.isEqual(to: kLeft as String){
                    kNight.xScale = xScale
                    kNight.yScale = yScale
                }else{
                    kNight.xScale = -1 * xScale
                    kNight.yScale = yScale
                }
                
                kNight.run(repeatAction, withKey: "move")
                kNight.direction = bossDirection
                kNight.isMove = true
                
            }
        }
    }
    
    
    func attack1Action(personNode:WDPersonNode){
        self.attack1Animation(personNode: personNode)
    }
    
    func attack2Action(personNode:WDPersonNode){
        self.attack2Animation(personNode: personNode)
    }
    
    override func beAattackAction(attackNode: WDBaseNode, beAttackNode: WDBaseNode) {
        kNight.wdBlood -= attackNode.wdAttack
        blood += NSInteger(attackNode.wdAttack)
        
        self.reduceBloodLabel(node: kNight, attackNode: attackNode)
        
        if kNight.wdBlood <= 0 {
            self.diedAction()
            kNight.diedAction(kNight)
            kNight.setPhysicsBody(isSet: false)
            return
        }
        
        if blood >= 10 && kNight.canMove == true{
            
            kNight.removeAllActions()
            kNight.canMove = false
            kNight.isMove = false
            kNight.setPhysicsBody(isSet: false)
            blood = 0
            kNight.texture = kNight.model.beAttackTexture
            self.perform(#selector(moveTexture), with: nil, afterDelay: 0.5)
            
            let action1 = SKAction.fadeAlpha(to: 0, duration: 0.5)
            let action2 = SKAction.move(to: attackNode.position, duration: 0.5)
            let action3 = SKAction.fadeAlpha(to: 1, duration: 0.3)
            
            let seq = SKAction.sequence([action1,action2,action3])
            kNight.run(seq, completion: {
                
                self.kNight.canMove = true
                self.kNight.setPhysicsBody(isSet: true)
            })
            
        }
    }
    
    @objc func moveTexture() {
        kNight.texture = kNight.model.moveArr[0]
    }
    
//*************************动画相关******************************************//
    //释放黑色漩涡
    func attack1Animation(personNode:WDPersonNode) {
       
        if kNight.wdBlood <= 0 || kNight.canMove == false{
            return
        }
        
        kNight.canMove = false
        kNight.isMove  = false
        
        let action1 = SKAction.animate(with: kNight.model.attack1Arr, timePerFrame: 0.2)
        self.perform(#selector(attackPerson(personNode:)), with: personNode, afterDelay: 0.2 * 3)
        
        kNight.run(action1) {
            self.kNight.canMove = true
        }
    }
    
    
    @objc func attackPerson(personNode:WDPersonNode)  {
        let distance:CGFloat = WDTool.calculateNodesDistance(point1: self.kNight.position, point2: personNode.position)
        let dis = personNode.size.width / 2.0 + self.kNight.size.width / 2.0
        print(dis,distance)
        
        if distance < dis {
            personNode.personBehavior.beAattackAction(attackNode: self.kNight, beAttackNode: personNode)
        }
    }
    
    //吸引玩家到当前位置，攻击2
    func attack2Animation(personNode:WDPersonNode) {
        
        if kNight.wdBlood <= 0 || kNight.canMove == false{
            return
        }
        
        kNight.canMove = false
        kNight.isMove  = false
        
        let action1 = SKAction.animate(with: kNight.model.attack2Arr, timePerFrame: 0.2)
        
        kNight.run(action1) {
            
            var temp:CGFloat = 50
            if self.kNight.direction.isEqual(to: kLeft as String){
                temp = -50
            }else{
                temp = 50
            }
            
            let point = CGPoint(x:self.kNight.position.x + temp,y:self.kNight.position.y)
            let distance:CGFloat = WDTool.calculateNodesDistance(point1: point, point2: personNode.position)
            
            let action2 = SKAction.move(to: point, duration: TimeInterval(distance / 400))
            
            personNode.canMove = false
            personNode.isMove  = false
            
            self.perform(#selector(self.canMove), with: nil, afterDelay: TimeInterval(distance / 400.0))
            
            personNode.run(action2, completion: {
                personNode.canMove = true
                self.attack1Animation(personNode: personNode)
            })
            
        }
        
    }
    
    @objc func canMove() {
        self.kNight.canMove = true
    }
    
    override func diedAction() {
        
        kNight.removeAllActions()
        
        let diedAction = SKAction.animate(with: kNight.diedArr as! [SKTexture], timePerFrame: 0.2)
        kNight.run(diedAction) {
            self.kNight.removeFromParent()
        }
        
    }
    
}
