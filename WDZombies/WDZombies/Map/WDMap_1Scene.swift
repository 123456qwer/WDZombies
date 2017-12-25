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
    
    static let ZOMCOUNT = 30
    let BOSS_BLOOD:CGFloat = 20.0
    let BOSS_ATTACK:CGFloat = 3.0
    
    var boomModel:WDSkillModel!        //技能model，用于查看炸弹伤害
 
    
    var createZomTimer:Timer!          //创建zom的timer
    var mapLink:CADisplayLink!         //监测地图移动的link
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
           
            mapLink = CADisplayLink.init(target: self, selector: #selector(mapMoveAction))
            mapLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
           
            //self.createBoss1()
            //self.level_3_BossAction(isBoss: true)
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
        }
 
    }
 
    
   
    //MARK:创建僵尸相关
 //******************************************************//
    //普通僵尸
    func level_1_NormalZom(isBoss:Bool)  {
        let zombieNode:WDZombieNode = mapZomModel.createNormalZom(isBoss: isBoss)
        mapViewModel.normalZomArr.add(zombieNode)
    }
    //普通僵尸死亡
    func removeNormalZom(normalZom:WDZombieNode){
        mapViewModel.removeNode(zomNode: normalZom)
        mapViewModel.normalZomArr.remove(normalZom)
    }
    
    //红色僵尸
    func level_2_RedZom(isBoss:Bool)  {
        let zombieNode:WDZombieNode = mapZomModel.createRedZom(isBoss: isBoss)
        mapViewModel.normalZomArr.add(zombieNode)
    }
    func removeRedZom(redZom:WDZombieNode){
        mapViewModel.removeNode(zomNode: redZom)
        mapViewModel.normalZomArr.remove(redZom)
    }
    
    
    //骷髅相关
    func level_3_KulouZom(isBoss:Bool)  {
        let kulouNode:WDKulouNode = mapZomModel.createKulouZom(isBoss: isBoss)
        mapViewModel.kulouZomArr.add(kulouNode)
    }
    func removeKulouZom(kulouZom:WDKulouNode){
    }
    
    //绿色僵尸
    func level_4_GreenZom(isBoss:Bool)  {
        let greenZom = mapZomModel.createGreenZom(isBoss: isBoss)
        mapViewModel.greenZomArr.add(greenZom)
    }
    
    //雾骑士
    func level_5_KnightZom(isBoss:Bool)  {
        let kNight:WDSmokeKnightNode = mapZomModel.createKnightZom(isBoss: isBoss)
        mapViewModel.knightZomArr.add(kNight)
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
        personNode?.personBehavior.attackAction(node: personNode)
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
        
        mapViewModel.removeNode()
        self.isCreateScene = false
    }
    
    
    deinit {
        print("地图1被释放了！！！！！！！！！")
    }
    
}
