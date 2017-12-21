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
    
    static let ZOMCOUNT = 20
    let BOSS_BLOOD:CGFloat = 20.0
    let BOSS_ATTACK:CGFloat = 3.0
    
    var boomModel:WDSkillModel!        //技能model，用于查看炸弹伤害
 
    
    var normalZomArr:NSMutableArray!   //存储创建的zom
    var kulouZomArr:NSMutableArray!    //存储骷髅
    var greenZomArr:NSMutableArray!    //存储绿色僵尸
    
    
    var createZomTimer:Timer!          //创建zom的timer
    var mapLink:CADisplayLink!         //监测地图移动的link
    var zomCount:NSInteger = 0         //创建的僵尸个数
    var diedZomCount:NSInteger = 0     //击杀僵尸个数
    
    var diedZomLabel:SKLabelNode!
    var level:NSInteger!
    
    let mapViewModel:WDMap_1ViewModel = WDMap_1ViewModel.init()

    
    
    //进入方法
    override func didMove(to view: SKView) {
       
        if !isCreateScene {
           
            normalZomArr = NSMutableArray.init()
            kulouZomArr  = NSMutableArray.init()
            greenZomArr  = NSMutableArray.init()
            
            //需要获取炸弹伤害
            boomModel = WDSkillModel.init()
            boomModel.skillName = BOOM
            
            if boomModel.searchToDB(){
                print("炸弹Model伤害就位")
            }
            
            self.createNodes()
            self.physicsWorld.contactDelegate = self
            
            createZomTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createZombies(timer:)), userInfo: nil, repeats: true)
           
            mapLink = CADisplayLink.init(target: self, selector: #selector(mapMoveAction))
            mapLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
           
            //self.createBoss1()
            //self.level_5_BossAction(isBoss: true)
            //测试新粒子效果
            //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(testEmitter(timer:)), userInfo: nil, repeats: true)
        }
    }
    
    //初始化Nodes
    func createNodes(){
        
        diedZomLabel = SKLabelNode.init(text: "\(self.diedZomCount)/\(WDMap_1Scene.ZOMCOUNT)")
        diedZomLabel.fontName = "VCR OSD Mono"
        diedZomLabel.fontColor = UIColor.red
        diedZomLabel.fontSize = 30
        diedZomLabel.verticalAlignmentMode = .center
        diedZomLabel.alpha = 0.6
        print(diedZomLabel.frame.size.width,diedZomLabel.frame.size.height)
        
        diedZomLabel.position = CGPoint(x:diedZomLabel.frame.size.width / 2.0 + 10,y:self.frame.size.height - diedZomLabel.frame.size.height / 2.0 - 10)
        diedZomLabel.color = UIColor.black
        diedZomLabel.zPosition = 10000
        self.addChild(diedZomLabel)
        
        print(kScreenHeight,self.frame.size.height)
        
        
        let perDic:NSMutableDictionary = WDTool.cutMoveImage(moveImage: UIImage(named:"person4.png")!)
        let text:SKTexture = (perDic.object(forKey: kRight)!as! NSMutableArray).object(at: 0) as! SKTexture
        
        personNode = WDPersonNode.init(texture:text)
        personNode.initWithPersonDic(dic: perDic)
        
        weak var weakSelf = self
        personNode.ggAction = {() -> Void in
            print("haha")
            weakSelf?.gameOver()
        }
        
        bgNode = self.childNode(withName: "landNode") as! SKSpriteNode
        bgNode.position = CGPoint(x:0,y:0)
        bgNode.addChild(personNode)
    }
    
   
    
    
    
    //normal/red僵尸相关
    @objc override func createZombies(timer:Timer){
        //50只僵尸
        self.zomCount += 1
        if self.zomCount == WDMap_1Scene.ZOMCOUNT {
            timer.invalidate()
        }
        
        var arr:NSMutableArray! = nil
        var type:zomType = .Normal
        
        if level == 1 {
           arr = WDTool.cutCustomImage(image: UIImage.init(named: "NormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
           type = .Normal
            
        }else if level == 2{
            arr = WDTool.cutCustomImage(image: UIImage.init(named: "NormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
            type = .Normal
         
        }else if level == 3{
            let chance = arc4random() % 10
            if chance > 7 {
                arr = WDTool.cutCustomImage(image: UIImage.init(named: "RedNormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
                type = .Red
            }else{
                arr = WDTool.cutCustomImage(image: UIImage.init(named: "NormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
                type = .Normal
            }
        }else if level == 4{
            let chance = arc4random() % 10
            if chance > 7{
                arr = WDTool.cutCustomImage(image: UIImage.init(named: "RedNormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
                type = .Red
            } else if chance == 7{
                self.level_3_BossAction(isBoss: false)
                return
            }else {
                arr = WDTool.cutCustomImage(image: UIImage.init(named: "NormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
                type = .Normal
            }
        }else if level == 5{
            let chance = arc4random() % 10
            
            if chance == 6{
                arr = WDTool.cutCustomImage(image: UIImage.init(named: "RedNormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
                type = .Red
            } else if chance == 7{
                self.level_3_BossAction(isBoss: false)
                return
            }else if chance == 8{
                self.level_4_BossAction(isBoss: false)
                return
            }else {
                arr = WDTool.cutCustomImage(image: UIImage.init(named: "NormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
                type = .Normal
            }
        }
       
        
        
        let zombieNode:WDZombieNode = WDZombieNode.init(texture:arr.object(at: 0) as? SKTexture)
        zombieNode.initWithZomType(type:type)
        bgNode.addChild(zombieNode)
        
        normalZomArr.add(zombieNode)
        
        //僵尸移动
        weak var weakSelf = self
        zombieNode.moveAction = {(zom:WDZombieNode) -> Void in
            let direction:NSString = WDTool.calculateDirectionForZom(point1: (zom.position), point2: weakSelf!.personNode.position)
            zom.zombieBehavior.moveAction(direction: direction)
        }
        
        //僵尸死亡
        zombieNode.zombieBehavior.alreadyDied = {(node:WDBaseNode) -> Void in
            weakSelf?.createBoss()
        }
        
        
        //红色僵尸发动攻击<之前造成循环引用 -> 直接使用 zombieNode 来调用方法，如下注释>
        //zombieNode.zombieBehavior.redAttackAction(node: (weakSelf?.personNode)!
        zombieNode.redAttackAction = {(zom:WDZombieNode) -> Void in
            zom.zombieBehavior.redAttackAction(node: (weakSelf?.personNode)!)
        }
        
        
        let bornAction:SKAction = SKAction.animate(with: arr as! [SKTexture], timePerFrame: 0.2)
        zombieNode.run(bornAction) {
            zombieNode.starMove()
        }
    }
 
    
    func createBoss()  {
        self.diedZomCount += 1
        if self.diedZomCount >= WDMap_1Scene.ZOMCOUNT {
            //根据等级召唤boss
            if self.level == 1{
                self.level_1_BossAction(isBoss: true)
            }else if self.level == 2{
                self.level_2_BossAction(isBoss: true)
            }else if self.level == 3{
                self.level_3_BossAction(isBoss: true)
            }else if self.level == 4{
                self.level_4_BossAction(isBoss: true)
            }else if self.level == 5{
                self.level_5_BossAction(isBoss: true)
            }
        }
      
    }
    
    func levelUp(model:WDUserModel)  {
        
        model.skillCount += 1
        _ = model.changeSkillToSqlite()
        WDDataManager.shareInstance().closeDB()
    }
    
    func level_1_BossAction(isBoss:Bool)  {
        
        let arr:NSMutableArray = WDTool.cutCustomImage(image: UIImage.init(named: "NormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
        let type:zomType = .Normal
        let zombieNode:WDZombieNode = WDZombieNode.init(texture:arr.object(at: 0) as? SKTexture)
        zombieNode.initWithZomType(type:type)
        zombieNode.xScale = 2.0
        zombieNode.yScale = 2.0
        zombieNode.isBoss = isBoss
        bgNode.addChild(zombieNode)
        
        normalZomArr.add(zombieNode)
        
        //僵尸移动
        weak var weakSelf = self
        zombieNode.moveAction = {(zom:WDZombieNode) -> Void in
            let direction:NSString = WDTool.calculateDirectionForZom(point1: (zom.position), point2: weakSelf!.personNode.position)
            zom.zombieBehavior.moveAction(direction: direction)
        }
        
        //僵尸死亡
        zombieNode.zombieBehavior.alreadyDied = {(node:WDBaseNode) -> Void in
            let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
            if  node.isBoss && model.monsterCount < 1{
                model.monsterCount = 1
                self.levelUp(model: model)
                weakSelf?.personNode.createLevelUpNode()
                weakSelf?.playNext()
            }else if node.isBoss {
                weakSelf?.playNext()
            }
            
        }
        
        let bornAction:SKAction = SKAction.animate(with: arr as! [SKTexture], timePerFrame: 0.2)
        zombieNode.position = personNode.position
        zombieNode.removePhy()
        zombieNode.run(bornAction) {
            zombieNode.starMove()
            zombieNode.wdBlood = self.BOSS_BLOOD
            zombieNode.wdAttack = self.BOSS_ATTACK
            zombieNode.isBoss = true
            zombieNode.bossPhy()

        }
    }
    
    func level_2_BossAction(isBoss:Bool)  {
        let arr:NSMutableArray = WDTool.cutCustomImage(image: UIImage.init(named: "RedNormalBorn.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:59))
        let type:zomType = .Red
        let zombieNode:WDZombieNode = WDZombieNode.init(texture:arr.object(at: 0) as? SKTexture)
        zombieNode.initWithZomType(type:type)
        zombieNode.xScale = 2.0
        zombieNode.yScale = 2.0
        zombieNode.isBoss = isBoss
        bgNode.addChild(zombieNode)
        
        normalZomArr.add(zombieNode)
        
        //僵尸移动
        weak var weakSelf = self
        zombieNode.moveAction = {(zom:WDZombieNode) -> Void in
            let direction:NSString = WDTool.calculateDirectionForZom(point1: (zom.position), point2: weakSelf!.personNode.position)
            zom.zombieBehavior.moveAction(direction: direction)
        }
        
        //僵尸死亡
        zombieNode.zombieBehavior.alreadyDied = {(node:WDBaseNode) -> Void in
            let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
          
            
            if node.isBoss && model.monsterCount < 2{
                model.monsterCount = 2
                self.levelUp(model: model)
                weakSelf?.personNode.createLevelUpNode()
                weakSelf?.playNext()
            }else if node.isBoss {
                weakSelf?.playNext()
            }
        }
        
        //红色僵尸发动攻击<之前造成循环引用 -> 直接使用 zombieNode 来调用方法，如下注释>
        //zombieNode.zombieBehavior.redAttackAction(node: (weakSelf?.personNode)!
        zombieNode.redAttackAction = {(zom:WDZombieNode) -> Void in
            zom.zombieBehavior.redAttackAction(node: (weakSelf?.personNode)!)
        }
        
        let bornAction:SKAction = SKAction.animate(with: arr as! [SKTexture], timePerFrame: 0.2)
        zombieNode.position = personNode.position
        zombieNode.removePhy()
        zombieNode.run(bornAction) {
            zombieNode.starMove()
            zombieNode.wdBlood = self.BOSS_BLOOD
            zombieNode.wdAttack = self.BOSS_ATTACK
            zombieNode.isBoss = true
            zombieNode.bossPhy()

        }
        
    }

    //骷髅相关
    func level_3_BossAction(isBoss:Bool)  {
        
        let kulouNode:WDKulouNode = WDKulouNode.init()
        kulouNode.size = CGSize(width:110 ,height:130)
        kulouNode.isBoss = isBoss
        kulouNode.initWithPersonNode(personNode: personNode)
        bgNode.addChild(kulouNode)
        
        //骷髅死亡，可以升级加技能
        weak var weakSelf = self
        kulouNode.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
          
            if node.isBoss && model.monsterCount < 3 {
                weakSelf?.playNext()
                model.monsterCount = 3
                self.levelUp(model: model)
                weakSelf?.personNode.createLevelUpNode()
            }else if node.isBoss {
                weakSelf?.playNext()
            }else {
                weakSelf?.createBoss()
            }
        }
        
        
        
        //骷髅移动
        kulouNode.starMove()
        kulouNode.moveAction = {(kulou:WDKulouNode) -> Void in
            let direction = WDTool.calculateDirectionForZom(point1: kulou.position, point2: (weakSelf?.personNode.position)!)
            kulou.behavior.moveActionForKulou(direction: direction, personNode: (weakSelf?.personNode)!)
        }
        
        //骷髅攻击
        kulouNode.attack2 = {(kulou:WDKulouNode) -> Void in
            kulou.behavior.attack2Action(personNode: (weakSelf?.personNode)!)
        }
        
        kulouZomArr.add(kulouNode)
    }
    
    //绿色僵尸
    func level_4_BossAction(isBoss:Bool)  {
        
        let greenZom = WDGreenZomNode.init()
        greenZom.size = CGSize(width:125,height:125)
        
        greenZom.isBoss = isBoss
        greenZom.initWithPersonNode(personNode: personNode)
        bgNode.addChild(greenZom)
      
        greenZom.starMove()
        
        //绿色僵尸移动
        weak var weakSelf = self
        greenZom.moveAction = {(greenNode:WDGreenZomNode) -> Void in
            let direction = WDTool.calculateDirectionForZom(point1: greenNode.position, point2: (weakSelf?.personNode.position)!)
            greenNode.behavior.moveActionForGreen(direction: direction, personNode: (weakSelf?.personNode)!)
        }
        
        //绿色僵尸吐雾攻击
        greenZom.attack2Action = {(greenNode:WDGreenZomNode) -> Void in
            greenZom.behavior.attack2Action(personNode: (weakSelf?.personNode)!)
        }
        
        //绿色僵尸攻击1
        greenZom.attack1Action = {(greenNode:WDGreenZomNode) -> Void in
            greenZom.behavior.attack1Action(personNode: (weakSelf?.personNode)!)
        }
        
        //绿色僵尸死亡
        greenZom.behavior.alreadyDied = {(node:WDBaseNode) -> Void in
            let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
          
            if node.isBoss && model.monsterCount < 4{
                model.monsterCount = 4
                self.levelUp(model: model)
                weakSelf?.personNode.createLevelUpNode()
                weakSelf?.playNext()
            }else if node.isBoss{
                weakSelf?.playNext()
            }else {
                weakSelf?.createBoss()
            }
        }
        
        greenZomArr.add(greenZom)

        
    }
    
    //雾骑士
    func level_5_BossAction(isBoss:Bool)  {
        let kNight:WDSmokeKnightNode = WDSmokeKnightNode.init()
        kNight.size = CGSize(width:165,height:165)
        kNight.isBoss = true
        kNight.initWithPersonNode(personNode: personNode)
        bgNode.addChild(kNight)
        kNight.starMove()
       
        weak var weakSelf = self
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
                self.levelUp(model: model)
                weakSelf?.personNode.createLevelUpNode()
                weakSelf?.playNext()
            }else if knightNode.isBoss{
                weakSelf?.playNext()
            }else {
                weakSelf?.createBoss()
            }
        }
        
    }
    
    @objc func testEmitter(timer:Timer) {
    }
    
    //开火方法
    override func fireAction(direction: NSString) {
        personNode?.personBehavior.attackAction(node: personNode)
    }
    
    //移动
    override func moveAction(direction: NSString) {
        if personNode != nil{
            personNode.personBehavior.moveAction(direction: direction)
            self.mapMoveAction()
        }
    }
    
    
    //监视移动事件
    @objc func mapMoveAction(){
        if personNode != nil {
            personNode.position = WDTool.overStepTest(point: personNode.position)
            personNode.zPosition = 3 * 667 - personNode.position.y;
            WDMapManager.sharedInstance.setMapPosition(point: personNode.position, mapNode: bgNode)
            //击杀个数
            diedZomLabel.text = "\(self.diedZomCount)/\(WDMap_1Scene.ZOMCOUNT)"
        }
        
    }
    
    
    //停止移动
    override func stopMoveAction(direction: NSString) {
        if personNode != nil{
            personNode.personBehavior.stopMoveAction(direction: direction)
        }
    }
    
    
    //代理
    func didBegin(_ contact: SKPhysicsContact) {
        mapViewModel.phyContact(contact:contact, personNode: personNode, boomModel: boomModel)
    }
    
    
    
    
    func didEnd(_ contact: SKPhysicsContact) {

    }
    
    
    func playNext()  {
        
        self.removeNode()
        self.nextAction()
    }
    
    @objc override func gameOver() {
        
        self.removeNode()
        self.ggAction()
    }
    
    func removeNode()  {
        
        createZomTimer.invalidate()
        if mapLink != nil {
            mapLink.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
            mapLink.invalidate()
            mapLink = nil
        }
        
        
        //删除所有僵尸
        if normalZomArr != nil && normalZomArr.count > 0{
            for index:NSInteger in 0...normalZomArr.count - 1 {
                var zom:WDZombieNode? = normalZomArr.object(at: index) as? WDZombieNode
                
                zom?.clearAction()
                zom?.removeAllActions()
                zom?.removeAllChildren()
                zom?.removeFromParent()
                zom = nil
            }
            
            normalZomArr.removeAllObjects()
            normalZomArr = nil
        }
        
        //删除所有骷髅
        if kulouZomArr != nil && kulouZomArr.count > 0{
            for index:NSInteger in 0...kulouZomArr.count - 1 {
                var kulou:WDKulouNode? = kulouZomArr.object(at: index) as? WDKulouNode
                kulou?.clearAction()
                kulou?.removeAllActions()
                kulou?.removeAllChildren()
                kulou?.removeFromParent()
                kulou = nil
            }
        }
        
        if greenZomArr != nil && greenZomArr.count > 0{
            for index:NSInteger in 0...greenZomArr.count - 1 {
                var greenZom:WDGreenZomNode? = greenZomArr.object(at: index) as? WDGreenZomNode
                greenZom?.clearAction()
                greenZom?.removeAllActions()
                greenZom?.removeAllChildren()
                greenZom?.removeFromParent()
                greenZom = nil
            }
        }
        
        self.isCreateScene = false
    }
    
    
    deinit {
        print("地图1被释放了！！！！！！！！！")
    }
    
}
