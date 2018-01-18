//
//  WDKulouNightBehavior.swift
//  WDZombies
//
//  Created by wudong on 2018/1/5.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import SpriteKit
import UIKit

class WDKulouNightBehavior: WDBaseNodeBehavior {

    typealias attack1 = (_ kulouKnightNode:WDKulouKnightNode) -> Void
    typealias attack2 = (_ kulouKnightNode:WDKulouKnightNode,_ personNode:WDPersonNode) -> Void

    weak var kulouKnightNode:WDKulouKnightNode!
    var callTimeCount:NSInteger = 0
    var callAttackBlock:attack1!
    var callKulouBlock:attack2!
    
    @objc func callKulouTimerAction() {
        if kulouKnightNode.canMove {
            callTimeCount += 1
            if kulouKnightNode.isBoss{
                if callTimeCount == 5{
                    self.callAttackBlock(kulouKnightNode)
                    callTimeCount = 0
                }
            }else{
                if callTimeCount == 8{
                    self.callAttackBlock(kulouKnightNode)
                    callTimeCount = 0
                }
            }
            
        }
    }
 
    @objc func canMove() {
        if self.kulouKnightNode != nil {
            kulouKnightNode.canMove = true
            self.callAttackBlock(kulouKnightNode)
        }
      

    }
    
    //MARK:复写方法
    override func setNode(node: WDBaseNode) {
        kulouKnightNode = node as! WDKulouKnightNode
        attackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callKulouTimerAction), userInfo: nil, repeats: true)
    }
    
    override func attack(direction: NSString, nodeDic: NSDictionary) {
        kulouKnightNode.removeAction(forKey: "move")
        kulouKnightNode.canMove = false
        kulouKnightNode.isMove  = false
        let personNode:WDPersonNode = nodeDic.object(forKey: "personNode") as! WDPersonNode

        let callAction = SKAction.animate(with: kulouKnightNode.model.attack1Arr, timePerFrame: 0.15)
        kulouKnightNode.run(callAction) {
            self.kulouKnightNode.canMove = true
            self.callKulouBlock(self.kulouKnightNode,personNode)
        }
    }
    
    
    override func beAttack(attackNode: WDBaseNode, beAttackNode: WDBaseNode) -> Bool {
        let isBreak = super.beAttack(attackNode: attackNode, beAttackNode: beAttackNode)
        if isBreak{
            self.perform(#selector(canMove), with: nil, afterDelay: 0.5)
        }
        return isBreak
    }
    
}
