//
//  WDMap_1ZomModel.swift
//  WDZombies
//
//  Created by wudong on 2017/12/22.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDMap_1ZomModel: NSObject {
    
    weak var map1_scene:WDMap_1Scene! = nil
    
    //MARK:创建雾骑士
    /// 创建雾骑士
    func createKnightZom(isBoss:Bool) -> WDSmokeKnightNode {
        let kNight:WDSmokeKnightNode = WDSmokeKnightNode.init()
        kNight.size = CGSize(width:165,height:165)
        kNight.isBoss = true
        kNight.initWithPersonNode(personNode: map1_scene.personNode)
        map1_scene.bgNode.addChild(kNight)
        kNight.starMove()
        
        weak var weakSelf = map1_scene
        kNight.moveAction = {(knightNode:WDSmokeKnightNode) -> Void in
            
            let direction = WDTool.calculateDirectionForZom(point1: knightNode.position, point2: (weakSelf?.personNode.position)!)
            knightNode.behavior.moveActionForKnight(direction: direction, personNode: (weakSelf?.personNode)!)
        }
        
        kNight.attack1Action = {(kNightNode:WDSmokeKnightNode) -> Void in
            kNightNode.behavior.attack1Action(personNode: (weakSelf?.personNode)!)
        }
        
        kNight.attack2Action = {(knightNode:WDSmokeKnightNode) -> Void in
            knightNode.behavior.attack2Action(personNode: (weakSelf?.personNode)!)
        }
        
        kNight.diedAction = {(knightNode:WDSmokeKnightNode) -> Void in
            let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
            
            if knightNode.isBoss && model.monsterCount < 5{
                model.monsterCount = 5
                weakSelf?.levelUp(model: model)
                weakSelf?.personNode.createLevelUpNode()
                weakSelf?.playNext()
            }else if knightNode.isBoss{
                weakSelf?.playNext()
            }else {
                weakSelf?.createBoss()
            }
        }
        
        return kNight
    }
    
    
    //MARK:创建绿色僵尸
    /// 创建绿色僵尸
    func createGreenZom(isBoss:Bool) -> WDGreenZomNode {
        let greenZom = WDGreenZomNode.init()
        greenZom.size = CGSize(width:125,height:125)
        
        greenZom.isBoss = isBoss
        greenZom.initWithPersonNode(personNode: map1_scene.personNode)
        map1_scene.bgNode.addChild(greenZom)
        
     
        
        //绿色僵尸移动
        weak var weakSelf = map1_scene
        
        //绿色僵尸吐雾攻击
        greenZom.behavior.smokeAttackBlock = {(greenNode:WDGreenZomNode) -> Void in
            greenNode.behavior.smokeAttack(personNode: (weakSelf?.personNode)!)
        }
        
        //绿色僵尸爪子攻击
        greenZom.behavior.clawAttackBlock = {(greenNode:WDGreenZomNode) -> Void in
            greenNode.behavior.clawAttack(personNode: (weakSelf?.personNode)!)
        }
        
        
        //绿色僵尸死亡
        greenZom.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
            
            if node.isBoss && model.monsterCount < 4{
                model.monsterCount = 4
                weakSelf?.levelUp(model: model)
                weakSelf?.personNode.createLevelUpNode()
                weakSelf?.playNext()
            }else if node.isBoss{
                weakSelf?.playNext()
            }else {
                weakSelf?.createBoss()
            }
        }
        
        
        //僵尸移动
        greenZom.behavior.starMove()
        greenZom.behavior.moveBlock = {(node:WDBaseNode) -> Void in
            let direction = WDTool.calculateDirectionForZom(point1: node.position, point2: (weakSelf?.personNode.position)!)
            let greenN:WDGreenZomNode = node as! WDGreenZomNode
            greenN.behavior.move(direction: direction, nodeDic: ["personNode":weakSelf?.personNode! as Any])
        }
        
        return greenZom
    }
    
    
    //MARK:创建骷髅僵尸
    /// 创建骷髅僵尸
    func createKulouZom(isBoss:Bool) -> WDKulouNode {
        
        let kulouNode:WDKulouNode = WDKulouNode.init()
        kulouNode.size = CGSize(width:110 ,height:130)
        kulouNode.isBoss = isBoss
        kulouNode.initWithPersonNode(personNode: map1_scene.personNode)
        map1_scene.bgNode.addChild(kulouNode)
        
        
        weak var weakSelf = map1_scene

        //骷髅开始移动
        kulouNode.behavior.starMove()
        kulouNode.behavior.moveBlock = {(node:WDBaseNode) -> Void in
            let direction = WDTool.calculateDirectionForZom(point1: node.position, point2: (weakSelf?.personNode.position)!)
            let kulouN:WDKulouNode = node as! WDKulouNode
            kulouN.behavior.move(direction: direction, nodeDic: ["personNode":weakSelf?.personNode! as Any])
        }
        
        //骷髅攻击
        kulouNode.behavior.blinkMoveBlock = {(kulou:WDKulouNode) -> Void in
            kulou.behavior.blinkAction(personNode:(weakSelf?.personNode)!)
        }
        
        //骷髅死亡，可以升级加技能
        kulouNode.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
            
            if node.isBoss && model.monsterCount < 3 {
                weakSelf?.playNext()
                model.monsterCount = 3
                weakSelf?.levelUp(model: model)
                weakSelf?.personNode.createLevelUpNode()
            }else if node.isBoss {
                weakSelf?.playNext()
            }else {
                weakSelf?.createBoss()
            }
        }
        
        return kulouNode
    }
    
    
    //MARK:创建普通僵尸
    /// 创建普通僵尸
    func createNormalZom(isBoss:Bool) -> WDZombieNode {
        let arr:NSMutableArray = WDTool.cutCustomImage(image: UIImage.init(named: "NormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
        let type:zomType = .Normal
        let zombieNode:WDZombieNode = WDZombieNode.init(texture:arr.object(at: 0) as? SKTexture)
        zombieNode.isBoss = isBoss
        zombieNode.initWithZomType(type:type)
        map1_scene.bgNode.addChild(zombieNode)
        
        //僵尸移动
        weak var weakSelf = map1_scene
        zombieNode.moveAction = {(zom:WDZombieNode) -> Void in
            let direction:NSString = WDTool.calculateDirectionForZom(point1: (zom.position), point2: weakSelf!.personNode.position)
            zom.behavior.moveAction(direction: direction)
        }
        
        //僵尸死亡
        zombieNode.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
            if  node.isBoss && model.monsterCount < 1{
                model.monsterCount = 1
                weakSelf?.levelUp(model: model)
                weakSelf?.personNode.createLevelUpNode()
                weakSelf?.playNext()
            }else if node.isBoss {
                weakSelf?.playNext()
            }else {
                weakSelf?.createBoss()
                weakSelf?.removeNormalZom(normalZom: node as! WDZombieNode)
            }
            
        }
        
        let bornAction:SKAction = SKAction.animate(with: arr as! [SKTexture], timePerFrame: 0.2)
        zombieNode.run(bornAction) {
            zombieNode.starMove()
        }
        
        return zombieNode
    }
    
    
    //MARK:创建红色僵尸
    /// 创建红色僵尸
    func createRedZom(isBoss:Bool) -> WDZombieNode {
        
        let arr:NSMutableArray = WDTool.cutCustomImage(image: UIImage.init(named: "RedNormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
        let type:zomType = .Red
        let zombieNode:WDZombieNode = WDZombieNode.init(texture:arr.object(at: 0) as? SKTexture)
        zombieNode.isBoss = isBoss
        zombieNode.initWithZomType(type:type)
        map1_scene.bgNode.addChild(zombieNode)
        
        
        //僵尸移动
        weak var weakSelf = map1_scene
        zombieNode.moveAction = {(zom:WDZombieNode) -> Void in
            let direction:NSString = WDTool.calculateDirectionForZom(point1: (zom.position), point2: weakSelf!.personNode.position)
            zom.behavior.moveAction(direction: direction)
        }
        
        //僵尸死亡
        zombieNode.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
            if node.isBoss && model.monsterCount < 2{
                model.monsterCount = 2
                weakSelf?.levelUp(model: model)
                weakSelf?.personNode.createLevelUpNode()
                weakSelf?.playNext()
            }else if node.isBoss {
                weakSelf?.playNext()
            }else{
                weakSelf?.createBoss()
                weakSelf?.removeRedZom(redZom: node as! WDZombieNode)
            }
        }
        
        //红色僵尸发动攻击<之前造成循环引用 -> 直接使用 zombieNode 来调用方法，如下注释>
        //zombieNode.zombieBehavior.redAttackAction(node: (weakSelf?.personNode)!
        zombieNode.redAttackAction = {(zom:WDZombieNode) -> Void in
            zom.behavior.redAttackAction(node: (weakSelf?.personNode)!)
        }
        
        let bornAction:SKAction = SKAction.animate(with: arr as! [SKTexture], timePerFrame: 0.2)
        zombieNode.run(bornAction) {
            zombieNode.starMove()
        }
        
        return zombieNode
    }
    
}
