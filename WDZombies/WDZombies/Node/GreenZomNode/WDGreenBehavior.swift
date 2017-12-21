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
    var blood = 0

    func moveActionForGreen(direction:NSString,personNode:WDPersonNode)  {
        
        if greenZom.canMove == true {
            
            let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: greenZom.speed, node: greenZom)
            greenZom.position = point
            greenZom.zPosition = 3 * 667 - greenZom.position.y;
            let bossDirection = WDTool.calculateDirectionForBoss1(bossPoint: greenZom.position, personPoint: personNode.position)
            
            if !bossDirection.isEqual(to: greenZom.direction as String) || !greenZom.isMove {
                
                greenZom.removeAction(forKey: "move")
                

                let moveAction = SKAction.animate(with: greenZom.model.moveArr, timePerFrame: 0.2)
                let repeatAction = SKAction.repeatForever(moveAction)
                if bossDirection.isEqual(to: kLeft as String){
                    greenZom.xScale = xScale
                    greenZom.yScale = yScale
                }else{
                    greenZom.xScale = -1 * xScale
                    greenZom.yScale = yScale
                }
                
                greenZom.run(repeatAction, withKey: "move")
                greenZom.direction = bossDirection
                greenZom.isMove = true
                
            }
        }
    }
    
    override func beAattackAction(attackNode: WDBaseNode, beAttackNode: WDBaseNode) {
        greenZom.wdBlood -= attackNode.wdAttack
        blood += NSInteger(attackNode.wdAttack)
        
        self.reduceBloodLabel(node: greenZom, attackNode: attackNode)
        
        if greenZom.wdBlood <= 0 {
            self.diedAction()
            greenZom.setPhysicsBody(isSet: false)
            return
        }
        
        if blood >= 10 && greenZom.canMove == true{
            
            greenZom.removeAllActions()
            greenZom.canMove = false
            greenZom.isMove = false
            blood = 0
            greenZom.texture = greenZom.model.beAttackTexture
            self.perform(#selector(canMove), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc func canMove()  {
        greenZom?.canMove = true
    }
    
    override func diedAction() {
        
        greenZom.removeAllActions()
        
        let diedAction = SKAction.animate(with: greenZom.model.diedArr, timePerFrame: 0.2)
        greenZom.run(diedAction) {
            self.alreadyDied!(self.greenZom)
            self.greenZom.removeFromParent()
        }
        
    }
    
    func attack2Action(personNode:WDPersonNode)  {
        self.greenAttack2Animation(greenZom: greenZom, personNode: personNode)
    }
    
    func attack1Action(personNode:WDPersonNode)  {
        self.greenAttack1Animation(greenZom: greenZom, personNode: personNode)
    }
    
//***********************动画方法**********************************//
    
    //**********攻击2动画**********//
     func greenAttack2Animation(greenZom:WDGreenZomNode,personNode:WDPersonNode){
        if greenZom.wdBlood <= 0{
            return
        }
        
        greenZom.canMove = false
        greenZom.isMove  = false
        
        let attackAction = SKAction.animate(with: greenZom.model.attack2Arr, timePerFrame: 0.2)
        
        let dic = ["greenZom":greenZom,"personNode":personNode]
        self.perform(#selector(createSmokeNode(dic:)), with: dic, afterDelay: 0.2 * 5)
        
        greenZom.run(attackAction) {
            greenZom.canMove = true
        }
    }
    
    
    @objc func createSmokeNode(dic:NSDictionary){
        let personNode:WDPersonNode = dic.object(forKey: "personNode") as! WDPersonNode
        let greenZom:WDGreenZomNode = dic.object(forKey: "greenZom") as! WDGreenZomNode
        
        let smokeNode = SKSpriteNode.init()
        smokeNode.position = personNode.position
        smokeNode.zPosition = 1000
        smokeNode.name = GREEN_SMOKE_NAME
        smokeNode.size = CGSize(width:75,height:75)
        smokeNode.alpha = 0.3
        let action = SKAction.animate(with: greenZom.model.smokeArr, timePerFrame: 0.1)
        let action2 = SKAction.repeat(action, count: 10)
        self.perform(#selector(setSmokePhy(smokeNode:)), with: smokeNode, afterDelay: 1.0)
        personNode.parent?.addChild(smokeNode)
        
        smokeNode.run(action2) {
            smokeNode.removeFromParent()
        }
    }
    
    
    @objc func setSmokePhy(smokeNode:SKSpriteNode){
        smokeNode.alpha = 1
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:smokeNode.frame.size.width,height:smokeNode.frame.size.height))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        physicsBody.contactTestBitMask = PLAYER_CATEGORY;
        physicsBody.categoryBitMask = 0
        physicsBody.collisionBitMask = 0
        smokeNode.physicsBody = physicsBody
    }
    
   
    
    
    //************攻击1动画***************//
    func greenAttack1Animation(greenZom:WDGreenZomNode,personNode:WDPersonNode){
        if greenZom.wdBlood <= 0{
            return
        }
        
        greenZom.canMove = false
        greenZom.isMove  = false
        
        let attackAction = SKAction.animate(with: greenZom.model.attack1Arr, timePerFrame: 0.2)
        
        let dic = ["greenZom":greenZom,"personNode":personNode]
        self.perform(#selector(createClawNode(dic:)), with: dic, afterDelay: 0.2 * 3)
        
        greenZom.run(attackAction) {
            greenZom.canMove = true
        }
    }
    
    @objc func createClawPhy(clawNode:SKSpriteNode) {
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:clawNode.frame.size.width,height:clawNode.frame.size.height))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        physicsBody.contactTestBitMask = PLAYER_CATEGORY;
        physicsBody.categoryBitMask = 0
        physicsBody.collisionBitMask = 0
        clawNode.physicsBody = physicsBody
        clawNode.alpha = 1
    }
    
    @objc func createClawNode(dic:NSDictionary)  {
        let personNode:WDPersonNode = dic.object(forKey: "personNode") as! WDPersonNode
        let greenZom:WDGreenZomNode = dic.object(forKey: "greenZom") as! WDGreenZomNode
        
        let clawNode = SKSpriteNode.init()
        clawNode.position = personNode.position
        clawNode.zPosition = 1000
        clawNode.name = GREEN_CLAW_NAME
        clawNode.size = CGSize(width:100,height:100)
        clawNode.alpha = 0.6
        let action = SKAction.animate(with: greenZom.model.clawArr, timePerFrame: 0.1)
        let action2 = SKAction.repeat(action, count: 4)
        personNode.parent?.addChild(clawNode)
        
        
        self.perform(#selector(createClawPhy(clawNode:)), with: clawNode, afterDelay: 0.1 * 5)
        
        clawNode.run(action2) {
            clawNode.removeFromParent()
        }
        
    }
}
