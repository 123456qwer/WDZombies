 //
//  WDMap_1Scene.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit
 
 
public let LAST_LEVEL = 11
 
class WDMap_1Scene: WDBaseScene,SKPhysicsContactDelegate {
    
    var score:CGFloat = 0
    
    let ZOMCOUNT = 10
    let BOSS_BLOOD:CGFloat = 20.0
    let BOSS_ATTACK:CGFloat = 3.0
    
    var boomModel:WDSkillModel!        //技能model，用于查看炸弹伤害
 
    
    var fly_timer:Timer!               //辅助机计时器
    var createZomTimer:Timer!          //创建zom的timer
    var mapLink:CADisplayLink!         //监测地图移动的link
    var zomLink:CADisplayLink!         //监测僵尸移动的link
    var nearZom:WDBaseNode!

    var diedOrPass:Bool = false               //判断是否过关了,避免同时跳出下一关和gg的提示
    
    var zomCount:NSInteger = 0         //创建的僵尸个数
    var diedZomCount:NSInteger = 0     //击杀僵尸个数
    
    var diedZomLabel:SKLabelNode!
    var level:NSInteger!
    
    var overTimeLabel:SKLabelNode!   //通关时间
    var overTimer:Timer!
    var times:NSInteger = 0
    var levelNode:SKLabelNode!       //等级
    var bloodNode:SKSpriteNode!      //血条
    
    let mapViewModel:WDMap_1ViewModel = WDMap_1ViewModel.init() //处理逻辑
    let mapZomModel:WDMap_1ZomModel   = WDMap_1ZomModel.init()  //处理僵尸
    
