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
    let LABEL_COUNT_TAG  = 210
    
    let PLAY_AGIAIN_TAG  = 180
    let DIED_LABEL_TAG   = 190
    let GAME_OVER_TAG    = 200
    
    var skillAndFireView:WDSkillAndFireView! = nil
    var moveView:WDMoveView!                 = nil
    var showScene:WDBaseScene!               = nil
    var mapName:String!                    = nil
    var _level:NSInteger = 1
    
//********************生命周期*********************************//
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
    
        //初始化地图所有纹理
        manager.setPic()
        
        
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    
        let btn = self.view.viewWithTag(SKILL_LABEL_TAG)
        if btn != nil{
    
            let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
            if model.skillCount > 0 {
                let label:UILabel = btn?.viewWithTag(LABEL_COUNT_TAG) as! UILabel
                label.text = "+\(model.skillCount)"
                label.isHidden = false
            }else{
                let label:UILabel = btn?.viewWithTag(LABEL_COUNT_TAG) as! UILabel
                label.isHidden = true
                label.text = "+\(model.skillCount)"
            }
        }
 
    }
    
//*********************操作界面******************************//
    //主界面
    func createBg(){
      
        let bgImageView = UIImageView(image:UIImage(named:"starBG.jpg"))
        let rect = CGRect(origin:CGPoint(x:0,y:0),size:CGSize(width:kScreenWidth,height:kScreenHeight))
        bgImageView.frame = rect
        bgImageView.isUserInteractionEnabled = true
        bgImageView.tag = BG_IAMGEVIEW_TAG
        self.view.addSubview(bgImageView)
        
        
        //
        let width:CGFloat = 120
        let height:CGFloat = 80
        let page:CGFloat = (kScreenWidth - 120 * 3) / 4.0
        let y:CGFloat = kScreenHeight / 2.0 - height / 2.0
        
        //开始游戏选择技能
        let selectMapBtn:UIButton = UIButton(type:.custom)
        selectMapBtn.frame = CGRect(x:page,y:y,width:width,height:height)
        selectMapBtn.addTarget(self, action: #selector(selectMap), for:.touchUpInside)
        selectMapBtn.setImage(UIImage(named:"play.png"), for: .normal)
        bgImageView.addSubview(selectMapBtn)
      
        
        _ = WDDataManager.shareInstance().openDB()
        let userModel:WDUserModel = WDUserModel.init()
        _ = userModel.searchToDB()
        //WDDataManager.shareInstance().closeDB()
        
        
        //学习技能
        let learnSkillBtn:UIButton = UIButton(type:.custom)
        learnSkillBtn.frame = CGRect(x:WDTool.right(View: selectMapBtn) + page,y:y,width:width,height:height)
        learnSkillBtn.addTarget(self, action: #selector(learnSkill), for: .touchUpInside)
        learnSkillBtn.tag = SKILL_LABEL_TAG
        learnSkillBtn.setImage(UIImage(named:"learnSkill"), for: .normal)
        bgImageView.addSubview(learnSkillBtn)
        
        let label:UILabel = UILabel.init(frame: CGRect(x:-10,y:0,width:learnSkillBtn.frame.size.width,height:20))
        label.text = "+\(userModel.skillCount)"
        label.textAlignment = .right
        label.textColor = UIColor.orange
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.tag = LABEL_COUNT_TAG
        learnSkillBtn.addSubview(label)
        if userModel.skillCount > 0 {
            label.isHidden = false
        }else{
            label.isHidden = true
        }
        
        //怪物图鉴
        let monseterBtn:UIButton = UIButton(type:.custom)
        monseterBtn.frame = CGRect(x:WDTool.right(View: learnSkillBtn) + page,y:y,width:width,height:height)
        monseterBtn.addTarget(self, action: #selector(showMonster), for: .touchUpInside)
        monseterBtn.tag = SKILL_LABEL_TAG
        monseterBtn.setImage(UIImage(named:"monster.png"), for: .normal)
        bgImageView.addSubview(monseterBtn)
        
        
        //商城
        let shoppintMallBtn = UIButton(type:.custom);
        shoppintMallBtn.addTarget(self, action: #selector(openShoppingMall), for: .touchUpInside)
        bgImageView.addSubview(shoppintMallBtn)

    }
    
    //技能学习
    @objc func learnSkill() {
        
        let skillVC = WDSkillViewController.init()
        self.present(skillVC, animated: true) {}
    }
    
    //地图选择
    @objc func selectMap() -> Void {
        
        let mapVC = WDMapViewController.init()
        self.present(mapVC, animated: true) {}
        
        weak var weakSelf = self
        mapVC.disMiss = {(mapName:String,level:NSInteger) -> Void in
            weakSelf?.mapName = mapName
            weakSelf?._level = level
            weakSelf?.selectSkill()
        }
    }
    
    //技能选择
    @objc func selectSkill() {
        
        var selectSkillVC:WDSelectSkillVC? = WDSelectSkillVC.init()
        self.present(selectSkillVC!, animated: true) {}
        
        skillAndFireView.setSelectFrame()
        
        weak var weakSelf = self
        selectSkillVC!.passAction = {(Bool:Bool ,skillType:personSkillType) -> Void in
            weakSelf?.skillAndFireView.selectAction(Bool: Bool, skillType: skillType)
        }
        
        selectSkillVC!.removeBGAction = {() -> Void in
            let bgScrollView = self.view.viewWithTag(self.BG_IAMGEVIEW_TAG)
            bgScrollView?.removeFromSuperview()
            weakSelf?.skillAndFireView.isHidden = false
        }
        
        selectSkillVC!.disMiss = {() -> Void in
            weakSelf?.starGame()
            selectSkillVC = nil
        }
        
        selectSkillVC!.backDisMiss = {() -> Void in
            weakSelf?.skillAndFireView.isHidden = true
            selectSkillVC = nil
        }
 
    }
    
    //怪物简介
    @objc func showMonster(){
        
        let monsterVC = WDMonsterVC.init()
        self.present(monsterVC, animated: true) {}
    }
    
    //打开商城
    @objc func openShoppingMall()  {
        
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
            weak var weakSelf = self
            moveView.moveAction = {(direction:NSString) -> Void in
                weakSelf?.showScene.moveAction(direction: direction)
            }
            
            //移动停止方法
            moveView.stopAction = {(direction:NSString) -> Void in
                weakSelf?.showScene.stopMoveAction(direction: direction)
            }
        }
        
        moveView.isHidden = false
        //显示场景
        self.showScene(sceneName: mapName, level:_level)
    }
    
    //游戏结束
    @objc func gameOver() -> Void {
  
        self.removeDiedView()

        if let view = self.view as! SKView?{
            view.presentScene(nil)
        }
        
        skillAndFireView.gameOverReload()
        self.createBg()
        

    }
 
    //playAgain
    @objc func playAgain()  {
        
        self.removeDiedView()
        
        
        skillAndFireView.playAgain()
        self.moveView.isHidden = false
        self.skillAndFireView.isHidden = false
        self.showScene(sceneName: mapName,level:_level)

    }
    
    //playNext
    @objc func playNext(){
        _level += 1
        self.removeDiedView()
    
        skillAndFireView.playAgain()
        self.moveView.isHidden = false
        self.skillAndFireView.isHidden = false
        self.showScene(sceneName: mapName,level:_level)
        
    }
    
    func removeDiedView()  {
        var view1 = self.view.viewWithTag(DIED_LABEL_TAG)
        var view2 = self.view.viewWithTag(PLAY_AGIAIN_TAG)
        var view3 = self.view.viewWithTag(GAME_OVER_TAG)
        
        view1?.removeFromSuperview()
        view2?.removeFromSuperview()
        view3?.removeFromSuperview()
        
        view1 = nil
        view2 = nil
        view3 = nil
    }
    
    func createNextView()  {
        let label:UILabel = UILabel.init(frame: CGRect(x:0,y:20,width:kScreenWidth,height:40))
        label.text = "YOU WIN"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.tag = DIED_LABEL_TAG
        label.alpha = 0
        self.view.addSubview(label)
        
        let page:CGFloat = 20
        let width:CGFloat = 150
        let playAgainBtn:UIButton = UIButton.init(frame: CGRect(x:kScreenWidth / 2.0 - page - width,y:WDTool.bottom(View: label) + page,width:width,height:width))
        playAgainBtn.setTitle("NEXT?", for: .normal)
        playAgainBtn.backgroundColor = UIColor.orange
        playAgainBtn.addTarget(self, action: #selector(playNext), for: .touchUpInside)
        playAgainBtn.tag = PLAY_AGIAIN_TAG
        playAgainBtn.alpha = 0
        self.view.addSubview(playAgainBtn)
        
        let gameOverBtn:UIButton = UIButton.init(frame: CGRect(x:kScreenWidth / 2.0 + page,y:WDTool.bottom(View: label) + page,width:width,height:width))
        gameOverBtn.setTitle("Back Home Page", for: .normal)
        gameOverBtn.backgroundColor = UIColor.orange
        gameOverBtn.addTarget(self, action: #selector(gameOver), for: .touchUpInside)
        gameOverBtn.tag = GAME_OVER_TAG
        gameOverBtn.alpha = 0
        self.view.addSubview(gameOverBtn)
        
        UIView.animate(withDuration: 0.5, animations: {
            label.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                playAgainBtn.alpha = 1
                gameOverBtn.alpha = 1
            })
        }
    }
    
    func createDiedView()  {
        
        let label:UILabel = UILabel.init(frame: CGRect(x:0,y:20,width:kScreenWidth,height:40))
        label.text = "YOU DIED"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.tag = DIED_LABEL_TAG
        label.alpha = 0
        self.view.addSubview(label)
        
        let page:CGFloat = 20
        let width:CGFloat = 150
        let playAgainBtn:UIButton = UIButton.init(frame: CGRect(x:kScreenWidth / 2.0 - page - width,y:WDTool.bottom(View: label) + page,width:width,height:width))
        playAgainBtn.setTitle("Play Again?", for: .normal)
        playAgainBtn.backgroundColor = UIColor.orange
        playAgainBtn.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
        playAgainBtn.tag = PLAY_AGIAIN_TAG
        playAgainBtn.alpha = 0
        self.view.addSubview(playAgainBtn)
        
        let gameOverBtn:UIButton = UIButton.init(frame: CGRect(x:kScreenWidth / 2.0 + page,y:WDTool.bottom(View: label) + page,width:width,height:width))
        gameOverBtn.setTitle("Back Home Page", for: .normal)
        gameOverBtn.backgroundColor = UIColor.orange
        gameOverBtn.addTarget(self, action: #selector(gameOver), for: .touchUpInside)
        gameOverBtn.tag = GAME_OVER_TAG
        gameOverBtn.alpha = 0
        self.view.addSubview(gameOverBtn)
        
        UIView.animate(withDuration: 0.5, animations: {
            label.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                playAgainBtn.alpha = 1
                gameOverBtn.alpha = 1
            })
        }
        
    }
    
    /// 跳转到场景
    ///
    /// - Parameter sceneName: 场景名字
    func showScene(sceneName:String,level:NSInteger) -> Void {
        if let view = self.view as! SKView? {
            
                if sceneName == "WDMap_1Scene" {
                    
                    //存储一下地图，不至于重复创建
//                    let scene = WDMapManager.sharedInstance.mapDic.object(forKey: sceneName) as? WDMap_1Scene
//                    if scene != nil{
//                        scene?.scaleMode = .aspectFill
//                        view.presentScene(scene)
//                        showScene = scene
//                    }else{
                        let scene:WDMap_1Scene = WDMap_1Scene(fileNamed:sceneName as String)!
                        scene.scaleMode = .aspectFill
                        scene.level = level
                        view.presentScene(scene)
                        showScene = scene
                        //WDMapManager.sharedInstance.mapDic.setObject(scene, forKey: sceneName as NSCopying)
                    //}
                    
                    
                }
            
            
            weak var weakSelf = self
            showScene.ggAction = {() -> Void in
                weakSelf?.moveView.isHidden = true
                weakSelf?.skillAndFireView.isHidden = true
                weakSelf?.createDiedView()
            }
            
            showScene.nextAction = {() -> Void in
                weakSelf?.moveView.isHidden = true
                weakSelf?.skillAndFireView.isHidden = true
                weakSelf?.createNextView()
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    


//******************系统方法*************************************//
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
