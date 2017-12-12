//
//  WDBaseNodeBehavior.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDBaseNodeBehavior: NSObject {

    
    typealias diedReturn = (_ node:WDBaseNode) -> Void
  
    var alreadyDied:diedReturn?
    
    func stopMoveAction(direction:NSString) -> Void {}
    func moveAction(direction:NSString) -> Void {}
    func attackAction(node:WDBaseNode) -> Void {}
    func beAattackAction(attackNode:WDBaseNode,beAttackNode:WDBaseNode) -> Void {}
    func diedAction() -> Void {}
    
    
    /// 伤害数值显示
    ///
    /// - Parameters:
    ///   - node:
    ///   - attackNode: 
    func reduceBloodLabel(node:WDBaseNode,attackNode:WDBaseNode)  {
        
        let label:SKLabelNode = SKLabelNode.init(text: "-\(NSInteger(attackNode.wdAttack))")
        label.zPosition = 1000
        label.fontColor = UIColor.red
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.fontName = "Helvetica-Bold"
        label.fontSize = 25
        label.position = CGPoint(x:0,y:0)
        
        let alphaAction = SKAction.fadeAlpha(to: 0, duration: 1)
        let moveAction  = SKAction.moveTo(y: node.frame.size.height, duration: 1)
        let groupAction = SKAction.group([alphaAction,moveAction])
        node.addChild(label)
        label.run(groupAction) {
            label.removeFromParent()
        }
        
    }
    
}
