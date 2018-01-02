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

    typealias _claw = (_ greenNode:WDGreenZomNode) -> Void
    typealias _smoke = (_ greenNode:WDGreenZomNode) -> Void
    
    var clawAttackBlock:_claw!
    var smokeAttackBlock:_smoke!
    var timeCount:NSInteger = 0
  
    
    
    @objc func canMove()  {
        greenZom?.canMove = true
    }
    
  
    
    //烟雾攻击
    func smokeAttack(personNode:WDPersonNode)  {
        self.smokeAttackAnimation(greenZom: greenZom, personNode: personNode)
    }
    
    //爪子攻击
    func clawAttack(personNode:WDPersonNode)  {
        self.clawAttackAnimation(greenZom: greenZom, personNode: personNode)
    }
    
//***********************动画方法**********************************//
    
    //**********攻击2动画**********//
     func smokeAttackAnimation(greenZom:WDGreenZomNode,personNode:WDPersonNode){
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
    func clawAttackAnimation(greenZom:WDGreenZomNode,personNode:WDPersonNode){
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
    
    
    
    //MARK:复写的方法
    override func setNode(node: WDBaseNode) {
        greenZom = node as! WDGreenZomNode
        attackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(attackTimerAction), userInfo: nil, repeats: true)
    }
    
    override func beAttack(attackNode: WDBaseNode, beAttackNode: WDBaseNode) -> Bool {
        let isBreak = super.beAttack(attackNode: attackNode, beAttackNode: beAttackNode)
        if isBreak{
            self.perform(#selector(canMove), with: nil, afterDelay: 0.5)
        }
        
        return isBreak
    }
    
    
   //timer
    @objc func attackTimerAction(){
        
        if greenZom.canMove {
            
            timeCount += 1
            if timeCount >= attackAllCount{
                
                let random = arc4random() % 2
                
                if random == 1{
                    clawAttackBlock(greenZom)
                }else{
                    smokeAttackBlock(greenZom)
                }
                timeCount = 0
            }
        }
    }
}
