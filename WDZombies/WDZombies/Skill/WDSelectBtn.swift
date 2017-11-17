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
    
    func initWithType(frame:CGRect,skillType:personSkillType) -> Void {
        _skillType = skillType
        self.frame = frame
        _select = false
        
        self.backgroundColor = UIColor.yellow
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        
        let imageView:UIImageView = UIImageView(frame:CGRect(x:0,y:0,width:frame.size.width,height:frame.size.height))
        imageView.image = WDTool.skillImage(skillType: _skillType)
        self.addSubview(imageView)
     
    }
    
    
    func selectAction() -> Bool {
        _select = !_select
        return _select
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self._selectAction(self.selectAction(),_skillType,0)
    }
    
    
    
    
}
