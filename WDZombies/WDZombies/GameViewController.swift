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

    var skillAndFireView:WDSkillAndFireView! = nil
    var skillSelectView :WDSkillSelectView!  = nil
    var moveView:WDMoveView!                 = nil
    var showScene:WDBaseScene!               = nil
    var mapName:NSString!                    = nil

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
        
       //self.showScene(sceneName: mapName)
       self.createBg()
        
    }
    
    //开始菜单
    func createBg() -> Void {
      
        
        let bgImageView = UIImageView(image:UIImage(named:"starBG.jpg"))
        let rect = CGRect(origin:CGPoint(x:0,y:0),size:CGSize(width:kScreenWidth,height:kScreenHeight))
        bgImageView.frame = rect
        bgImageView.isUserInteractionEnabled = true
        bgImageView.tag = 150
        self.view.addSubview(bgImageView)
        
        
        //开始游戏选择技能
        let selectMapBtn:UIButton = UIButton(type:.custom)
        selectMapBtn.frame = CGRect(x:kScreenWidth / 2.0 - 120 / 2.0,y:kScreenHeight / 3.0 - 80 / 2.0,width:120,height:80)
        selectMapBtn.addTarget(self, action: #selector(selectMap), for:.touchUpInside)
        selectMapBtn.setImage(UIImage(named:"starGame.png"), for: .normal)
        //starBtn.backgroundColor = UIColor.green
        bgImageView.addSubview(selectMapBtn)
        
        
        
        //学习技能
        let learnSkillBtn:UIButton = UIButton(type:.custom)
        learnSkillBtn.frame = CGRect(x:kScreenWidth / 2.0 - 120 / 2.0,y:WDTool.bottom(View: selectMapBtn) + 10,width:120,height:80)
        learnSkillBtn.addTarget(self, action: #selector(learnSkill), for: .touchUpInside)
        learnSkillBtn.backgroundColor = UIColor.green
        learnSkillBtn.setTitle("LearnSkill", for: .normal)
        bgImageView.addSubview(learnSkillBtn)
        
    }
    
    
    //技能选择
    @objc func learnSkill() {
    
        let skillVC = WDSkillViewController.init()
        self.present(skillVC, animated: true) {
            print(skillVC.skillCount)
        }
    
    }
    
    //地图选择
    @objc func selectMap() -> Void {
       
        let scroll = self.view.viewWithTag(150)
        scroll?.removeFromSuperview()
        
        let bgScrollView:UIScrollView = UIScrollView.init(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight))
        bgScrollView.isPagingEnabled = true
        bgScrollView.contentSize = CGSize(width:kScreenWidth * 2.0,height:kScreenHeight)
        bgScrollView.tag = 234
        self.view.addSubview(bgScrollView)
        
        let button:UIButton = UIButton.init(frame: CGRect(x:20,y:20,width:kScreenWidth - 40,height:kScreenHeight - 40))
        button.setImage(UIImage.init(named: "map1.png"), for: .normal)
        button.addTarget(self, action: #selector(selectMapName(button:)), for: .touchUpInside)
        button.tag = 1
        bgScrollView.addSubview(button)
        
        let backBtn:UIButton = UIButton.init(frame: CGRect(x:kScreenWidth - 10 - 50,y:10,width:50,height:50))
        backBtn.addTarget(self, action: #selector(backHomePage(sender:)), for: .touchUpInside)
        backBtn.setTitle("back", for: .normal)
        backBtn.backgroundColor = UIColor.orange
        backBtn.tag = 456
        self.view.addSubview(backBtn)
        
    }
    
    @objc func backHomePage(sender:UIButton)  {
        sender.removeFromSuperview()
        let bgScrollView = self.view.viewWithTag(234)
        bgScrollView?.removeFromSuperview()
        self.createBg()
    }
    
    
    @objc func selectMapName(button:UIButton) -> Void {
        if button.tag == 1 {
            mapName = "WDMap_1Scene"
        }
        
        let btn = self.view.viewWithTag(456)
        let scroll = self.view.viewWithTag(234)
        scroll?.removeFromSuperview()
        btn?.removeFromSuperview()
        self.selectSkill()
    }
  
    
    
    //技能选择
    @objc func selectSkill() -> Void {
       
  
        //技能按钮界面
        let rect2 = CGRect(x:kScreenWidth / 2.0,y:0,width:kScreenWidth / 2.0,height:kScreenHeight)
        
        if skillAndFireView == nil {
            skillAndFireView = WDSkillAndFireView()
            skillAndFireView.initWithFrame(frame: rect2)
            self.view.addSubview(skillAndFireView)
        }
       
        skillAndFireView.setSelectFrame()
   
        
        
        
        //技能选择界面
        if skillSelectView == nil {
            skillSelectView = WDSkillSelectView()
            skillSelectView.initWithFrame(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight))
            skillSelectView.backgroundColor = UIColor.orange
            self.view.insertSubview(skillSelectView, belowSubview: skillAndFireView)
        }
      
        
        skillSelectView.isHidden = false
        skillAndFireView.isHidden = false

        
        //开始游戏按妞
        let starBtn:UIButton = UIButton(type:.custom)
        starBtn.frame = CGRect(x:kScreenWidth - 120 / 2.0  - 20,y:10,width:60,height:40)
        starBtn.addTarget(self, action: #selector(starGame), for:.touchUpInside)
        starBtn.setImage(UIImage(named:"starGame.png"), for: .normal)
        //starBtn.backgroundColor = UIColor.green
        starBtn.tag = 500
        starBtn.alpha = 1
        self.view.addSubview(starBtn)
        
        
        skillSelectView.selectAction = {(Bool:Bool,skillType:personSkillType,skillCount:NSInteger) ->Void in
        
            self.skillAndFireView.selectAction(Bool: Bool, skillType: skillType)
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
        
        
        //技能按钮界面位置改变
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
        
        
        
        //移除选择技能界面
        skillSelectView.removeFromSuperview()
        skillSelectView = nil
        
        //移除开始按钮
        let starBtn:UIButton = self.view.viewWithTag(500) as! UIButton
        starBtn.removeFromSuperview()
        
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
    func showScene(sceneName:NSString) -> Void {
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
