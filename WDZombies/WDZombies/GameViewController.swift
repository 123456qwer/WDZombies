//
//  GameViewController.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/20.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    let PLAY_BTN_TAG     = 160
    let BG_IAMGEVIEW_TAG = 150
    let SKILL_LABEL_TAG  = 170
    var skillAndFireView:WDSkillAndFireView! = nil
    var moveView:WDMoveView!                 = nil
    var showScene:WDBaseScene!               = nil
    var mapName:String!                    = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
   
        print(kScreenWidth,kScreenHeight)
        
        let defaults:UserDefaults = UserDefaults.standard
        
        
        if defaults.object(forKey: "NewFile") as? NSInteger == 1{
            print("已经有数据了!")

        }else{
            
            print("首次进入!")
            
            if WDDataManager.shareInstance().openDB(){
                if WDDataManager.shareInstance().removeAllData(){
                    WDDataManager.initData()
                    defaults.set(1, forKey: "NewFile")
                }
            }

        WDDataManager.shareInstance().closeDB()

        }
     
        //测试github
        //测试成功，可以开始搞了
        mapName = "WDMap_1Scene"
        
        //初始化地图
        let manager:WDMapManager = WDMapManager.sharedInstance
        manager.createX_Y(x: 2001, y: 1125)
        
        //技能按钮界面
        let rect2 = CGRect(x:kScreenWidth / 2.0,y:0,width:kScreenWidth / 2.0,height:kScreenHeight)
        
        if skillAndFireView == nil {
            skillAndFireView = WDSkillAndFireView()
            skillAndFireView.initWithFrame(frame: rect2)
            self.view.addSubview(skillAndFireView)
        }
        
       //self.showScene(sceneName: mapName)
       self.createBg()
        
    }
    
    //开始菜单
    func createBg() -> Void {
      
        
        let bgImageView = UIImageView(image:UIImage(named:"starBG.jpg"))
        let rect = CGRect(origin:CGPoint(x:0,y:0),size:CGSize(width:kScreenWidth,height:kScreenHeight))
        bgImageView.frame = rect
        bgImageView.isUserInteractionEnabled = true
        bgImageView.tag = BG_IAMGEVIEW_TAG
        self.view.addSubview(bgImageView)
        
        
        //开始游戏选择技能
        let selectMapBtn:UIButton = UIButton(type:.custom)
        selectMapBtn.frame = CGRect(x:kScreenWidth / 2.0 - 120 / 2.0,y:kScreenHeight / 3.0 - 80 / 2.0,width:120,height:80)
        selectMapBtn.addTarget(self, action: #selector(selectMap), for:.touchUpInside)
        selectMapBtn.setImage(UIImage(named:"starGame.png"), for: .normal)
        bgImageView.addSubview(selectMapBtn)
        
        
        
        _ = WDDataManager.shareInstance().openDB()
        let userModel:WDUserModel = WDUserModel.init()
        _ = userModel.searchToDB()
        WDDataManager.shareInstance().closeDB()
        
        
        //学习技能
        let learnSkillBtn:UIButton = UIButton(type:.custom)
        learnSkillBtn.frame = CGRect(x:kScreenWidth / 2.0 - 120 / 2.0,y:WDTool.bottom(View: selectMapBtn) + 10,width:120,height:80)
        learnSkillBtn.addTarget(self, action: #selector(learnSkill), for: .touchUpInside)
        learnSkillBtn.backgroundColor = UIColor.orange
        learnSkillBtn.titleLabel?.numberOfLines = 0
        learnSkillBtn.tag = SKILL_LABEL_TAG
        learnSkillBtn.setTitle("LearnSkill\nSkillPoint:\(userModel.skillCount)", for: .normal)
        bgImageView.addSubview(learnSkillBtn)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let btn = self.view.viewWithTag(SKILL_LABEL_TAG)
        if btn != nil{
            
            _ = WDDataManager.shareInstance().openDB()
            let userModel:WDUserModel = WDUserModel.init()
            _ = userModel.searchToDB()
            WDDataManager.shareInstance().closeDB()
            
            let button:UIButton = btn as! UIButton
            button.setTitle("LearnSkill\nSkillPoint:\(userModel.skillCount)", for: .normal)
            
        }
        
    }
    
    //技能选择
    @objc func learnSkill() {
    
        
        let skillVC = WDSkillViewController.init()
        self.present(skillVC, animated: true) {
        }
    
    }
    
    //地图选择
    @objc func selectMap() -> Void {
       
        let mapVC = WDMapViewController.init()
        self.present(mapVC, animated: true) {
            
        }
        
        mapVC.disMiss = {(mapName:String) -> Void in
            self.mapName = mapName
            self.selectSkill()
        }
        
    }
    
 
    //技能选择
    @objc func selectSkill() -> Void {
       
   
        
        let selectSkillVC = WDSelectSkillVC.init()
        self.present(selectSkillVC, animated: true) {
            
        }
        
    
        skillAndFireView.setSelectFrame()
   
        
        selectSkillVC.passAction = {(Bool:Bool ,skillType:personSkillType) -> Void in
            self.skillAndFireView.selectAction(Bool: Bool, skillType: skillType)
        }
        
        selectSkillVC.removeBGAction = {() -> Void in
            let bgScrollView = self.view.viewWithTag(self.BG_IAMGEVIEW_TAG)
            bgScrollView?.removeFromSuperview()
            self.skillAndFireView.isHidden = false

        }
        
        selectSkillVC.disMiss = {() -> Void in
            self.starGame()
        }
        
        selectSkillVC.backDisMiss = {() -> Void in
            self.skillAndFireView.isHidden = true
        }
      
    }
    
    
 
    
    //游戏结束
    func gameOver() -> Void {
        
        moveView.isHidden = true
        skillAndFireView.isHidden = true
       
        skillAndFireView.gameOverReload()
        self.createBg()
    }
    
    
    //开始游戏
    @objc func starGame() -> Void {
        
     
        
        //技能按钮界面位置改变,增加技能Model
        skillAndFireView.setConfirmFrame()
        WDSkillManager.sharedInstance.initModelDic()
        
        //技能按钮回调
        skillAndFireView.tapAction = {(view:WDSkillView)->Void in
            
            //print(Bool,skillType,index)
            if view.skillType == .Fire{
                self.showScene.fireAction(direction: "")
            }
            
            //技能释放
            WDSkillManager.sharedInstance.skillWithType(skillView: view, node:self.showScene.personNode)
        }
        
        

        
        //添加移动操作界面
        if moveView == nil {
            moveView = WDMoveView()
            moveView.initWithFrame(frame: CGRect(x:0,y:0,width:kScreenWidth / 2.0,height:kScreenHeight))
            self.view.addSubview(moveView)
           
            //移动方法
            moveView.moveAction = {(direction:NSString) -> Void in
                self.showScene.moveAction(direction: direction)
            }
            
            //移动停止方法
            moveView.stopAction = {(direction:NSString) -> Void in
                self.showScene.stopMoveAction(direction: direction)
            }
        }
      
        moveView.isHidden = false
        //显示场景
        self.showScene(sceneName: mapName)
    }
    
    
    /// 跳转到场景
    ///
    /// - Parameter sceneName: 场景名字
    func showScene(sceneName:String) -> Void {
        if let view = self.view as! SKView? {
            
                if sceneName == "WDMap_1Scene" {
                    let scene:WDMap_1Scene = WDMap_1Scene(fileNamed:sceneName as String)!
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene)
                    showScene = scene
                }
            
            showScene.ggAction = {() -> Void in
                self.gameOver()
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    


    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
