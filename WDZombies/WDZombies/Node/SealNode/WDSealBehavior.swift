//
//  WDSealBehavior.swift
//  WDZombies
//
//  Created by wudong on 2018/1/10.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDSealBehavior: WDBaseNodeBehavior {

    typealias iceAttack = (_ sealNode:WDSealNode) -> Void 
    
    weak var sealNode:WDSealNode!
    
    var iceAttackBlock:iceAttack!
    var iceAttackTime:NSInteger = 0
    
    @objc func iceAttackTimerAction() {
        if sealNode.canMove {
            iceAttackTime += 1
            if iceAttackTime >= 6{
                self.iceAttackBlock(sealNode)
            }
        }
    }
    
    func iceAttackAction(personNode:WDPersonNode) {
      
        let iceNode:SKSpriteNode = SKSpriteNode.init(texture: sealNode.model.iceArr[0])
        iceNode.position = personNode.position
        iceNode.zPosition = 3000
        iceNode.alpha = 0.3
        iceNode.name = SEAl_ICE
        personNode.parent?.addChild(iceNode)
        
        let alphaAction = SKAction.fadeAlpha(to: 1, duration: 0.5)
        iceNode.run(alphaAction) {
            let textureAction = SKAction.animate(with: self.sealNode.model.iceArr, timePerFrame: 0.1)
            self.setIcePhy(iceNode: iceNode)
            iceNode.run(textureAction, completion: {
                iceNode.removeFromParent()
            })
        }
    }
    
    //设置冰块物理属性
    @objc func setIcePhy(iceNode:SKSpriteNode){
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:100,height:100))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        physicsBody.contactTestBitMask = PLAYER_CATEGORY;
        physicsBody.categoryBitMask = 0
        physicsBody.collisionBitMask = 0
        iceNode.physicsBody = physicsBody
    }
    
    @objc func canMove() {
        self.sealNode.canMove = true
    }
    
    //MARK:复写
    override func beAttack(attackNode: WDBaseNode, beAttackNode: WDBaseNode) -> Bool {
        let isBreak = super.beAttack(attackNode: attackNode, beAttackNode: beAttackNode)
        if isBreak {
            sealNode.texture = sealNode.model.diedArr[0]
            self.perform(#selector(canMove), with: nil, afterDelay: 0.5)
        }
        return isBreak
    }
    
    override func setNode(node: WDBaseNode) {
        sealNode = node as! WDSealNode
        attackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(iceAttackTimerAction), userInfo: nil, repeats: true)
    }
    
    override func attack(direction: NSString, nodeDic: NSDictionary) {
        sealNode.removeAction(forKey: "move")
        sealNode.canMove = false
        sealNode.isMove  = false
        let personNode:WDPersonNode = nodeDic.object(forKey: "personNode") as! WDPersonNode
        let textureAction = SKAction.animate(with: sealNode.model.attack1Arr, timePerFrame: 0.1)
        sealNode.run(textureAction) {
            self.iceAttackAction(personNode: personNode)
            self.sealNode.canMove = true
        }
        
    }
    
    
    
}
