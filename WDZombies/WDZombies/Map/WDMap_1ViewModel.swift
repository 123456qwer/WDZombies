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
    
    //人物&普通僵尸碰撞
    func personAndNormalZom(pNode:WDPersonNode,zomNode:WDZombieNode){
        let direction:NSString = WDTool.calculateDirectionForZom(point1: zomNode.position, point2: pNode.position)
        zomNode.zombieBehavior.stopMoveAction(direction: direction)
        zomNode.zombieBehavior.attackAction(node: pNode)
    }
    
    
    
    
    //碰撞逻辑
    func phyContact(contact: SKPhysicsContact,personNode:WDPersonNode,boomModel:WDSkillModel){
        
        let A = contact.bodyA.node;
        let B = contact.bodyB.node;
        
        var pNode:WDPersonNode?
        var zomNode:WDZombieNode?
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
        
        meteoriteNode = (A?.name?.isEqual(KNIGHT_METEORITE_NAME))! ? (A as? SKSpriteNode):nil;
        if meteoriteNode == nil {
            meteoriteNode = (B?.name?.isEqual(KNIGHT_METEORITE_NAME))! ? (B as? SKSpriteNode):nil;
        }
        
        knightNode = (A?.name?.isEqual(KNIGHT_NAME))! ? (A as? WDSmokeKnightNode):nil;
        if knightNode == nil {
            knightNode = (B?.name?.isEqual(KNIGHT_NAME))! ? (B as? WDSmokeKnightNode):nil;
        }
        
        greenClaw = (A?.name?.isEqual(GREEN_CLAW_NAME))! ? (A as? SKSpriteNode):nil;
        if greenClaw == nil {
            greenClaw = (B?.name?.isEqual(GREEN_CLAW_NAME))! ? (B as? SKSpriteNode):nil;
        }
        
        greenNode = (A?.name?.isEqual(GREEN_ZOM_NAME))! ? (A as? WDGreenZomNode):nil;
        if greenNode == nil {
            greenNode = (B?.name?.isEqual(GREEN_ZOM_NAME))! ? (B as? WDGreenZomNode):nil;
        }
        
        greenSmoke = (A?.name?.isEqual(GREEN_SMOKE_NAME))! ? (A as? SKSpriteNode):nil;
        if greenSmoke == nil {
            greenSmoke = (B?.name?.isEqual(GREEN_SMOKE_NAME))! ? (B as? SKSpriteNode):nil;
        }
        
        kulouNode = (A?.name?.isEqual(KULOU))! ? (A as? WDKulouNode):nil;
        if kulouNode == nil {
            kulouNode = (B?.name?.isEqual(KULOU))! ? (B as? WDKulouNode):nil;
        }
        
        boss1Node = (A?.name?.isEqual(BOSS1))! ? (A as? WDBossNode_1):nil;
        if boss1Node == nil {
            boss1Node = (B?.name?.isEqual(BOSS1))! ? (B as? WDBossNode_1):nil;
        }
        
        magicNode = (A?.name?.isEqual(MAGIC))! ? (A as? SKEmitterNode):nil;
        if magicNode == nil {
            magicNode = (B?.name?.isEqual(MAGIC))! ? (B as? SKEmitterNode):nil;
        }
        
        pNode = (A?.name?.isEqual(PERSON))! ? (A as? WDPersonNode):nil;
        if pNode == nil {
            pNode = (B?.name?.isEqual(PERSON))! ? (B as? WDPersonNode):nil;
        }
        
        zomNode = (A?.name?.isEqual(ZOMBIE))! ? (A as? WDZombieNode):nil;
        if zomNode == nil {
            zomNode = (B?.name?.isEqual(ZOMBIE))! ? (B as? WDZombieNode):nil;
        }
        
        fireNode = (A?.name?.isEqual(FIRE))! ? (A as? SKSpriteNode):nil;
        if fireNode == nil {
            fireNode = (B?.name?.isEqual(FIRE))! ? (B as? SKSpriteNode):nil;
        }
        
        boomNode = (A?.name?.isEqual(BOOM))! ? (A as? SKSpriteNode):nil;
        if boomNode == nil {
            boomNode = (B?.name?.isEqual(BOOM))! ? (B as? SKSpriteNode):nil;
        }
        
        if pNode != nil && boss1Node != nil {
            boss1Node?.bossBehavior.stopMoveAction(direction: "")
            boss1Node?.bossBehavior.attackAction(node: pNode!)
        }
        
        
        if pNode != nil && zomNode != nil{
            self.personAndNormalZom(pNode: pNode!, zomNode: zomNode!)
        }
        
        
        if boomNode != nil && zomNode != nil {
            personNode.wdAttack += CGFloat(boomModel.skillLevel2)
            zomNode?.zombieBehavior.beAattackAction(attackNode: personNode, beAttackNode: zomNode!)
            personNode.wdAttack -= CGFloat(boomModel.skillLevel2)
        }
        
        if magicNode != nil && pNode != nil {
            WDAnimationTool.bloodAnimation(node:personNode)
            personNode.personBehavior.reduceBlood(number:1)
        }
        
        if zomNode != nil && fireNode != nil{
            fireNode?.removeFromParent()
            zomNode?.zombieBehavior.beAattackAction(attackNode: personNode, beAttackNode: zomNode!)
        }
        
        if kulouNode != nil && fireNode != nil {
            kulouNode?.behavior.beAattackAction(attackNode: personNode, beAttackNode: kulouNode!)
            WDAnimationTool.bloodAnimation(node: kulouNode!)
            fireNode?.removeFromParent()
        }
        
        if kulouNode != nil && boomNode != nil {
            personNode.wdAttack += CGFloat(boomModel.skillLevel2)
            kulouNode?.behavior.beAattackAction(attackNode: personNode, beAttackNode: personNode)
            personNode.wdAttack -= CGFloat(boomModel.skillLevel2)
        }
        
        if kulouNode != nil && pNode != nil {
            kulouNode?.behavior.attackAction(node: personNode)
        }
        
        if greenClaw != nil && pNode != nil {
            // print("受到绿僵尸爪子攻击")
            WDAnimationTool.bloodAnimation(node:personNode)
            personNode.personBehavior.reduceBlood(number:2)
        }
        
        if greenSmoke != nil && pNode != nil {
            // print("受到毒气烟雾的攻击")
            WDAnimationTool.bloodAnimation(node:personNode)
            personNode.personBehavior.reduceBlood(number:2)
        }
        
        if greenNode != nil && fireNode != nil {
            greenNode?.behavior.beAattackAction(attackNode: personNode, beAttackNode: greenNode!)
            WDAnimationTool.bloodAnimation(node: greenNode!)
            fireNode?.removeFromParent()
        }
        
        if knightNode != nil && fireNode != nil {
            //print("雾骑士被打了")
            knightNode?.behavior.beAattackAction(attackNode: personNode, beAttackNode: knightNode!)
            WDAnimationTool.bloodAnimation(node: knightNode!)
            fireNode?.removeFromParent()
        }
        
        if knightNode != nil && pNode != nil {
            knightNode?.behavior.attack1Animation(personNode: pNode!)
        }
        
        if pNode != nil && meteoriteNode != nil{
            WDAnimationTool.bloodAnimation(node:personNode)
            personNode.personBehavior.reduceBlood(number:2)
            //print("陨石砸到我了")
        }
        
        if greenNode != nil && pNode != nil {
            greenNode?.attack1Action(greenNode!)
        }
    }
    
    
    
    /// 删除所有僵尸
    func removeNode() {
        //删除所有僵尸
        if  normalZomArr.count > 0{
            for index:NSInteger in 0...normalZomArr.count - 1 {
                let zom:WDZombieNode? = normalZomArr.object(at: index) as? WDZombieNode
                self.removeNode(zomNode: zom!)
            }
            
            normalZomArr.removeAllObjects()
        }
        
        //删除所有骷髅
        if kulouZomArr.count > 0{
            for index:NSInteger in 0...kulouZomArr.count - 1 {
                let kulou:WDKulouNode? = kulouZomArr.object(at: index) as? WDKulouNode
                self.removeNode(zomNode: kulou!)
            }
            
            kulouZomArr.removeAllObjects()
        }
        
        if greenZomArr.count > 0{
            for index:NSInteger in 0...greenZomArr.count - 1 {
                let greenZom:WDGreenZomNode? = greenZomArr.object(at: index) as? WDGreenZomNode
                greenZom?.clearAction()
                self.removeNode(zomNode: greenZom!)
            }
            
            greenZomArr.removeAllObjects()
        }
        
        if knightZomArr.count > 0{
            for index:NSInteger in 0...knightZomArr.count - 1 {
                let knightZom:WDSmokeKnightNode? = knightZomArr.object(at: index) as? WDSmokeKnightNode
                self.removeNode(zomNode: knightZom!)
            }
            
            knightZomArr.removeAllObjects()
        }
    }
    
    
    func removeNode(zomNode:WDBaseNode){
        zomNode.clearAction()
        zomNode.removeAllActions()
        zomNode.removeAllChildren()
        zomNode.removeFromParent()
    }
   
    
}
