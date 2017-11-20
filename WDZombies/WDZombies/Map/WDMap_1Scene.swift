//
//  WDMap_1Scene.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit


class WDMap_1Scene: WDBaseScene,SKPhysicsContactDelegate {
    
    var zomLink:UnsafePointer<Any> = UnsafePointer.init(bitPattern: 10)!
    var zomCount:NSInteger = 0
    var boss1Node:WDBossNode_1! = nil
    var a = 0
    
    
    func createKulou()  {
        
        let kulouNode = WDKulouNode.init()
        kulouNode.size = CGSize(width:110 ,height:130)
        kulouNode.initWithPersonNode(personNode: personNode)
        bgNode.addChild(kulouNode)
        
        let link:CADisplayLink = CADisplayLink.init(target: self, selector: #selector(self.kulouMove(link:)))
        link.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        objc_setAssociatedObject(link, self.zomLink, kulouNode, objc_AssociationPolicy(rawValue: 01401)!)
    }
    
    @objc func kulouMove(link:CADisplayLink) {
        let kulou:WDKulouNode = objc_getAssociatedObject(link, self.zomLink) as! WDKulouNode
        if kulou.wdBlood <= 0 {
            link.invalidate()
        }
        
        let direction = WDTool.calculateDirectionForZom(point1: kulou.position, point2: personNode.position)
        kulou.behavior.moveActionForKulou(direction: direction, personNode: personNode)
    }
    
    func createBoss1() -> Void {
        
        let arr:NSMutableArray = WDTool.cutCustomImage(image: UIImage.init(named: "BOSS1_move")!, line: 2, arrange: 5, size: CGSize(width:183,height:174))
        boss1Node = WDBossNode_1.init(texture:arr.object(at: 0) as? SKTexture)
        boss1Node.position = CGPoint(x:200,y:200)
        boss1Node.initWithPersonNode(personNode: personNode)
        boss1Node.zPosition = 100
        bgNode.addChild(boss1Node)
        
        let link:CADisplayLink = CADisplayLink.init(target: self, selector: #selector(self.bossMove(link:)))
        link.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        objc_setAssociatedObject(link, self.zomLink, boss1Node, objc_AssociationPolicy(rawValue: 01401)!)
    }
    
    //boss移动
    @objc func bossMove(link:CADisplayLink) {
        let boss:WDBossNode_1 = objc_getAssociatedObject(link, self.zomLink) as! WDBossNode_1
        if boss.wdBlood <= 0 {
            link.invalidate()
        }
        
        let direction = WDTool.calculateDirectionForZom(point1: boss.position, point2: personNode.position)
        boss.bossBehavior.moveActionForBoss(direction: direction, personNode: personNode)
    }
    
    
    @objc override func createZombies(timer:Timer){
     
        //50只僵尸
        self.zomCount += 1
        if self.zomCount == 20 {
            timer.invalidate()
        }
        

        
        var arr:NSMutableArray! = nil
        var type:zomType = .Normal
        
        
        if zomCount % 5 == 0 {
             arr = WDTool.cutCustomImage(image: UIImage.init(named: "RedNormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
            type = .Red
        }else{
             arr = WDTool.cutCustomImage(image: UIImage.init(named: "NormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
            type = .Normal
        }
        
       
        let zombieNode:WDZombieNode = WDZombieNode.init(texture:arr.object(at: 0) as? SKTexture)
        zombieNode.initWithZomType(type:type)
        bgNode.addChild(zombieNode)
        
        
        let bornAction:SKAction = SKAction.animate(with: arr as! [SKTexture], timePerFrame: 0.2)
    
        zombieNode.run(bornAction) {
            let link:CADisplayLink = CADisplayLink.init(target: self, selector: #selector(self.zomMove(link:)))
            link.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
            objc_setAssociatedObject(link, self.zomLink, zombieNode, objc_AssociationPolicy(rawValue: 01401)!)
        }
    }
    
 
    
    //僵尸移动
    @objc func zomMove(link:CADisplayLink){
        
        let zom:WDZombieNode = objc_getAssociatedObject(link, self.zomLink) as! WDZombieNode
     
        
        if zom.wdBlood <= 0 {
            link.invalidate()
            return
        }
        
        let direction:NSString = WDTool.calculateDirectionForZom(point1: zom.position, point2: personNode.position)
        zom.zombieBehavior.moveAction(direction: direction)
    }
    
    
    
    //进入方法
    override func didMove(to view: SKView) {
        if !isCreateScene {
           
            self.createNodes()
       
//            let magic:SKSpriteNode = SKSpriteNode.init()
//            magic.color = UIColor.yellow
//            magic.position = CGPoint(x:200,y:200)
//            magic.size = CGSize(width:20,height:20)
//            magic.zPosition = 200
//            bgNode.addChild(magic)
            
            self.physicsWorld.contactDelegate = self
            
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createZombies(timer:)), userInfo: nil, repeats: true)
            let link = CADisplayLink.init(target: self, selector: #selector(mapMoveAction))
            link.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
           
            self.createKulou()
            self.createKulou()

            //self.createBoss1()
            //测试新粒子效果
            //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(testEmitter(timer:)), userInfo: nil, repeats: true)
        }
    }
    
    
    @objc func testEmitter(timer:Timer) {

        a+=1
    }
    
    //开火方法
    override func fireAction(direction: NSString) {
        personNode.personBehavior.attackAction(node: personNode)
        //print(personNode.wdAttack)
    }
    
    //移动
    override func moveAction(direction: NSString) {
        
        personNode.personBehavior.moveAction(direction: direction)
        self.mapMoveAction()
    }
    
    
    //监视移动事件
    @objc func mapMoveAction(){
        
          personNode.position = WDTool.overStepTest(point: personNode.position)
          personNode.zPosition = 3 * 667 - personNode.position.y;
        
          WDMapManager.sharedInstance.setMapPosition(point: personNode.position, mapNode: bgNode)
    }
    
    
    //停止移动
    override func stopMoveAction(direction: NSString) {
        personNode.personBehavior.stopMoveAction(direction: direction)
    }
    
    
    //初始化Nodes
    func createNodes(){
        
        let perDic:NSMutableDictionary = WDTool.cutMoveImage(moveImage: UIImage(named:"person4.png")!)
        
        
        let text:SKTexture = (perDic.object(forKey: kRight)!as! NSMutableArray).object(at: 0) as! SKTexture
        personNode = WDPersonNode.init(texture:text)
        personNode.initWithPersonDic(dic: perDic)
        
        personNode.ggAction = {() -> Void in
            self.gameOver()
        }
        
        bgNode = self.childNode(withName: "landNode") as! SKSpriteNode
        bgNode.position = CGPoint(x:0,y:0)
        bgNode.addChild(personNode)
        
        
       
        let emitter:SKEmitterNode = WDAnimationTool.createEmitterNode(name:"Rain")
        emitter.name = "Rain"
        emitter.zPosition = 5
        emitter.position = CGPoint(x:2001 / 2.0,y:1125 )

        bgNode.addChild(emitter)

    }
    
   
    
    //代理
    func didBegin(_ contact: SKPhysicsContact) {
        let A = contact.bodyA.node;
        let B = contact.bodyB.node;
        
        var pNode:WDPersonNode?
        var zomNode:WDZombieNode?
        var fireNode:SKSpriteNode?
        var boomNode:SKSpriteNode?
        var magicNode:SKEmitterNode?
        var boss1Node:WDBossNode_1?
        var kulouNode:WDKulouNode?

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
            boss1Node?.bossBehavior.attackAction(node: personNode)
          
        }
        
        
        if pNode != nil && zomNode != nil{
            
            let direction:NSString = WDTool.calculateDirectionForZom(point1: zomNode!.position, point2: pNode!.position)
            zomNode?.zombieBehavior.stopMoveAction(direction: direction)
            zomNode?.zombieBehavior.attackAction(node: pNode!)
            
        }
        
        
        if boomNode != nil && zomNode != nil {
            personNode.wdAttack += 5
            zomNode?.zombieBehavior.beAattackAction(attackNode: personNode, beAttackNode: zomNode!)
            personNode.wdAttack -= 5

        }
        
        if magicNode != nil && pNode != nil {
            WDAnimationTool.bloodAnimation(node:personNode)
        }
        
//        if magicNode != nil && zomNode != nil {
//            print("僵尸魔法撞到僵尸了！！！")
//        }
        
        if zomNode != nil && fireNode != nil{
            
            fireNode?.removeFromParent()
            zomNode?.zombieBehavior.beAattackAction(attackNode: personNode, beAttackNode: zomNode!)
        }
        
        if kulouNode != nil && fireNode != nil {
            kulouNode?.behavior.beAattackAction(attackNode: personNode, beAttackNode: kulouNode!)
            fireNode?.removeFromParent()

        }
        
        if kulouNode != nil && boomNode != nil {
            personNode.wdAttack += 5
            kulouNode?.behavior.beAattackAction(attackNode: personNode, beAttackNode: personNode)
            personNode.wdAttack -= 5

        }
        
        if kulouNode != nil && pNode != nil {
            kulouNode?.behavior.attackAction(node: personNode)
        }
        
    }
    
    
    
    func didEnd(_ contact: SKPhysicsContact) {
//        let A = contact.bodyA.node;
//        let B = contact.bodyB.node;
    }
    
    
    override func gameOver() {
        self.removeAllChildren()
        ggAction()
    }
    
}
