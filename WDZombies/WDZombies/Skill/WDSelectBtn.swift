//
//  WDSelectBtn.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/23.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit


class WDSelectBtn: UIButton {

    var _skillType:personSkillType!
    var _select:Bool!
    var _selectAction:selectSkill!
    var _lockImage:UIImageView!
    
    func initWithType(frame:CGRect,skillType:personSkillType) -> Void {
        _skillType = skillType
        self.frame = frame
        _select = false
        
       

        
        self.backgroundColor = UIColor.yellow
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 20
        
        let imageView:UIImageView = UIImageView(frame:CGRect(x:3,y:3,width:frame.size.width - 6,height:frame.size.height - 6))
        imageView.image = WDTool.skillImage(skillType: _skillType)
        self.addSubview(imageView)
        
        let lockImage:UIImageView = UIImageView(frame:CGRect(x:5,y:5,width:frame.size.width - 10,height:frame.size.height - 10))
        lockImage.image = UIImage.init(named: "lock")
        self.addSubview(lockImage)
        
        
        
        let skillName = WDTool.skillName(skillType: _skillType)
        let model:WDSkillModel = WDSkillModel.init()
        model.skillName = skillName
        if WDDataManager.shareInstance().openDB(){
            if model.searchToDB(){
                if model.haveLearn == 0{
                    lockImage.isHidden = false
                    self.isUserInteractionEnabled = false
                }else{
                    lockImage.isHidden = true
                    self.isUserInteractionEnabled = true
                }
            }else{
                
                lockImage.isHidden = false
                self.isUserInteractionEnabled = false
            }
            
        }else{
            lockImage.isHidden = false
            self.isUserInteractionEnabled = false
        }
        WDDataManager.shareInstance().closeDB()
        
    }
    
    
    func selectAction() -> Bool {
        _select = !_select
        return _select
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self._selectAction(self.selectAction(),_skillType,0)
    }
    
    
    
    
}
