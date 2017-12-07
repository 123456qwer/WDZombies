//
//  WDGreenBehavior.swift
//  WDZombies
//
//  Created by wudong on 2017/12/7.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDGreenBehavior: WDBaseNodeBehavior {
    weak var greenZom:WDGreenZomNode! = nil

    func moveActionForGreen(direction:NSString,personNode:WDPersonNode)  {
        
        if greenZom.canMove == true {
            
            let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: greenZom.speed, node: greenZom)
            greenZom.position = point
            greenZom.zPosition = 3 * 667 - greenZom.position.y;
            let bossDirection = WDTool.calculateDirectionForBoss1(bossPoint: greenZom.position, personPoint: personNode.position)
            
            if !bossDirection.isEqual(to: greenZom.direction as String) || !greenZom.isMove {
                
                greenZom.removeAction(forKey: "move")
                
                let moveAction = SKAction.animate(with: greenZom.moveArr as! [SKTexture], timePerFrame: 0.2)
                let repeatAction = SKAction.repeatForever(moveAction)
                if bossDirection.isEqual(to: kLeft as String){
                    greenZom.xScale = 1
                }else{
                    greenZom.xScale = -1
                }
                
                greenZom.run(repeatAction, withKey: "move")
                greenZom.direction = bossDirection
                greenZom.isMove = true
                
            }
        }
    }
    
    
    func attack2Action(personNode:WDPersonNode)  {
        WDAnimationTool.greenAttack2Animation(greenZom: greenZom, personNode: personNode)
    }
    
}
