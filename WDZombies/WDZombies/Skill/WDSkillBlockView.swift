//
//  WDSkillBlockView.swift
//  WDZombies
//
//  Created by wudong on 2017/11/20.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

class WDSkillBlockView: UIView {

    let IMAGETAG = 100
    var skillType:personSkillType = .NoSelect
    var initiativeCount = 0
    var initLabel:UILabel! = nil
    var isSelect = false
    var initFrame:CGRect = CGRect()
    
    
    func blinkAction() {
        
        let page:CGFloat = 5
        let width = (self.frame.size.height - page * 3) / 2.0
        let x:CGFloat = self.frame.size.width - page - width

        let passiveCD = UIButton.init(frame: CGRect(x:x,y:page ,width:width,height:width))
        passiveCD.backgroundColor = UIColor.blue
        self.addSubview(passiveCD)
        
      
        
        let passiveDis = UIButton.init(frame: CGRect(x:x,y:WDTool.bottom(View: passiveCD) + page ,width:width,height:width))
        passiveDis.backgroundColor = UIColor.blue
        self.addSubview(passiveDis)
        
        
        WDTool.masksToCircle(View: passiveCD)
        WDTool.masksToCircle(View: passiveDis)
        
    }
    
    func createSkillWithType(type:personSkillType)  {
        
        initFrame = self.frame
        skillType = type
        
        let page:CGFloat = 30
        
        let width = (self.frame.size.height - page * 2)
        
    
        let initiative = UIButton.init(frame:CGRect(x:10,y:page,width:width,height:width))
        initiative.setBackgroundImage(WDTool.skillImage(skillType: skillType), for: .normal)
        initiative.addTarget(self, action: #selector(initiativeAction(sender:)), for: .touchUpInside)
        initiative.alpha = 0.5
        self.addSubview(initiative)
        
        WDTool.masksToCircle(View: initiative)
        
        
        initLabel = UILabel.init(frame: CGRect(x:10,y:WDTool.top(View: initiative) - 5 - 20,width:width,height:20))
        initLabel.text = "\(initiativeCount)/1"
        initLabel.backgroundColor = UIColor.blue
        initLabel.textAlignment = .center
        self.addSubview(initLabel)
        
        
        switch skillType {
        case .Attack:
            break
        case .Blink:
            self.blinkAction()
            break
        case .Speed:
            break
        case .Boom:
            break
        case .Attack_distance:
            break
        case .NoSelect:
            break
        case .Fire:
            break
        }
        
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isSelect = !isSelect
        self.superview?.bringSubview(toFront: self)

        if isSelect == true{
            
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = CGRect(x:10,y:10,width:kScreenWidth - 20,height:kScreenHeight - 20)
            }, completion: { (true) in
                let width = self.frame.size.width - WDTool.right(View: self.initLabel) - 10 - 10
                let imageView = UIImageView.init(frame: CGRect(x:WDTool.right(View: self.initLabel) + 10,y:CGFloat(10),width:width,height:self.frame.size.height - 20))
                imageView.backgroundColor = UIColor.darkGray
                imageView.tag = self.IMAGETAG
                self.addSubview(imageView)
                
                //gif文件路径
                let path = Bundle.main.path(forResource: "launchgifpic", ofType: "gif")
                //数据
                let source = CGImageSourceCreateWithURL(URL.init(fileURLWithPath: path!) as CFURL, nil)
                //3获取图片个数
                let count = CGImageSourceGetCount(source!)
                //time
                //let allTime = 0
                //所有图片
                let imageArray = NSMutableArray.init()
                //每针播放时间
                //let timeArray  = NSMutableArray.init()
                
                for i:size_t in 0...count - 1{
                    let image = CGImageSourceCreateImageAtIndex(source!, i, nil)
                    let imageA = UIImage.init(cgImage: image!)
                    imageArray.add(imageA)
                }
                
                imageView.animationImages = imageArray as? [UIImage]
                imageView.animationDuration = 3
                imageView.startAnimating()
                
            })
      
        }else{
            
            UIView.animate(withDuration: 0.3) {
                self.frame = self.initFrame
            }
            
            let imageV = self.viewWithTag(IMAGETAG)
            imageV?.removeFromSuperview()
            
        }
       
        
    }
    
    
    
    
    @objc func initiativeAction(sender:UIButton)  {
        
        if initiativeCount == 1{
            return
        }
        
        initiativeCount += 1
        initLabel.text = "\(initiativeCount)/1"
        sender.alpha = 1
    }
    
}
