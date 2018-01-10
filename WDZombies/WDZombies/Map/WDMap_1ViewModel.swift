//
//  WDMap_1ViewModel.swift
//  WDZombies
//
//  Created by wudong on 2017/12/21.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDMap_1ViewModel: NSObject {

    var normalZomArr:NSMutableArray = NSMutableArray.init()   //存储创建的zom
    var kulouZomArr:NSMutableArray  = NSMutableArray.init()   //存储骷髅
    var greenZomArr:NSMutableArray  = NSMutableArray.init()   //存储绿色僵尸
    var knightZomArr:NSMutableArray = NSMutableArray.init()   //雾骑士
    var squidZomArr:NSMutableArray  = NSMutableArray.init()   //鱿鱼哥
    var zomArr:NSMutableArray = NSMutableArray.init()         //全部僵尸
    
    //人物&普通僵尸碰撞
    func personAndNormalZom(pNode:WDPersonNode,zomNode:WDZombieNode){
        let direction:NSString = WDTool.calculateDirectionForZom(point1: zomNode.position, point2: pNode.position)
        zomNode.behavior.stopMoveAction(direction: direction)
        zomNode.behavior.attackAction(node: pNode)
    }
    
    
    
    
    //碰撞逻辑
    func phyContact(contact: SKPhysicsContact,personNode:WDPersonNode,boomModel:WDSkillModel){
        
        let A:SKNode = contact.bodyA.node!
        let B:SKNode = contact.bodyB.node!
        
        
        var pNode:WDPersonNode?
        var zomNode:WDZombieNode?
        var redNode:WDZombieNode?
        var fireNode:SKSpriteNode?
        var boomNode:SKSpriteNode?
        var magicNode:SKEmitterNode?
        var boss1Node:WDBossNode_1?
        var kulouNode:WDKulouNode?
        var greenSmoke:SKSpriteNode?
        var greenNode:WDGreenZomNode?
        var greenClaw:SKSpriteNode?
        var knightNode:WDSmokeKnightNode?
        var meteoriteNode:SKSpriteNode?
        var squidNode:WDSquidNode?
        var inkNode:SKSpriteNode?
        var oxNode:WDOXNode?
        var oxLightNode:SKSpriteNode?
        var kulouNightNode:WDKulouKnightNode?
        
    
        kulouNightNode = (A.name?.isEqual(KULOU_KNIGHT_NAME))! ? (A as? WDKulouKnightNode):nil;
        if kulouNightNode == nil {
            kulouNightNode = (B.name?.isEqual(KULOU_KNIGHT_NAME))! ? (B as? WDKulouKnightNode):nil;
        }
        
        oxLightNode = (A.name?.isEqual(OX_LIGHT))! ? (A as? SKSpriteNode):nil;
        if oxLightNode == nil {
            oxLightNode = (B.name?.isEqual(OX_LIGHT))! ? (B as? SKSpriteNode):nil;
        }
        
        oxNode = (A.name?.isEqual(OX_NAME))! ? (A as? WDOXNode):nil;
        if oxNode == nil {
            oxNode = (B.name?.isEqual(OX_NAME))! ? (B as? WDOXNode):nil;
        }
        
        inkNode = (A.name?.isEqual(SQUID_INK))! ? (A as? SKSpriteNode):nil;
        if inkNode == nil {
            inkNode = (B.name?.isEqual(SQUID_INK))! ? (B as? SKSpriteNode):nil;
        }
        
        squidNode = (A.name?.isEqual(SQUID_NAME))! ? (A as? WDSquidNode):nil;
        if squidNode == nil {
            squidNode = (B.name?.isEqual(SQUID_NAME))! ? (B as? WDSquidNode):nil;
        }
        
        meteoriteNode = (A.name?.isEqual(KNIGHT_METEORITE_NAME))! ? (A as? SKSpriteNode):nil;
        if meteoriteNode == nil {
            meteoriteNode = (B.name?.isEqual(KNIGHT_METEORITE_NAME))! ? (B as? SKSpriteNode):nil;
        }
        
        knightNode = (A.name?.isEqual(KNIGHT_NAME))! ? (A as? WDSmokeKnightNode):nil;
        if knightNode == nil {
            knightNode = (B.name?.isEqual(KNIGHT_NAME))! ? (B as? WDSmokeKnightNode):nil;
        }
        
        greenClaw = (A.name?.isEqual(GREEN_CLAW_NAME))! ? (A as? SKSpriteNode):nil;
        if greenClaw == nil {
            greenClaw = (B.name?.isEqual(GREEN_CLAW_NAME))! ? (B as? SKSpriteNode):nil;
        }
        
        greenNode = (A.name?.isEqual(GREEN_ZOM_NAME))! ? (A as? WDGreenZomNode):nil;
        if greenNode == nil {
            greenNode = (B.name?.isEqual(GREEN_ZOM_NAME))! ? (B as? WDGreenZomNode):nil;
        }
        
        greenSmoke = (A.name?.isEqual(GREEN_SMOKE_NAME))! ? (A as? SKSpriteNode):nil;
        if greenSmoke == nil {
            greenSmoke = (B.name?.isEqual(GREEN_SMOKE_NAME))! ? (B as? SKSpriteNode):nil;
        }
        
        kulouNode = (A.name?.isEqual(KULOU_NAME))! ? (A as? WDKulouNode):nil;
        if kulouNode == nil {
            kulouNode = (B.name?.isEqual(KULOU_NAME))! ? (B as? WDKulouNode):nil;
        }
        
        boss1Node = (A.name?.isEqual(BOSS1))! ? (A as? WDBossNode_1):nil;
        if boss1Node == nil {
            boss1Node = (B.name?.isEqual(BOSS1))! ? (B as? WDBossNode_1):nil;
        }
        
        magicNode = (A.name?.isEqual(MAGIC))! ? (A as? SKEmitterNode):nil;
        if magicNode == nil {
            magicNode = (B.name?.isEqual(MAGIC))! ? (B as? SKEmitterNode):nil;
        }
        
        pNode = (A.name?.isEqual(PERSON))! ? (A as? WDPersonNode):nil;
        if pNode == nil {
            pNode = (B.name?.isEqual(PERSON))! ? (B as? WDPersonNode):nil;
        }
        
        zomNode = (A.name?.isEqual(NORMAL_ZOM))! ? (A as? WDZombieNode):nil;
        if zomNode == nil {
            zomNode = (B.name?.isEqual(NORMAL_ZOM))! ? (B as? WDZombieNode):nil;
        }
        
        redNode = (A.name?.isEqual(RED_ZOM))! ? (A as? WDZombieNode):nil;
        if redNode == nil {
            redNode = (B.name?.isEqual(RED_ZOM))! ? (B as? WDZombieNode):nil;
        }
        
        fireNode = (A.name?.isEqual(FIRE))! ? (A as? SKSpriteNode):nil;
        if fireNode == nil {
            fireNode = (B.name?.isEqual(FIRE))! ? (B as? SKSpriteNode):nil;
        }
        
        boomNode = (A.name?.isEqual(BOOM))! ? (A as? SKSpriteNode):nil;
        if boomNode == nil {
            boomNode = (B.name?.isEqual(BOOM))! ? (B as? SKSpriteNode):nil;
        }
        
        
   //////逻辑////////
        
        if pNode != nil && boss1Node != nil {
            boss1Node?.bossBehavior.stopMoveAction(direction: "")
            boss1Node?.bossBehavior.attackAction(node: pNode!)
        }
        
        if pNode != nil && zomNode != nil{
            self.personAndNormalZom(pNode: pNode!, zomNode: zomNode!)
        }
        
        if pNode != nil && redNode != nil{
            self.personAndNormalZom(pNode: pNode!, zomNode: redNode!)
        }
        
        if boomNode != nil && zomNode != nil {
            personNode.wdAttack += CGFloat(boomModel.skillLevel2)
            zomNode?.behavior.beAattackAction(attackNode: personNode, beAttackNode: zomNode!)
            personNode.wdAttack -= CGFloat(boomModel.skillLevel2)
        }
        
        if boomNode != nil && redNode != nil {
            personNode.wdAttack += CGFloat(boomModel.skillLevel2)
            redNode?.behavior.beAattackAction(attackNode: personNode, beAttackNode: redNode!)
            personNode.wdAttack -= CGFloat(boomModel.skillLevel2)
        }
        
        if magicNode != nil && pNode != nil {
            WDAnimationTool.bloodAnimation(node:personNode)
            personNode.personBehavior.reduceBlood(number:1,monsterName: RED_ZOM)
        }
        
        if zomNode != nil && fireNode != nil{
            fireNode?.removeFromParent()
            zomNode?.behavior.beAattackAction(attackNode: personNode, beAttackNode: zomNode!)
        }
        
        if redNode != nil && fireNode != nil{
            fireNode?.removeFromParent()
            redNode?.behavior.beAattackAction(attackNode: personNode, beAttackNode: redNode!)
        }
        
        if kulouNode != nil && fireNode != nil {
           _ = kulouNode?.behavior.beAttack(attackNode: personNode, beAttackNode: kulouNode!)
            WDAnimationTool.bloodAnimation(node: kulouNode!)
            fireNode?.removeFromParent()
        }
        
        if kulouNode != nil && boomNode != nil {
            personNode.wdAttack += CGFloat(boomModel.skillLevel2)
            kulouNode?.behavior.beAattackAction(attackNode: personNode, beAttackNode: personNode)
            personNode.wdAttack -= CGFloat(boomModel.skillLevel2)
        }
        
        if kulouNode != nil && pNode != nil {
            kulouNode?.behavior.attack(direction: "", nodeDic: ["personNode":personNode])
        }
        
        if greenClaw != nil && pNode != nil {
            // print("受到绿僵尸爪子攻击")
            WDAnimationTool.bloodAnimation(node:personNode)
            personNode.personBehavior.reduceBlood(number:2,monsterName: GREEN_ZOM_NAME)
        }
        
        if greenSmoke != nil && pNode != nil {
            // print("受到毒气烟雾的攻击")
            WDAnimationTool.bloodAnimation(node:personNode)
            personNode.personBehavior.reduceBlood(number:2,monsterName: GREEN_ZOM_NAME)
        }
        
        if greenNode != nil && fireNode != nil {
           _ = greenNode?.behavior.beAttack(attackNode: personNode, beAttackNode: greenNode!)
            WDAnimationTool.bloodAnimation(node: greenNode!)
            fireNode?.removeFromParent()
        }
        
        if knightNode != nil && fireNode != nil {
            //print("雾骑士被打了")
            _ = knightNode?.behavior.beAttack(attackNode: personNode, beAttackNode: knightNode!)
            WDAnimationTool.bloodAnimation(node: knightNode!)
            fireNode?.removeFromParent()
        }
        
        if knightNode != nil && pNode != nil {
            knightNode?.behavior.blackCircleAttackAction(personNode: pNode!)
        }
        
        if pNode != nil && meteoriteNode != nil{
            WDAnimationTool.bloodAnimation(node:personNode)
            personNode.personBehavior.reduceBlood(number:2,monsterName: KNIGHT_NAME)
            //print("陨石砸到我了")
        }
        
        if greenNode != nil && pNode != nil {
            greenNode?.behavior.clawAttack(personNode: personNode)
        }
        
        if pNode != nil && squidNode != nil{
            squidNode?.behavior.attackTimeCount = 0
            squidNode?.behavior.attack(direction: "", nodeDic: ["personNode":personNode])
        }
        
        if pNode != nil && oxNode != nil{
            oxNode?.behavior.attack(direction: "", nodeDic: ["personNode":personNode])
        }
        
        if pNode != nil && inkNode != nil {
            inkNode?.removeAllActions()
            inkNode?.texture = WDMapManager.sharedInstance.inkTexture
            let alphaA = SKAction.fadeAlpha(to: 0, duration: 1)
            inkNode?.run(alphaA, completion: {
                inkNode?.removeFromParent()
            })
            WDAnimationTool.bloodAnimation(node:personNode)
            personNode.personBehavior.reduceBlood(number:1,monsterName: SQUID_NAME)
        }
        
        if squidNode != nil && fireNode != nil {
            _ = squidNode?.behavior.beAttack(attackNode: personNode, beAttackNode: squidNode!)
            WDAnimationTool.bloodAnimation(node: squidNode!)
            fireNode?.removeFromParent()
        }
        
        if pNode != nil && oxLightNode != nil{
            WDAnimationTool.bloodAnimation(node: personNode)
            personNode.personBehavior.reduceBlood(number: 1,monsterName: OX_NAME)
            personNode.personBehavior.beFlashAttack()
        }
        
        if fireNode != nil && oxNode != nil{
           _ = oxNode?.behavior.beAttack(attackNode: personNode, beAttackNode: oxNode!)
            WDAnimationTool.bloodAnimation(node: oxNode!)
            fireNode?.removeFromParent()
        }
        
        if fireNode != nil && kulouNightNode != nil{
            _ = kulouNightNode?.behavior.beAttack(attackNode: personNode, beAttackNode: kulouNightNode!)
            WDAnimationTool.bloodAnimation(node: kulouNightNode!)
            fireNode?.removeFromParent()
        }
       
        
    }
    
    
    
    
    
    /// 删除所有僵尸
    func removeNode() {
        
        if zomArr.count > 0 {
            for index:NSInteger in 0...zomArr.count - 1 {
                let zom:WDBaseNode! = zomArr.object(at: index) as! WDBaseNode
                self.removeNode(zomNode: zom)
            }
            
            zomArr.removeAllObjects()
        }
    }
    
    
    func removeNode(zomNode:WDBaseNode){
        zomNode.clearAction()
        zomNode.removeAllActions()
        zomNode.removeAllChildren()
        zomNode.removeFromParent()
    }
   
    
}
