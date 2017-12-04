//
//  WDSkillAndFireView.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/20.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit



class WDSkillAndFireView: UIView {
    
    var fireBtn:WDSkillView?
    var skillBtn1:WDSkillView?
    var skillBtn2:WDSkillView?
    var skillBtn3:WDSkillView?
    var skillBtn4:WDSkillView?
    var tapAction:tapAction?
    
    func starReload() -> Void {
        let swiftArray: Array<WDSkillView> = [skillBtn1!,skillBtn2!,skillBtn3!,skillBtn4!]
        for skillBtn:WDSkillView in swiftArray {
            skillBtn.removeSelectImage()
            skillBtn.addImageView()
            skillBtn.isUserInteractionEnabled = true
            if skillBtn.skillType == .NoSelect{
                skillBtn.alpha = 0
            }else{
                skillBtn.alpha = 0.6
            }
        }
    }
    
    func gameOverReload() -> Void {
        let swiftArray: Array<WDSkillView> = [skillBtn1!,skillBtn2!,skillBtn3!,skillBtn4!]
        for skillBtn:WDSkillView in swiftArray {
            skillBtn.removeImageView()
            skillBtn.removeSelectImage()
            skillBtn.isUserInteractionEnabled = false
        }
    }
    
    func playAgain()  {
        let swiftArray: Array<WDSkillView> = [skillBtn1!,skillBtn2!,skillBtn3!,skillBtn4!]
        for skillBtn:WDSkillView in swiftArray {
            if skillBtn.alpha != 0{
                skillBtn.playAgain()
                skillBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    //初始化
    func initWithFrame(frame:CGRect) -> Void {
        self.frame = frame
        //攻击按钮
        fireBtn = WDSkillView(type:.custom)
        fireBtn?.frame = CGRect(x:frame.size.width - bigBtn,y:frame.size.height - bigBtn,width:bigBtn,height:bigBtn)
        fireBtn?.initWithIndex(initIndex: 0, initSelect: false, initType: .Fire)
        self.addSubview(fireBtn!)
        
        //技能按钮1
        skillBtn1 = WDSkillView(type:.custom)
        self.addSubview(skillBtn1!)
        
        //技能按钮2
        skillBtn2 = WDSkillView(type:.custom)
        self.addSubview(skillBtn2!)
        
        //技能按钮3
        skillBtn3 = WDSkillView(type:.custom)
        self.addSubview(skillBtn3!)
        
        //技能按钮4
        skillBtn4 = WDSkillView(type:.custom)
        self.addSubview(skillBtn4!)
        
        
     
        //设置选中回调
        //设置背景
        let swiftArray: Array<WDSkillView> = [skillBtn1!,skillBtn2!,skillBtn3!,skillBtn4!]
        for skillView:WDSkillView in swiftArray {
            skillView.setImage(UIImage(named:"weaponBtn.png"), for: .normal)
            self.selectWithView(skillView: skillView)
            let index:NSInteger = swiftArray.index(of: skillView)! + 1
            skillView.initWithIndex(initIndex:index, initSelect:false, initType: .NoSelect)
            skillView.alpha = 0.2
        }
        
        self.selectWithView(skillView: fireBtn!)
        fireBtn?.setImage(UIImage(named:"fire.png"), for: .normal)
        fireBtn?.alpha = 0.5

     }
    
    
    //选择技能
    func selectAction(Bool:Bool,skillType:personSkillType) -> Void {
        
       let swiftArray: Array<WDSkillView> = [skillBtn1!,skillBtn2!,skillBtn3!,skillBtn4!]
        
        //选中后重置
        for skillView:WDSkillView in swiftArray {
            
            if skillView.skillType == skillType{
                skillView.setSelectImage(selectSkillType: skillType, selectOrCancel: Bool)
                return
            }
        }
        
        //未选中直接赋值
        for skillView:WDSkillView in swiftArray {
            
            if skillView.isSelect == false{
                skillView.setSelectImage(selectSkillType: skillType, selectOrCancel: Bool)
                return
            }
        }
    }
    
    
    //操作方法
    func selectWithView(skillView:WDSkillView) -> Void {
        
        skillView.selectBegin = { (select : Bool, index:NSInteger) -> Void in
            
            //选中方法
            self.tapAction?(skillView)

        }
    }
    
    
    
    
    //选择技能阶段初始化frame
    func setSelectFrame() -> Void {

       let height = 80 / 568.0 * kScreenWidth;
       self.frame = CGRect(x:0, y:kScreenHeight - height, width:kScreenWidth, height:height);
        
        
       let width = 60 / 568.0 * kScreenWidth
       let page = (kScreenWidth - width * 4 ) / 5.0
       let y = (WDTool.height(View:self) - width)/2.0
        
        
       skillBtn1?.frame = CGRect(x:page, y:y, width:width, height:width)
       skillBtn2?.frame = CGRect(x:WDTool.right(View: skillBtn1!) + page, y:y, width:width, height:width)
       skillBtn3?.frame = CGRect(x:WDTool.right(View: skillBtn2!) + page, y:y, width:width, height:width)
       skillBtn4?.frame = CGRect(x:WDTool.right(View: skillBtn3!) + page, y:y, width:width, height:width);
        
       self.gameOverReload()

    }
    
    
    
    
    //选择技能完毕重置frame
    func setConfirmFrame() -> Void {
        
       //删除旧image,添加新image
        self.starReload()
        
        let dis:CGFloat = smallBtn / 2.0 + bigBtn / 2.0;
        let distance:CGFloat = sqrt(dis * dis / 2.0);
        let x:CGFloat = fireBtn!.center.x - distance;
        let y:CGFloat = fireBtn!.center.y - distance;
        
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect(x:kScreenWidth / 2.0, y:0, width:kScreenWidth / 2.0, height:kScreenHeight);
            
            self.skillBtn1?.frame = CGRect(x:0,y:0,width:smallBtn,height:smallBtn)
            self.skillBtn2?.frame = CGRect(x:0,y:0,width:smallBtn,height:smallBtn)
            self.skillBtn3?.frame = CGRect(x:0,y:0,width:smallBtn,height:smallBtn)
            self.skillBtn4?.frame = CGRect(x:0,y:0,width:smallBtn,height:smallBtn)

            self.skillBtn2?.center = CGPoint(x:(self.fireBtn?.center.x)! - bigBtn / 2.0  - smallBtn / 2.0, y:(self.fireBtn?.center.y)! + page1)
            self.skillBtn3?.center = CGPoint(x:x,y:y)
            self.skillBtn4?.center = CGPoint(x:(self.fireBtn?.center.x)! + page1,y:(self.fireBtn?.center.y)! - bigBtn / 2.0 - smallBtn / 2.0)
            self.skillBtn1?.center = CGPoint(x:WDTool.left(View: self.skillBtn2!) - smallBtn / 2.0 - page1, y:(self.fireBtn?.center.y)! + page1)

        }
    }
    
    
}
