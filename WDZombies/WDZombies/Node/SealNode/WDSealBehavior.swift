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
    var isStarAttack:Bool = true
    
    @objc func iceAttackTimerAction() {
        if sealNode.canMove {
            iceAttackTime += 1
            if iceAttackTime >= 5{
                self.iceAttackBlock(sealNode)
                iceAttackTime = 0
            }
        }
    }
    
    func stayAction(){
        if sealNode.canMove {
            sealNode.canMove = false
            sealNode.isMove  = false
            sealNode.removeAllActions()
            let stayAction = SKAction.animate(with: sealNode.model.stayArr, timePerFrame: 0.2)
            sealNode.run(stayAction) {
                self.sealNode.canMove = true
            }
        }
        
    }
    
    func iceAttackAction(personNode:WDPersonNode,point:CGPoint) {
        if sealNode == nil {
            return
        }
        if isStarAttack == false {
            
        }else{
            
            let iceNode:SKSpriteNode = SKSpriteNode.init(texture: sealNode.model.iceArr[0])
            iceNode.position = point
            iceNode.zPosition = 3000
            iceNode.alpha = 0.3
            iceNode.name = SEAl_ICE
            personNode.parent?.addChild(iceNode)
            
            let alphaAction = SKAction.fadeAlpha(to: 1, duration: 0.5)
            iceNode.run(alphaAction) {
                if self.sealNode != nil{
                    let textureAction = SKAction.animate(with: self.sealNode.model.iceArr, timePerFrame: 0.1)
                    self.setIcePhy(iceNode: iceNode)
                    iceNode.run(textureAction, completion: {
                        iceNode.removeFromParent()
                        self.iceAttackAction(personNode: personNode, point: self.randomPosition(personNode: personNode))
                    })
                }
               
            }
        }
    }
    
    func iceAttackActionFromBoss(personNode:WDPersonNode,point:CGPoint) {
     
            let iceNode:SKSpriteNode = SKSpriteNode.init(texture: sealNode.model.iceArr[0])
            iceNode.position = point
            iceNode.zPosition = 3000
            iceNode.alpha = 0.3
            iceNode.name = SEAl_ICE
            personNode.parent?.addChild(iceNode)
            
            let alphaAction = SKAction.fadeAlpha(to: 1, duration: 0.6)
            iceNode.run(alphaAction) {
                if self.sealNode != nil{
                    let textureAction = SKAction.animate(with: self.sealNode.model.iceArr, timePerFrame: 0.1)
                    self.setIcePhy(iceNode: iceNode)
                    iceNode.run(textureAction, completion: {
                        iceNode.removeFromParent()
                    })
                }
               
            }
        
    }
    
    func randomPosition(personNode:WDPersonNode) -> CGPoint{
        var g:CGFloat = CGFloat(arc4random() % 2)
        if g == 0{
            g = -1
        }else{
            g = 1
        }
        
        var a:CGFloat = CGFloat(arc4random() % 2)
        if a == 0{
            a = -1
        }else{
            a = 1
        }
        
        let x:CGFloat = CGFloat(arc4random() % 150)*g + personNode.position.x
        let y:CGFloat = CGFloat(arc4random() % 150)*a + personNode.position.y
        
        return CGPoint(x:x,y:y)
    }
    
    func bossRandomAttackPosition(personNode:WDPersonNode,index:NSInteger,g:NSInteger) -> CGPoint {
         var x:CGFloat = 0
         var y:CGFloat = 0

        //横向
        if g == 0{
            x = -300 + CGFloat(index) * 60 + personNode.position.x
            y = personNode.position.y
         }else if g == 1{
            x = personNode.position.x
            y = -300 + CGFloat(index) * 60 + personNode.position.y
        }else if g == 2{
            x = -300 + CGFloat(index) * 60 + personNode.position.x
            y = -300 + CGFloat(index) * 60 + personNode.position.y
        }else{
            x = -300 + CGFloat(index) * 60 + personNode.position.x
            y =  300 + -CGFloat(index) * 60 + personNode.position.y
        }

        
        //测试
        return CGPoint(x:x,y:y)
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
        sealNode.canMove = true
        self.iceAttackBlock(sealNode)
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
        if sealNode.canMove {
            sealNode.removeAction(forKey: "move")
            iceAttackTime = 0
            sealNode.canMove = false
            sealNode.isMove  = false
            let personNode:WDPersonNode = nodeDic.object(forKey: "personNode") as! WDPersonNode
            let textureAction = SKAction.animate(with: sealNode.model.attack1Arr, timePerFrame: 0.15)
            let g = arc4random() % 4
            sealNode.run(textureAction) {
                for index:NSInteger in 0...10{
                    self.iceAttackActionFromBoss(personNode: personNode, point: self.bossRandomAttackPosition(personNode: personNode, index: index,g: NSInteger(g)))
                }
                self.sealNode.canMove = true
            }
        }
    }
    
    
    
    override func died() {
        super.died()
        isStarAttack = false
    }
    
    
}
