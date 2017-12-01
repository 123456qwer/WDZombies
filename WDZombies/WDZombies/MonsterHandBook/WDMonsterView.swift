//
//  WDMonsterView.swift
//  WDZombies
//
//  Created by wudong on 2017/12/1.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

class WDMonsterView: UIView {

    
    var imageView1:UIImageView! = nil
    var imageView2:UIImageView! = nil
    
    var speedLabel:UILabel! = nil
    var bloodLabel:UILabel! = nil
    var attackLabel:UILabel! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let page:CGFloat = 5
        let width:CGFloat = frame.size.width / 2.0 - page  * 2
        let height:CGFloat = frame.size.height / 2.0 - page * 2
        
        imageView1 = UIImageView.init(frame: CGRect(x:page,y:page,width:width,height:height))
        imageView1.backgroundColor = UIColor.orange
        self.addSubview(imageView1)
        
        imageView2 = UIImageView.init(frame: CGRect(x:self.frame.size.width / 2.0 + page,y:self.frame.size.height / 2.0 + page,width:width,height:height))
        imageView2.backgroundColor = UIColor.orange
        self.addSubview(imageView2)
        
        self.createAttributeLabel()
    }
    
    
    func createAttributeLabel(){
       
        let width = self.frame.size.width / 2.0 - 20
        let x = self.frame.size.width / 2.0 + 10
        let page:CGFloat = 15
        
        bloodLabel = UILabel.init(frame: CGRect(x:x,y:page,width:width,height:20))
        bloodLabel.backgroundColor = UIColor.orange
        self.addSubview(bloodLabel)
        
        speedLabel = UILabel.init(frame: CGRect(x:x,y:WDTool.bottom(View: bloodLabel) + page,width:width,height:20))
        speedLabel.backgroundColor = UIColor.orange
        self.addSubview(speedLabel)
        
        attackLabel = UILabel.init(frame: CGRect(x:x,y:WDTool.bottom(View: speedLabel) + page,width:width,height:20))
        attackLabel.backgroundColor = UIColor.orange
        self.addSubview(attackLabel)
    }
    
    func createWithType(type:zomType)  {
        if type == .Normal{
            
            bloodLabel.text = "blood:   5"
            speedLabel.text = "speed:   1"
            attackLabel.text = "attack:   1"
            
        }else if type == .Red{
            bloodLabel.text = "blood:   10"
            speedLabel.text = "speed:   2"
            attackLabel.text = "attack:   1"
        }
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
