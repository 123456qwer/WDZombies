//
//  WDSkillView.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/20.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

//闭包
typealias sendValue = (_ Bool : Bool, _ index:NSInteger) -> Void


class WDSkillView: UIButton {

    var selectBegin : sendValue?
    var index : NSInteger?
    var skillType:personSkillType?
    var isSelect:Bool?
    var skillImage:UIImageView?
    var timer:Timer?
    
    func initWithIndex(initIndex:NSInteger,initSelect:Bool,initType:personSkillType) -> Void {
        
        index = initIndex
        isSelect = initSelect
        skillType = initType
    }
    
    //删除选中imageView
    func removeSelectImage() -> Void {
        let imageV = self.viewWithTag(1000)
        imageV?.removeFromSuperview()
        self.alpha = 0.2
    }
    
  
    //技能选择完毕后创建imageView
    func addImageView() -> Void {
        if (skillImage == nil) {
            skillImage = UIImageView()
        }
        
        let page:CGFloat = (smallBtn - skillImageWidth) / 2.0;
        skillImage?.frame = CGRect(x:page,y:page,width:skillImageWidth,height:skillImageWidth)
        skillImage?.image = WDTool.skillImage(skillType: skillType!)
        self.addSubview(skillImage!)
    }
    
    
    //删除skillImage<游戏结束>
    func removeImageView() -> Void {
      
        skillImage?.removeFromSuperview()
        let label:UILabel? = self.viewWithTag(100) as? UILabel
        timer?.invalidate()
        label?.removeFromSuperview()
        self.skillType = .NoSelect
        self.isSelect = false
        self.alpha = 0.2
    }
    
    
    //选择技能页面添加imageView
    func setSelectImage(selectSkillType:personSkillType,selectOrCancel:Bool) -> Void {
       
        isSelect = selectOrCancel
        if !selectOrCancel {
            self.removeSelectImage()
            skillType = .NoSelect

            return
        }
        
       
        let imageV = UIImageView(frame:CGRect(x:10,y:10,width:selectBtn - 20,height:selectBtn - 20))
        imageV.tag = 1000;
        imageV.image = WDTool.skillImage(skillType: selectSkillType)
       
        
        self.addSubview(imageV)
        self.alpha = 1;
        skillType = selectSkillType
    }
    
    
    //点击开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          starSelect()
        if skillType == .Fire {
            self.alpha = 0.2
        }
    }
    
    //点击结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
          endSelect()
        if skillType == .Fire {
            self.alpha = 0.5
        }
        
    }
    
    
    func starSelect() -> Void {
        self.selectAction(true)
    }
    
    func endSelect() -> Void {
        //self.selectAction(false)
    }
    
    
    func addTimerWithLabel(label:UILabel) -> Void {
        
      label.tag = 100
      self.addSubview(label)
     timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction(timer:)), userInfo: label, repeats: true)
    }
    
    @objc func timerAction(timer:Timer) -> Void {
        let timeLabel:UILabel = timer.userInfo as! UILabel
        var times:NSInteger = NSInteger(timeLabel.text!)!
        times -= 1
        
        if times <= 0 {
            
            self.isUserInteractionEnabled = true
            self.alpha = 0.6
            timeLabel.removeFromSuperview()
            timer.invalidate()
            
        }
        
        timeLabel.text = "\(times)"
    }
    
    
    func selectAction(_ starOrEnd:Bool) {
        //将值附在闭包上,传到First页面
        self.selectBegin!(starOrEnd,index!)
        
    }
    
}
