//
//  WDSelectSkillVC.swift
//  WDZombies
//
//  Created by wudong on 2017/11/30.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
class WDSelectSkillVC: UIViewController {
    
    typealias passSkill = (_ Bool:Bool , _ skillType:personSkillType) -> Void
    typealias dismissAction = () -> Void
    typealias backDisMissAction = () -> Void
    typealias removeBG = () -> Void

    var  skillAndFireView:WDSkillAndFireView!
    let  SELECT_SKILL_TAG = 100
    var  passAction:passSkill!
    var  disMiss:dismissAction!
    var  backDisMiss:backDisMissAction!
    var  removeBGAction:removeBG!
    var BACK_BTN_TAG  = 200
    var PLAY_BTN_TAG  = 300

    
    override func viewDidLoad() {
        super.viewDidLoad()

   
        //技能按钮界面
        let rect2 = CGRect(x:kScreenWidth / 2.0,y:0,width:kScreenWidth / 2.0,height:kScreenHeight)
        
       
        skillAndFireView = WDSkillAndFireView()
        skillAndFireView.initWithFrame(frame: rect2)
        self.view.addSubview(skillAndFireView)
        
        
        skillAndFireView.setSelectFrame()
        
        
        //技能选择界面
        let skillSelectView:WDSkillSelectView = WDSkillSelectView()
        skillSelectView.initWithFrame(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight))
        skillSelectView.backgroundColor = UIColor.orange
        skillSelectView.tag = SELECT_SKILL_TAG
        self.view.insertSubview(skillSelectView, belowSubview: skillAndFireView)
        
    
        //开始游戏按妞
        let starBtn:UIButton = UIButton(type:.custom)
        starBtn.frame = CGRect(x:10,y:10,width:60,height:40)
        starBtn.addTarget(self, action: #selector(starGame), for:.touchUpInside)
        starBtn.setImage(UIImage(named:"starGame.png"), for: .normal)
        starBtn.alpha = 1
        starBtn.tag = PLAY_BTN_TAG
        self.view.addSubview(starBtn)
        
        let backBtn:UIButton = UIButton.init(frame: CGRect(x:kScreenWidth - 10 - 50,y:10,width:50,height:50))
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backBtn.setImage(UIImage.init(named: "back"), for: .normal)
        self.view.addSubview(backBtn)
        backBtn.tag = BACK_BTN_TAG
        
        weak var weakSelf = self
        skillSelectView.selectAction = {(Bool:Bool,skillType:personSkillType,skillCount:NSInteger) ->Void in
            weakSelf?.weakAction(Bool: Bool,skillType: skillType)
        }
        
    }
    
    func weakAction(Bool: Bool, skillType: personSkillType)  {
        self.skillAndFireView.selectAction(Bool: Bool, skillType: skillType)
        self.passAction(Bool,skillType)
    }
    
    func removeBtn()  {
        var btn1 = self.view.viewWithTag(BACK_BTN_TAG)
        var btn2 = self.view.viewWithTag(PLAY_BTN_TAG)
        btn1?.removeFromSuperview()
        btn2?.removeFromSuperview()
        
        btn1 = nil
        btn2 = nil
        
        let skillSelectView = self.view.viewWithTag(SELECT_SKILL_TAG)
        skillSelectView?.removeFromSuperview()
        skillAndFireView.removeFromSuperview()
        skillAndFireView = nil
    }
    
    @objc func backAction(){
        
        self.removeBtn()
        self.backDisMiss()
       
        self.backDisMiss = nil
        self.disMiss = nil
        
        self.dismiss(animated: true) {
          
        }
    }
    
    @objc func starGame()  {
        
        self.removeBtn()
        
        self.removeBGAction()
        self.dismiss(animated: false) {
            self.disMiss()
        }
    }

    deinit {
        print("选技能VC被销毁了！！！")
    }
   
    
    

}
