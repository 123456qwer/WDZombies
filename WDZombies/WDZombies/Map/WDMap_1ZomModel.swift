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
        kNight.isBoss = isBoss
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
        
        self.addZomNodeForViewArr(node: kNight)
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
        
        self.addZomNodeForViewArr(node: greenZom)
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
            let kulouNode:WDKulouNode = node as! WDKulouNode
            if kulouNode.isCall {
                return
                
                
            }
            wSelf?.diedNextAction(map: weakSelf!, node: node, count: 3)
        }
    
        self.addZomNodeForViewArr(node: kulouNode)
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
        
        self.addZomNodeForViewArr(node: zombieNode)
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
        
        self.addZomNodeForViewArr(node: zombieNode)
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
        
        self.addZomNodeForViewArr(node: squidNode)
        return squidNode
    }
    
    //MARK:创建公牛
    func createOXZom(isBoss:Bool) -> WDOXNode {
        let oxZom:WDOXNode = WDOXNode.init()
        oxZom.size = CGSize(width:200 ,height:250)
        oxZom.isBoss = isBoss
        oxZom.initWithPerson(personNode: map1_scene.personNode)
        map1_scene.bgNode.addChild(oxZom)
        
        weak var weakSelf = map1_scene
        oxZom.behavior.starMove()
        oxZom.behavior.moveBlock = {(node:WDBaseNode) -> Void in
            let direction = WDTool.calculateDirectionForZom(point1: node.position, point2: (weakSelf?.personNode.position)!)
            let oxZom:WDOXNode = node as! WDOXNode
            oxZom.behavior.move(direction: direction, nodeDic: ["personNode":weakSelf?.personNode! as Any])
        }
        
        
        weak var wSelf = self
        oxZom.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            wSelf?.diedNextAction(map: weakSelf!, node: node, count: 7)
        }
        
        oxZom.behavior.lightingAttackBlock = {(oxNode:WDOXNode) -> Void in
            oxNode.behavior.lightingAttack(personNode: (weakSelf?.personNode)!)
        }
        
        self.addZomNodeForViewArr(node: oxZom)
        return oxZom
    }
    
    
    //MARK:创建骷髅骑士
    func createKulouKnightZom(isBoss:Bool) -> WDKulouKnightNode {
        
        let kulouKnightZom:WDKulouKnightNode = WDKulouKnightNode.init()
        kulouKnightZom.size = CGSize(width:170 ,height:170)
        kulouKnightZom.isBoss = isBoss
        kulouKnightZom.initWithPerson(personNode: map1_scene.personNode)
        map1_scene.bgNode.addChild(kulouKnightZom)
        
        weak var weakSelf = map1_scene
        kulouKnightZom.behavior.starMove()
        kulouKnightZom.behavior.moveBlock = {(node:WDBaseNode) -> Void in
            let direction = WDTool.calculateDirectionForZom(point1: node.position, point2: (weakSelf?.personNode.position)!)
            let knightNode:WDKulouKnightNode = node as! WDKulouKnightNode
            knightNode.behavior.move(direction: direction, nodeDic: ["personNode":weakSelf?.personNode! as Any])
        }
        
        weak var wSelf = self
        kulouKnightZom.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            wSelf?.diedNextAction(map: weakSelf!, node: node, count: 8)
        }
    
        kulouKnightZom.behavior.callAttackBlock = {(kulouKnightNode:WDKulouKnightNode) -> Void in
            kulouKnightNode.behavior.attack(direction: "", nodeDic: ["personNode":weakSelf?.personNode! as Any])
        }
        
        kulouKnightZom.behavior.callKulouBlock = {(kulouKnightNode:WDKulouKnightNode,personNode:WDPersonNode) -> Void in
            wSelf?.kulouKnightCallKulou(point: CGPoint(x:(weakSelf?.personNode.position.x)! + 150,y:(weakSelf?.personNode.position.y)!))
            wSelf?.kulouKnightCallKulou(point: CGPoint(x:(weakSelf?.personNode.position.x)! - 150,y:(weakSelf?.personNode.position.y)!))
            wSelf?.kulouKnightCallKulou(point: CGPoint(x:(weakSelf?.personNode.position.x)!,y:(weakSelf?.personNode.position.y)! + 150))
            wSelf?.kulouKnightCallKulou(point: CGPoint(x:(weakSelf?.personNode.position.x)!,y:(weakSelf?.personNode.position.y)! - 150))
        }
        
        self.addZomNodeForViewArr(node: kulouKnightZom)
        return kulouKnightZom
    }
    
    
    func kulouKnightCallKulou(point:CGPoint) {
        let kulou = self.createKulouZom(isBoss: false)
        kulou.canMove = false
        kulou.isMove  = false
        kulou.isCall  = true
        kulou.position = point
        kulou.alpha = 0
        kulou.wdBlood = 5
        let alphaA = SKAction.fadeAlpha(to: 1, duration: 0.5)
        kulou.run(alphaA) {
            kulou.canMove = true
        }
        self.addZomNodeForViewArr(node: kulou)
    }
    
    //MARK:创建海豹
    func createSealZom(isBoss:Bool) -> WDSealNode {
        let sealZom:WDSealNode = WDSealNode.init()
        sealZom.size = CGSize(width:130 ,height:150)
        sealZom.isBoss = isBoss
        sealZom.initWithPerson(personNode: map1_scene.personNode)
        map1_scene.bgNode.addChild(sealZom)
        
        weak var weakSelf = map1_scene
        sealZom.behavior.starMove()
        sealZom.behavior.moveBlock = {(node:WDBaseNode) -> Void in
            let direction = WDTool.calculateDirectionForZom(point1: node.position, point2: (weakSelf?.personNode.position)!)
            let sealZ:WDSealNode = node as! WDSealNode
            sealZ.behavior.move(direction: direction, nodeDic: ["personNode":weakSelf?.personNode! as Any])
        }
        
        weak var wSelf = self
        sealZom.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            wSelf?.diedNextAction(map: weakSelf!, node: node, count: 8)
        }
        
      
        self.addZomNodeForViewArr(node: sealZom)
        return sealZom
    }
    
    
///////////////////////////公用////////////////
    //MARK:僵尸死亡
    /// 僵尸死亡调用方法
    func diedNextAction(map:WDMap_1Scene,node:WDBaseNode,count:NSInteger) {
        
        let monsterModel:WDMonsterModel = WDMonsterModel.initWithMonsterName(monsterName: node.name!)
        monsterModel.killCount = monsterModel.killCount + 1
        _ = monsterModel.changeMonsterToSqlite()
        
        print(monsterModel.killCount)
       
        let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
        if node.isBoss && model.monsterCount < count{
            model.monsterCount = count
            map.levelUp(model: model)
            map.personNode.createLevelUpNode()
            map.playNext()
            map.overTime(bossNode: node)
        }else if node.isBoss {
            map.playNext()
            map.overTime(bossNode: node)
        }else{
            map.createBoss()
            map.removeNodeFromArr(node:node)
        }
    }
    
    //MARK:添加僵尸进入数组
    /// 将怪物Node添加到数组
    func addZomNodeForViewArr(node:WDBaseNode){
        map1_scene.addZomNode(node:node)
    }
    
}
