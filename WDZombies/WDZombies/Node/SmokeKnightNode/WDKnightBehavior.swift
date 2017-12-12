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
                
                let moveAction = SKAction.animate(with: kNight.moveArr as! [SKTexture], timePerFrame: 0.2)
                let repeatAction = SKAction.repeatForever(moveAction)
                if bossDirection.isEqual(to: kLeft as String){
                    kNight.xScale = 1
                }else{
                    kNight.xScale = -1
                }
                
                kNight.run(repeatAction, withKey: "move")
                kNight.direction = bossDirection
                kNight.isMove = true
                
            }
        }
    }
    
    func attack1Action(personNode:WDPersonNode){
    }
    
    func attack2Action(personNode:WDPersonNode){
        self.attack2Animation(personNode: personNode)
    }
    
    
//*************************动画相关******************************************//
    //释放黑色漩涡
    func attack1Animation(personNode:WDPersonNode) {
        
        
    }
    
    
    //吸引玩家到当前位置，攻击2
    func attack2Animation(personNode:WDPersonNode) {
        
        if kNight.wdBlood <= 0{
            return
        }
        
        kNight.canMove = false
        kNight.isMove  = false
        
        let action1 = SKAction.animate(with: kNight.attack2Arr as! [SKTexture], timePerFrame: 0.2)
        
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
            })
            
        }
        
    }
    
    @objc func canMove() {
        self.kNight.canMove = true
    }
    
}
