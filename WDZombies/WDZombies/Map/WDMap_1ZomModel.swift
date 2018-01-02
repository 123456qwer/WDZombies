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
        
        
        weak var weakSelf = map1_scene
        kNight.behavior.starMove()
        kNight.behavior.moveBlock = {(node:WDBaseNode) -> Void in
            let direction = WDTool.calculateDirectionForZom(point1: node.position, point2: (weakSelf?.personNode.position)!)
            let kNode:WDSmokeKnightNode = node as! WDSmokeKnightNode
            kNode.behavior.move(direction: direction, nodeDic: ["personNode":weakSelf?.personNode! as Any])
        }
       
        
        kNight.behavior.blackCircleAttackBlock = {(kNightNode:WDSmokeKnightNode) -> Void in
            kNightNode.behavior.blackCircleAttackAction(personNode: (weakSelf?.personNode)!)
        }
        
        kNight.behavior.meteoriteAttackBlock = {(knightNode:WDSmokeKnightNode) -> Void in
            knightNode.behavior.meteoriteAttackAction(personNode: (weakSelf?.personNode)!)
        }
        
        weak var wSelf = self

        kNight.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            wSelf?.diedNextAction(map: weakSelf!, node: node, count: 5)
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
        weak var wSelf = self
        greenZom.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            wSelf?.diedNextAction(map: weakSelf!, node: node, count: 4)
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
        weak var wSelf = self
        kulouNode.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            wSelf?.diedNextAction(map: weakSelf!, node: node, count: 3)
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
        weak var wSelf = self
        zombieNode.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            wSelf?.diedNextAction(map: weakSelf!, node: node, count: 1)
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
        weak var wSelf = self
        zombieNode.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            wSelf?.diedNextAction(map: weakSelf!, node: node, count: 2)
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
    
    //MARK:创建鱿鱼僵尸
    func createSquidZom(isBoss:Bool) -> WDSquidNode {
        let squidNode:WDSquidNode = WDSquidNode.init()
        squidNode.size = CGSize(width:140 ,height:100)
        squidNode.isBoss = isBoss
        squidNode.initWithPerson(personNode: map1_scene.personNode)
        map1_scene.bgNode.addChild(squidNode)
       
        weak var weakSelf = map1_scene
        squidNode.behavior.starMove()
        squidNode.behavior.moveBlock = {(node:WDBaseNode) -> Void in
            let direction = WDTool.calculateDirectionForZom(point1: node.position, point2: (weakSelf?.personNode.position)!)
            let squidN:WDSquidNode = node as! WDSquidNode
            squidN.behavior.move(direction: direction, nodeDic: ["personNode":weakSelf?.personNode! as Any])
        }
        
        squidNode.behavior.inkAttackBlock = {(squidN:WDSquidNode) -> Void in
            squidNode.behavior.attack(direction: "", nodeDic:["personNode":weakSelf?.personNode! as Any])
        }
        
        weak var wSelf = self
        squidNode.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            wSelf?.diedNextAction(map: weakSelf!, node: node, count: 6)
        }
        
        return squidNode
    }
    
    
///////////////////////////公用////////////////
    /// 僵尸死亡调用方法
    func diedNextAction(map:WDMap_1Scene,node:WDBaseNode,count:NSInteger) {
        let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
        if node.isBoss && model.monsterCount < count{
            model.monsterCount = count
            map.levelUp(model: model)
            map.personNode.createLevelUpNode()
            map.playNext()
        }else if node.isBoss {
            map.playNext()
        }else{
            map.createBoss()
            map.removeNodeFromArr(node:node)
        }
        
    }
    
}
