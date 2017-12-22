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
    var detailLabel:UILabel! = nil
    
    var speedLabel:UILabel! = nil
    var bloodLabel:UILabel! = nil
    var attackLabel:UILabel! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let page:CGFloat = 5
        let width:CGFloat = frame.size.width / 2.0 - page  * 2
        let height:CGFloat = frame.size.height / 2.0 - page * 2
        
        let bgView1 = UIView.init(frame: CGRect(x:page,y:page,width:width,height:height))
        bgView1.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        self.addSubview(bgView1)
        
        detailLabel = UILabel.init(frame: CGRect(x:0,y:WDTool.bottom(View: bgView1)+5,width:width,height:height))
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.boldSystemFont(ofSize: 20)
        detailLabel.textAlignment = .center
        self.addSubview(detailLabel)
        
        let bgView2 = UIView.init(frame: CGRect(x:self.frame.size.width / 2.0 + page,y:self.frame.size.height / 2.0 + page,width:width,height:height))
        bgView2.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        self.addSubview(bgView2)
        
        WDTool.masksToSize(View: bgView1, cornerRadius: 10)
        WDTool.masksToSize(View: bgView2, cornerRadius: 10)

        //163 / 197
        let page1 = (width - 163 / 2.0) / 2.0
        let page2 = (height - 197 / 2.0) / 2.0
        imageView1 = UIImageView.init(frame: CGRect(x:page1,y:page2,width:163 / 2.0,height:197 / 2.0))
        bgView1.addSubview(imageView1)
        
        imageView2 = UIImageView.init(frame: CGRect(x:page1,y:page2,width:163 / 2.0,height:197 / 2.0))
        bgView2.addSubview(imageView2)
        
        self.createAttributeLabel()
    }
    
    func setImage1(images:NSArray,frame:CGRect) {
        if images.count > 0{
            
            imageView1.frame = frame
            imageView1.animationImages = images as? [UIImage]
            imageView1.animationDuration = TimeInterval(CGFloat(images.count) * CGFloat(1 / 5.0))
            //imageView1.backgroundColor = UIColor.orange
            imageView1.animationRepeatCount = 0
            imageView1.startAnimating()
        }
    }
    
    func setImage2(images:NSArray,frame:CGRect) {
        if images.count > 0{
            imageView2.frame = frame
            imageView2.animationImages = images as? [UIImage]
            imageView2.animationDuration = TimeInterval(CGFloat(images.count) * CGFloat(1 / 5.0))
            //imageView2.backgroundColor = UIColor.orange
            imageView2.animationRepeatCount = 0
            imageView2.startAnimating()
        }
    }
    
    func setDetail(str:String,font:UIFont)  {
        detailLabel.text = str
        detailLabel.font = font
    }
    
    
    func createAttributeLabel(){
       
        let height:CGFloat = 25
        let width = self.frame.size.width / 2.0 - 20
        let x = self.frame.size.width / 2.0 + 10
        let page:CGFloat = 15
        
        bloodLabel = UILabel.init(frame: CGRect(x:x,y:page,width:width,height:height))
        bloodLabel.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        bloodLabel.textAlignment = .center
        self.addSubview(bloodLabel)
        
        speedLabel = UILabel.init(frame: CGRect(x:x,y:WDTool.bottom(View: bloodLabel) + page,width:width,height:height))
        speedLabel.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        speedLabel.textAlignment = .center
        self.addSubview(speedLabel)
        
        attackLabel = UILabel.init(frame: CGRect(x:x,y:WDTool.bottom(View: speedLabel) + page,width:width,height:height))
        attackLabel.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        attackLabel.textAlignment = .center
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
        }else if type == .kulou{
            bloodLabel.text = "blood:   50"
            speedLabel.text = "speed:   1"
            attackLabel.text = "attack:   2"
        }else if type == .GreenZom{
            bloodLabel.text = "blood:   50"
            speedLabel.text = "speed:   1"
            attackLabel.text = "attack:   3"
        }
        
    }
    
    func setLock(isLock:Bool)  {
        if isLock {
            let imageView:UIImageView = UIImageView.init(frame: CGRect(x:0,y:0,width:self.frame.size.width,height:self.frame.size.height))
            imageView.backgroundColor = UIColor.black
            imageView.image = UIImage.init(named: "lock.png")
            self.addSubview(imageView)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