    var _radius:CGFloat = 0
    var _arcCenter:CGPoint = CGPoint(x:0,y:0)
    var _startAngle:CGFloat = 0
    var _endAngle:CGFloat = 0
    var _lineWidth:CGFloat = 0
    
    
    //进入方法
    override func didMove(to view: SKView) {
       
        if !isCreateScene {

            let _:WDMusicManager = WDMusicManager.shareInstance
            
            
            mapZomModel.map1_scene = self
            
            //需要获取炸弹伤害
            boomModel = WDSkillModel.init()
            boomModel.skillName = BOOM
            
            if boomModel.searchToDB(){
                print("炸弹Model伤害就位")
            }
            
            self.createNodes()
            self.physicsWorld.contactDelegate = self
            
            createZomTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createZombies(timer:)), userInfo: nil, repeats: true)
            fly_timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(autoFireAction), userInfo: nil, repeats: true)
            overTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(overTimerAction), userInfo: nil, repeats: true)
            
            mapLink = CADisplayLink.init(target: self, selector: #selector(mapMoveAction))
            mapLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
            
            zomLink = CADisplayLink.init(target: self, selector: #selector(zomMoveAction))
            zomLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
            
            //self.level_3_KulouZom(isBoss: false)
            //测试新粒子效果
            //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(testEmitter(timer:)), userInfo: nil, repeats: true)
        }
    }
    
    //最近zom
    @objc func zomMoveAction()  {
        var distance:CGFloat = 1000
        if mapViewModel.zomArr.count > 0 {
            for index:NSInteger in 0...mapViewModel.zomArr.count - 1{
                let zom:WDBaseNode = mapViewModel.zomArr[index] as! WDBaseNode
                let nowDistance = WDTool.calculateNodesDistance(point1: zom.position, point2: personNode.position)
                if nowDistance < distance{
                    nearZom = zom
                    distance = nowDistance
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      // print("hahaha")
       
    }
    
   @objc func overTimerAction()  {
        times = times + 1
        let second:NSInteger = times % 60
        let minute:NSInteger = times / 60
        let str:String = String(format: "%02d:%02d", arguments: [minute, second])
        overTimeLabel.text = str
    }
    
    
    //初始化Nodes
    func createNodes(){
        
        if level == LAST_LEVEL {
            diedZomLabel = SKLabelNode.init(text: "score:0")
        }else{
            diedZomLabel = SKLabelNode.init(text: "0/\(ZOMCOUNT)")
        }
        diedZomLabel.fontName = "VCR OSD Mono"
        diedZomLabel.fontColor = UIColor.red
        diedZomLabel.fontSize = 30
        diedZomLabel.verticalAlignmentMode = .center
        diedZomLabel.alpha = 0.6
        
        diedZomLabel.position = CGPoint(x:diedZomLabel.frame.size.width / 2.0 + 300,y:self.frame.size.height - diedZomLabel.frame.size.height / 2.0 - 10)
        diedZomLabel.color = UIColor.black
        diedZomLabel.zPosition = 10000
        self.addChild(diedZomLabel)
        
        overTimeLabel = SKLabelNode.init(text: "00:00")
        overTimeLabel.fontName = "VCR OSD Mono"
        overTimeLabel.fontColor = UIColor.red
        overTimeLabel.fontSize = 30
        overTimeLabel.verticalAlignmentMode = .center
        overTimeLabel.alpha = 0.6
        
        overTimeLabel.position = CGPoint(x:self.frame.size.width - overTimeLabel.frame.size.width - 10,y:self.frame.size.height - overTimeLabel.frame.size.height / 2.0 - 10)
        overTimeLabel.color = UIColor.black
        overTimeLabel.zPosition = 10000
        self.addChild(overTimeLabel)
        
        
        let perDic:NSMutableDictionary = WDTool.cutMoveImage(moveImage: UIImage(named:"person4.png")!)
        let text:SKTexture = (perDic.object(forKey: kRight)!as! NSMutableArray).object(at: 0) as! SKTexture
        
        personNode = WDPersonNode.init(texture:text)
        personNode.initWithPersonDic(dic: perDic)
        
        weak var weakSelf = self
        personNode.ggAction = {() -> Void in
            print("haha")
            weakSelf?.gameOver()
        }
        
        personNode.personBehavior.reduceBloodBlock = {() -> Void in
            weakSelf?.reduceBlood()
        }
        
        bgNode = self.childNode(withName: "landNode") as! SKSpriteNode
        bgNode.position = CGPoint(x:0,y:0)
        bgNode.addChild(personNode)
        
        
        
        
        //边界，云层
        let big1:SKSpriteNode = bgNode.childNode(withName: "big1") as! SKSpriteNode
        let big2:SKSpriteNode = bgNode.childNode(withName: "big2") as! SKSpriteNode
        let big3:SKSpriteNode = bgNode.childNode(withName: "big3") as! SKSpriteNode
        let big4:SKSpriteNode = bgNode.childNode(withName: "big4") as! SKSpriteNode

        let alpha1 = SKAction.fadeAlpha(to: 0.6, duration: 3)
        let alpha2 = SKAction.fadeAlpha(to: 1, duration: 1)
        let seq = SKAction.sequence([alpha1,alpha2])
        let rep = SKAction.repeatForever(seq)
        big1.run(rep)
        big2.run(rep)
        big3.run(rep)
        big4.run(rep)
        
        
        let texture = SKTexture.init(image: UIImage.init(named: "levelBg2")!)
        let levelBg2:SKSpriteNode = SKSpriteNode.init(color: UIColor.black, size: CGSize(width:150 / 2.0,height:150 / 2.0))
     
        levelBg2.position = CGPoint(x:7 + levelBg2.size.width / 2.0, y:self.frame.size.height - 7 - levelBg2.size.height / 2.0)
        levelBg2.zPosition = 4000
        print(levelBg2.size)
        self.addChild(levelBg2)
        levelBg2.texture = texture
        
        let texture4 = SKTexture.init(image: UIImage.init(named: "levelBg")!)
        let levelBg:SKSpriteNode = SKSpriteNode.init(color: UIColor.cyan, size: CGSize(width:136 / 2.0,height:136 / 2.0))
        
        levelBg.position = levelBg2.position
        levelBg.zPosition = 3000
        print(levelBg.size)
        levelBg.texture = texture4

        self.addChild(levelBg)
        
        print(levelBg,levelBg2)
        
        let model:WDUserModel = WDUserModel.init()
        _ = model.searchToDB()
        
        levelNode = SKLabelNode.init(text: "\(model.level)")
        levelNode.fontName = "VCR OSD Mono"
        levelNode.position = CGPoint(x:0,y:0)
        levelNode.zPosition = 3000
        levelNode.fontColor = UIColor.white
        levelNode.fontSize = 40
        levelNode.verticalAlignmentMode = .center
        levelNode.alpha = 0.6
        levelBg.addChild(levelNode)
        

       
        
        let texture1 = SKTexture.init(image: UIImage.init(named: "blood_tiao")!)
        bloodNode = SKSpriteNode.init(texture: texture1)
        bloodNode.xScale = 0.5
        bloodNode.yScale = 0.5
        bloodNode.zPosition = 3000
        bloodNode.alpha = 0.5
        bloodNode.position = CGPoint(x:10 + levelBg.size.width ,y:levelBg.position.y)
        self.addChild(bloodNode)
        
        let colorAction = SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.1, duration: 1)
        let colorAction2 = SKAction.colorize(with: UIColor.red, colorBlendFactor: 0, duration: 1)
        let seqa = SKAction.sequence([colorAction,colorAction2])
        let repa = SKAction.repeatForever(seqa)
        bloodNode.run(repa, withKey: "bloodA")
        bloodNode.anchorPoint = CGPoint(x:0,y:0.5)
        
        let exWidth:CGFloat = 4
        let radius = levelBg2.size.width / 2.0 - exWidth/2.0
      
        _radius = radius
        _arcCenter = levelBg.position
        _startAngle = 0
        _endAngle = CGFloat(Double.pi / 2.0)
        _lineWidth = exWidth
        
        self.perform(#selector(aaa), with: nil, afterDelay: 2)
    }
    
    @objc func aaa(){
        setExperienceBlock!(_radius,_arcCenter,_startAngle,_endAngle,_lineWidth)
    }
   
    
    //normal/red僵尸相关
    @objc override func createZombies(timer:Timer){
        //开始创建僵尸
        if level == LAST_LEVEL {
        
            if self.zomCount == ZOMCOUNT{
                return
            }
            
            self.zomCount += 1
            
            let chance = arc4random() % 10
            //print("无尽模式")
            if chance == 3{
                self.level_3_KulouZom(isBoss: false)
            }else if chance == 2 {
                self.level_2_RedZom(isBoss: false)
            }else if chance == 4{
                self.level_4_GreenZom(isBoss: false)
            }else if chance == 5{
                self.level_5_KnightZom(isBoss: false)
            }else if chance == 6{
                self.level_6_SquidZom(isBoss: false)
            }else if chance == 7{
                self.level_7_OXZom(isBoss: false)
            }else if chance == 8{
                self.level_8_kulouKnightZom(isBoss: false)
            }else if chance == 9{
                self.level_9_sealZom(isBoss: false)
            }else if chance == 1{
                self.level_1_NormalZom(isBoss: false)
            }else{
                self.level_10_dogZom(isBoss: false)
            }
            
        }else{
            
            self.zomCount += 1
            if self.zomCount == ZOMCOUNT {
                timer.invalidate()
            }

            let chance = arc4random() % 10
            
            if level == 1{
                self.level_1_NormalZom(isBoss: false)
            }else if level == 2{
                self.level_1_NormalZom(isBoss: false)
            }else if level == 3{
                if chance == 8 {
                    self.level_2_RedZom(isBoss: false)
                }else{
                    self.level_1_NormalZom(isBoss: false)
                }
            }else if level == 4{
                
                if chance == 7{
                    self.level_3_KulouZom(isBoss: false)
                }else if chance == 8 {
                    self.level_2_RedZom(isBoss: false)
                }else{
                    self.level_1_NormalZom(isBoss: false)
                }
            }else if level == 5{
                if chance == 7{
                    self.level_3_KulouZom(isBoss: false)
                }else if chance == 8 {
                    self.level_2_RedZom(isBoss: false)
                }else if chance == 9{
                    self.level_4_GreenZom(isBoss: false)
                }else {
                    self.level_1_NormalZom(isBoss: false)
                }
            }else if level == 6{
                if chance == 7{
                    self.level_3_KulouZom(isBoss: false)
                }else if chance == 8 {
                    self.level_2_RedZom(isBoss: false)
                }else if chance == 9{
                    self.level_4_GreenZom(isBoss: false)
                }else if chance == 0{
                    self.level_5_KnightZom(isBoss: false)
                }else{
                    self.level_1_NormalZom(isBoss: false)
                }
            }else if level == 7{
                if chance == 7{
                    self.level_3_KulouZom(isBoss: false)
                }else if chance == 8 {
                    self.level_2_RedZom(isBoss: false)
                }else if chance == 9{
                    self.level_4_GreenZom(isBoss: false)
                }else if chance == 0{
                    self.level_5_KnightZom(isBoss: false)
                }else if chance == 6{
                    self.level_6_SquidZom(isBoss: false)
                }else{
                    self.level_1_NormalZom(isBoss: false)
                }
            }else if level == 8{
                if chance == 7{
                    self.level_3_KulouZom(isBoss: false)
                }else if chance == 8 {
                    self.level_2_RedZom(isBoss: false)
                }else if chance == 9{
                    self.level_4_GreenZom(isBoss: false)
                }else if chance == 0{
                    self.level_5_KnightZom(isBoss: false)
                }else if chance == 6{
                    self.level_6_SquidZom(isBoss: false)
                }else if chance == 5{
                    self.level_7_OXZom(isBoss: false)
                }else {
                    self.level_1_NormalZom(isBoss: false)
                }
            }else if level == 9{
                if chance == 7{
                    self.level_3_KulouZom(isBoss: false)
                }else if chance == 8 {
                    self.level_2_RedZom(isBoss: false)
                }else if chance == 9{
                    self.level_4_GreenZom(isBoss: false)
                }else if chance == 0{
                    self.level_5_KnightZom(isBoss: false)
                }else if chance == 6{
                    self.level_6_SquidZom(isBoss: false)
                }else if chance == 5{
                    self.level_7_OXZom(isBoss: false)
                }else if chance == 4{
                    self.level_8_kulouKnightZom(isBoss: false)
                }else{
                    self.level_1_NormalZom(isBoss: false)
                }
            }else if level == 10{
                if chance == 7{
                    self.level_3_KulouZom(isBoss: false)
                }else if chance == 8 {
                    self.level_2_RedZom(isBoss: false)
                }else if chance == 9{
                    self.level_4_GreenZom(isBoss: false)
                }else if chance == 0{
                    self.level_5_KnightZom(isBoss: false)
                }else if chance == 6{
                    self.level_6_SquidZom(isBoss: false)
                }else if chance == 5{
                    self.level_7_OXZom(isBoss: false)
                }else if chance == 4{
                    self.level_8_kulouKnightZom(isBoss: false)
                }else if chance == 3{
                    self.level_9_sealZom(isBoss: false)
                }else{
                    self.level_1_NormalZom(isBoss: false)
                }
            }
        }
        
       
 
    }
 
    
   
    //MARK:创建僵尸相关
 //******************************************************//
    //普通僵尸
    func level_1_NormalZom(isBoss:Bool)  {
        _ = mapZomModel.createNormalZom(isBoss: isBoss)
    }
 
    
    //红色僵尸
    func level_2_RedZom(isBoss:Bool)  {
        _ = mapZomModel.createRedZom(isBoss: isBoss)
    }

    
    //骷髅相关
    func level_3_KulouZom(isBoss:Bool)  {
        _ = mapZomModel.createKulouZom(isBoss: isBoss)
    }

    
    //绿色僵尸
    func level_4_GreenZom(isBoss:Bool)  {
        _ = mapZomModel.createGreenZom(isBoss: isBoss)
    }
    
    //雾骑士
    func level_5_KnightZom(isBoss:Bool)  {
        _ = mapZomModel.createKnightZom(isBoss: isBoss)
    }
    
    //鱿鱼
    func level_6_SquidZom(isBoss:Bool)  {
        _ = mapZomModel.createSquidZom(isBoss:isBoss)
    }
    
    //公牛
    func level_7_OXZom(isBoss:Bool) {
        _ = mapZomModel.createOXZom(isBoss: isBoss)
    }
    
    //骷髅骑士
    func level_8_kulouKnightZom(isBoss:Bool) {
        _ = mapZomModel.createKulouKnightZom(isBoss: isBoss)
    }
    
    //海豹
    func level_9_sealZom(isBoss:Bool) {
        _ = mapZomModel.createSealZom(isBoss: isBoss)
    }
    
    //狗
    func level_10_dogZom(isBoss:Bool) {
        _ = mapZomModel.createDogZom(isBoss: isBoss)
    }
    
    
    //从数组中删除Node方法
    func removeNodeFromArr(node:WDBaseNode){
        if setExperienceBlock != nil {
            
            if WDUserModel.addExperience(nodeExperience: NSInteger(node.experience)){
                let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
                levelNode.text = "\(model.level)"
                self.personNode.createLevelUpNode()
            }
            
            setExperienceBlock!(_radius,_arcCenter,_startAngle,_endAngle,_lineWidth)
            _startAngle = _endAngle
            _endAngle   = _endAngle + CGFloat(Double.pi / 2.0)
        }
        
        //得分
        if level == LAST_LEVEL{
            score = score + node.experience
            diedZomLabel.text = "score:\(score)"
           
            if self.diedZomCount == ZOMCOUNT{
                self.diedZomCount = 0
                self.zomCount = 0
            }
            
        }else{
            diedZomLabel.text = "\(self.diedZomCount)/\(ZOMCOUNT)"
        }

        mapViewModel.removeNode(zomNode: node)
        mapViewModel.zomArr.remove(node)
        if nearZom == node{
            nearZom = nil
        }
    }

    
    func addZomNode(node:WDBaseNode){
        mapViewModel.zomArr.add(node)
    }
    
    
    func createBoss()  {
        
        if level == LAST_LEVEL {
            self.diedZomCount += 1
        }else{
            self.diedZomCount += 1
            if self.diedZomCount >= ZOMCOUNT {
                //根据等级召唤boss
                if self.level == 1{
                    self.level_1_NormalZom(isBoss: true)
                }else if self.level == 2{
                    self.level_2_RedZom(isBoss: true)
                }else if self.level == 3{
                    self.level_3_KulouZom(isBoss: true)
                }else if self.level == 4{
                    self.level_4_GreenZom(isBoss: true)
                }else if self.level == 5{
                    self.level_5_KnightZom(isBoss: true)
                }else if self.level == 6{
                    self.level_6_SquidZom(isBoss: true)
                }else if self.level == 7{
                    self.level_7_OXZom(isBoss: true)
                }else if self.level == 8{
                    self.level_8_kulouKnightZom(isBoss: true)
                }else if self.level == 9{
                    self.level_9_sealZom(isBoss: true)
                }else if self.level == 10{
                    self.level_10_dogZom(isBoss: true)
                }
            }
        }
        
        
    }
    
    //******************************************************//

    //主页血条
    func reduceBlood() {
        if personNode.wdBlood <= 0 {
            bloodNode.removeAllActions()
            bloodNode.removeFromParent()
        }
        bloodNode.removeAction(forKey: "bloodA")
        let percentage = 1 - personNode.wdBlood / personNode.wdAllBlood
        let leavePercentage = personNode.wdBlood / personNode.wdAllBlood
        let action = SKAction.scaleX(to: leavePercentage * 0.5, duration: 0.3)
        bloodNode.run(action) {
            let colorAction = SKAction.colorize(with: UIColor.red, colorBlendFactor: percentage, duration: TimeInterval(leavePercentage))
            let colorAction2 = SKAction.colorize(with: UIColor.red, colorBlendFactor: 0, duration: TimeInterval(leavePercentage))
            let seqa = SKAction.sequence([colorAction,colorAction2])
            let repa = SKAction.repeatForever(seqa)
            self.bloodNode.run(repa, withKey: "bloodA")
        }
    
    }
    
    @objc func testEmitter(timer:Timer) {
    }
    
    
    
    //MARK:操作相关方法
    //**************************************************************//
    //开火方法
    override func fireAction(direction: NSString) {
        
        self.run(SKAction.playSoundFileNamed("perNAttack", waitForCompletion: false)) {
            
        }
        
        if nearZom != nil {
             let distance:CGFloat = WDTool.calculateNodesDistance(point1: nearZom.position, point2: personNode.position)
            if distance < CGFloat(personNode.wdAttackDistance){
//              personNode.personBehavior.autoAttackAction(node: personNode, zomNode: nearZom)
            }else{
              WDAnimationTool.fuzhujiRotateAnimation(direction: personNode.direction, personNode: personNode)
            }
            
            personNode?.personBehavior.attackAction(node: personNode)
        }else{
             personNode?.personBehavior.attackAction(node: personNode)
        }
    }
    
    //自动攻击
    @objc func autoFireAction(){
        
        if  !WDAutoFire() {
           return
        }
        
        if nearZom != nil {
            let distance:CGFloat = WDTool.calculateNodesDistance(point1: nearZom.position, point2: personNode.position)
            if distance < CGFloat(personNode.wdAttackDistance){
                personNode.personBehavior.autoAttackAction(node: personNode, zomNode: nearZom)
                personNode.fly_isFire = true
            }else{
                personNode.fly_isFire = false
            }
        }
    }
    
    
    
    //移动
    override func moveAction(direction: NSString) {
        if personNode != nil{
            personNode.personBehavior.moveAction(direction: direction)
            self.mapMoveAction()
        }
    }
 //**************************************************************//
    
    //监视移动事件
    @objc func mapMoveAction(){
        if personNode != nil {
            personNode.position = WDTool.overStepTest(point: personNode.position)
            personNode.zPosition = 3 * 667 - personNode.position.y;
            WDMapManager.sharedInstance.setMapPosition(point: personNode.position, mapNode: bgNode)
           
        }
    }
    
    
    //停止移动
    override func stopMoveAction(direction: NSString) {
        if personNode != nil{
            personNode.personBehavior.stopMoveAction(direction: direction)
        }
    }
    
    
    //MARK: -物理碰撞
    //代理
    func didBegin(_ contact: SKPhysicsContact) {
        mapViewModel.phyContact(contact:contact, personNode: personNode, boomModel: boomModel)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
    }
    
    
    
    func playNext()  {
        if !diedOrPass {
            diedOrPass = true
        }else{
            return
        }
        self.perform(#selector(removeNode), with: nil, afterDelay: 1)
        self.nextAction()
        WDMusicManager.shareInstance.playerIndexAndMusicName(type: .game, musicName: WDMusicManager.shareInstance.game_next, numberOfLoops: 0, volume: 1)
    }
    
    
    @objc override func gameOver() {
        if !diedOrPass {
            diedOrPass = true
        }else{
            return
        }
        self.perform(#selector(removeNode), with: nil, afterDelay: 1)
        self.ggAction()
        WDMusicManager.shareInstance.playerIndexAndMusicName(type: .game, musicName: WDMusicManager.shareInstance.game_over, numberOfLoops: 0, volume: 1)
    }
    
    
    
    //修改通关时间
    func overTime(bossNode:WDBaseNode) {
        let model:WDMonsterModel = WDMonsterModel.initWithMonsterName(monsterName: bossNode.name!)
        if model.overTime > times || model.overTime == 0{
            model.overTime = times
            _ = model.changeMonsterToSqlite()
        }
    }
    
    //结束
    @objc func removeNode()  {
        
        if level == LAST_LEVEL{
            let model:WDUserModel = WDUserModel.init()
            _ = model.searchToDB()
            if CGFloat(model.score) < score{
                model.score = NSInteger(score)
               _ = model.changeSkillToSqlite()
            }
        }
        
        fly_timer.invalidate()
        overTimer.invalidate()
        createZomTimer.invalidate()
        
        if mapLink != nil {
            mapLink.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
            mapLink.invalidate()
            mapLink = nil
        }
        
        if zomLink != nil{
            zomLink.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
            zomLink.invalidate()
            zomLink = nil
        }
        
        mapViewModel.removeNode()
        self.isCreateScene = false
    }
    
    
    deinit {
        print("地图1被释放了！！！！！！！！！")
    }
    
}
