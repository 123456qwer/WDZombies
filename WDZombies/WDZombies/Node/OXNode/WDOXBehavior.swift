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
    
    typealias attack1 = (_ oxNode:WDOXNode) -> Void
    var lightingAttackBlock:attack1!
    var attackTimeCount:NSInteger = 0

    
    func lightingAttack(personNode:WDPersonNode){
        oxNode.canMove = false
        oxNode.isMove  = false
        
        let attackA = SKAction.animate(with: oxNode.model.attack1Arr, timePerFrame: 0.15)
        oxNode.run(attackA) {
            self.oxNode.canMove = true
            self.lightAttack(personNode:personNode)
        }
    }
    
    func lightAttack(personNode:WDPersonNode){
        let lightNode:SKSpriteNode = SKSpriteNode.init(texture: oxNode.model.lightArr[0])
        lightNode.position = personNode.position
        lightNode.zPosition = 4000
        lightNode.alpha = 0
        lightNode.name = OX_LIGHT
        personNode.parent?.addChild(lightNode)
        let alphaA = SKAction.fadeAlpha(to: 1, duration: 0.5)
        lightNode.run(alphaA) {
            self.setLightPhy(light: lightNode)
            let lightA = SKAction.animate(with: self.oxNode.model.lightArr, timePerFrame: 0.1)
            let rep    = SKAction.repeat(lightA, count: 10)
            lightNode.run(rep, completion: {
                lightNode.removeFromParent()
            })
        }
    }
    
    func setLightPhy(light:SKSpriteNode)  {
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:light.frame.size.width,height:light.frame.size.height))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        physicsBody.contactTestBitMask = PLAYER_CATEGORY;
        physicsBody.categoryBitMask = 0
        physicsBody.collisionBitMask = 0
        light.physicsBody = physicsBody
    }
    
    @objc func lightingAttackTimer()  {
        if oxNode.canMove {
            attackTimeCount += 1
            if attackTimeCount == 5{
                self.lightingAttackBlock(oxNode)
                attackTimeCount = 0
            }
        }
    }
    
    @objc func canMove(){
        oxNode.canMove = true
    }
    
    //MARK:复写方法
    override func beAttack(attackNode: WDBaseNode, beAttackNode: WDBaseNode) -> Bool {
        let isBreak = super.beAttack(attackNode: attackNode, beAttackNode: beAttackNode)
        if isBreak{
            self.perform(#selector(canMove), with: nil, afterDelay: 0.5)
        }
        
        return isBreak
    }
    
    override func attack(direction: NSString, nodeDic: NSDictionary) {
        
        if isAttackIng {
            let personNode:WDPersonNode = nodeDic.object(forKey: "personNode") as! WDPersonNode
            let x:CGFloat = personNode.position.x - 400 * oxNode.xScale
            let point = CGPoint(x:x,y:personNode.position.y)
            
            let action:SKAction = SKAction.move(to: point, duration: 0.2)
            
            personNode.run(action, completion: {
                personNode.personBehavior.reduceBlood(number:1,monsterName: OX_NAME)
                WDAnimationTool.bloodAnimation(node:personNode)
            })
            
            print("撞到玩家了！")
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
            let x:CGFloat = self.oxNode.position.x - 600 * self.oxNode.xScale  
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
        attackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(lightingAttackTimer), userInfo: nil, repeats: true)
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
