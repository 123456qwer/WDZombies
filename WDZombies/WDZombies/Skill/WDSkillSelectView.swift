//
//  WDSkillSelectView.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/20.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit


class WDSkillSelectView: UIScrollView ,UIScrollViewDelegate{

    //传值
    var selectAction:selectSkill!
    var selectCount:NSInteger!
    
    func initWithFrame(frame:CGRect) -> Void {
       
       
        
        self.delegate = self
        self.frame = frame
        selectCount = 0;
        
        let bgImage:UIImageView = UIImageView.init(frame: self.frame)
        bgImage.image = UIImage.init(named: "sun.jpg")
        self.addSubview(bgImage)
        
        let titleLabel:UILabel = UILabel(frame:CGRect(x:0,y:10,width:kScreenWidth,height:40))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        titleLabel.text = "INITIATIVE"
        titleLabel.textColor = UIColor.white
        //titleLabel.backgroundColor = UIColor.orange
        titleLabel.isUserInteractionEnabled = true
        self.addSubview(titleLabel)
        
     
        let page:CGFloat = 20
        let btnWidth:CGFloat = (kScreenWidth - page * 7) / 6.0
  
        //增加攻击力技能
        let attackSkill:WDSelectBtn = WDSelectBtn(type: .custom)
        attackSkill.initWithType(frame: CGRect(x:page,y:WDTool.bottom(View: titleLabel) + 10,width:btnWidth, height:btnWidth), skillType: .Attack)
        self.addSubview(attackSkill)
        
        //炸弹
        let boomSkill:WDSelectBtn = WDSelectBtn(type:.custom)
        boomSkill.initWithType(frame: CGRect(x:WDTool.right(View: attackSkill)+page,y:WDTool.bottom(View: titleLabel) + 10,width:btnWidth, height:btnWidth), skillType: .BOOM)
        self.addSubview(boomSkill)
        
        //闪现
        let blinkSkill:WDSelectBtn = WDSelectBtn(type:.custom)
        blinkSkill.initWithType(frame: CGRect(x:WDTool.right(View: boomSkill)+page,y:WDTool.bottom(View: titleLabel) + 10,width:btnWidth, height:btnWidth), skillType: .BLINK)
        self.addSubview(blinkSkill)
        
        //增加移速
        let addSpeedSkill:WDSelectBtn = WDSelectBtn(type:.custom)
        addSpeedSkill.initWithType(frame: CGRect(x:WDTool.right(View: blinkSkill)+page,y:WDTool.bottom(View: titleLabel) + 10,width:btnWidth, height:btnWidth), skillType: .SPEED)
        self.addSubview(addSpeedSkill)
        
        
        //增加攻击距离
        let attack_distanceSkill:WDSelectBtn = WDSelectBtn(type:.custom)
        attack_distanceSkill.initWithType(frame: CGRect(x:WDTool.right(View: addSpeedSkill)+page,y:WDTool.bottom(View: titleLabel) + 10,width:btnWidth, height:btnWidth), skillType: .Attack_distance)
        self.addSubview(attack_distanceSkill)
        
        
        //选中传参
        let swiftArr:Array<WDSelectBtn> = [attackSkill,boomSkill,blinkSkill,addSpeedSkill,attack_distanceSkill]
        for skillView:WDSelectBtn in swiftArr {
            skillView._selectAction = { (Bool:Bool,skillType:personSkillType,skillCount:NSInteger) -> Void in
              
                //最多选取4个技能
                if Bool == true{
                    if self.selectCount == 4{
                        skillView._select = false
                        return
                    }
                }
                
                if Bool == true{
                    self.selectCount = self.selectCount + 1
                }else{
                    self.selectCount = self.selectCount - 1
                }
                
                self.selectAction(Bool,skillType,self.selectCount)
            }
        }
     
        
    }
    
   

}
