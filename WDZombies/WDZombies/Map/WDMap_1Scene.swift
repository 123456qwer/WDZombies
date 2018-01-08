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
 
    
    var fly_timer:Timer!               //辅助机计时器
    var createZomTimer:Timer!          //创建zom的timer
    var mapLink:CADisplayLink!         //监测地图移动的link
    var zomLink:CADisplayLink!         //监测僵尸移动的link
    var nearZom:WDBaseNode!

    
    var zomCount:NSInteger = 0         //创建的僵尸个数
    var diedZomCount:NSInteger = 0     //击杀僵尸个数
    
    var diedZomLabel:SKLabelNode!
    var level:NSInteger!
    
    
    let mapViewModel:WDMap_1ViewModel = WDMap_1ViewModel.init() //处理逻辑
    let mapZomModel:WDMap_1ZomModel   = WDMap_1ZomModel.init()  //处理僵尸
    
    
    //进入方法
    override func didMove(to view: SKView) {
       
        if !isCreateScene {

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
           
            mapLink = CADisplayLink.init(target: self, selector: #selector(mapMoveAction))
            mapLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
            
            zomLink = CADisplayLink.init(target: self, selector: #selector(zomMoveAction))
            zomLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
            
            //self.level_8_kulouKnightZom(isBoss: true)
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
    }
    
   
    
    //normal/red僵尸相关
    @objc override func createZombies(timer:Timer){
        //开始创建僵尸
        self.zomCount += 1
        if self.zomCount == WDMap_1Scene.ZOMCOUNT {
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
    
    //从数组中删除Node方法
    func removeNodeFromArr(node:WDBaseNode){
        mapViewModel.removeNode(zomNode: node)
        mapViewModel.zomArr.remove(node)
    }
    
    func addZomNode(node:WDBaseNode){
        mapViewModel.zomArr.add(node)
    }
    
    
    func createBoss()  {
        self.diedZomCount += 1
        if self.diedZomCount >= WDMap_1Scene.ZOMCOUNT {
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
            }
        }
        
    }
    
    //******************************************************//

    func levelUp(model:WDUserModel)  {
        model.skillCount += 1
        _ = model.changeSkillToSqlite()
        WDDataManager.shareInstance().closeDB()
    }
    
    
    @objc func testEmitter(timer:Timer) {
    }
    
    //MARK:操作相关方法
    //**************************************************************//
    //开火方法
    override func fireAction(direction: NSString) {
        if nearZom != nil {
             let distance:CGFloat = WDTool.calculateNodesDistance(point1: nearZom.position, point2: personNode.position)
            if distance < CGFloat(personNode.wdAttackDistance){
//              personNode.personBehavior.autoAttackAction(node: personNode, zomNode: nearZom)
            }else{
              WDAnimationTool.fuzhujiRotateAnimation(direction: personNode.direction, fuzhuji: personNode.fuzhujiNode)
            }
            
            personNode?.personBehavior.attackAction(node: personNode)
        }else{
             personNode?.personBehavior.attackAction(node: personNode)
        }
    }
    
    //自动攻击
    @objc func autoFireAction(){
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
    
    
    //MARK: -物理碰撞
    //代理
    func didBegin(_ contact: SKPhysicsContact) {
        mapViewModel.phyContact(contact:contact, personNode: personNode, boomModel: boomModel)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
    }
    
    
    func playNext()  {
        self.perform(#selector(removeNode), with: nil, afterDelay: 1)
        self.nextAction()
    }
    
    @objc override func gameOver() {
        self.perform(#selector(removeNode), with: nil, afterDelay: 1)
        self.ggAction()
    }
    
    
    //结束
    @objc func removeNode()  {
        
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
