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
    let REDUCE_TIME_TAG  = 200
    let INCREASE_DISTANCE_TAG = 300
    let DETAIL_LABEL_TAG = 400
    
    var skillType:personSkillType = .NoSelect
    var initiativeCount = 0
    var detailBtn:UIButton! = nil
    var initFrame:CGRect = CGRect()
    
    var detailStr:NSString! = nil
    var gifName:NSString = "blink"
    
    
    var blinkDistance = 200
    var blinkCD = 30
    var blinkCDStr:NSString! = nil
    var blinkDistanceStr:NSString! = nil
    
    func speedAction() {
        gifName = "speed"
    }
    
    func boomAction() {
        gifName = "boom"
    }
    
    func blinkAction() {
        
        gifName = "blink"
        let page:CGFloat = 5
        let width = (self.frame.size.height - page * 3) / 2.0
        let x:CGFloat = self.frame.size.width - page - width

        let passiveCD = UIButton.init(frame: CGRect(x:x,y:page ,width:width,height:width))
        passiveCD.backgroundColor = UIColor.blue
        passiveCD.tag = REDUCE_TIME_TAG
        passiveCD.addTarget(self, action: #selector(blinkAction(sender:)), for: .touchUpInside)
        self.addSubview(passiveCD)
        
        let label_x = WDTool.right(View: detailBtn)
        let labelWidth = self.frame.size.width - width - label_x - 5 * 3
        
        
        let cdLabel = UILabel.init(frame: CGRect(x:WDTool.right(View: detailBtn) + 5,y:5,width:labelWidth,height:width))
        cdLabel.textAlignment = .center
        cdLabel.numberOfLines = 0
        cdLabel.font = UIFont.systemFont(ofSize: 13)
        cdLabel.backgroundColor = UIColor.blue
        cdLabel.tag = REDUCE_TIME_TAG + 1
        cdLabel.text = "0/5\nReduce Waiting Time 5S"
        self.addSubview(cdLabel)
      
        
        let passiveDis = UIButton.init(frame: CGRect(x:x,y:WDTool.bottom(View: passiveCD) + page ,width:width,height:width))
        passiveDis.backgroundColor = UIColor.blue
        passiveDis.tag = INCREASE_DISTANCE_TAG
        passiveDis.addTarget(self, action: #selector(blinkAction(sender:)), for: .touchUpInside)
        self.addSubview(passiveDis)
        
        
        let distanceLabel = UILabel.init(frame: CGRect(x:WDTool.right(View: detailBtn) + 5,y:WDTool.bottom(View: cdLabel) + 5,width:labelWidth,height:width))
        distanceLabel.textAlignment = .center
        distanceLabel.numberOfLines = 0
        distanceLabel.font = UIFont.systemFont(ofSize: 13)
        distanceLabel.backgroundColor = UIColor.blue
        distanceLabel.tag = INCREASE_DISTANCE_TAG + 1
        distanceLabel.text = "0/5\nIncrease Distance 20"
        self.addSubview(distanceLabel)
        
        WDTool.masksToCircle(View: passiveCD)
        WDTool.masksToCircle(View: passiveDis)
        
        
        detailStr = "Waiting Time:  \(self.blinkCD)S \n Blink Distance: \(self.blinkDistance)" as NSString
        blinkCDStr = "0/5\nReduce Waiting Time 5S"
        blinkDistanceStr = "0/5\nIncrease Distance 20"
    }
    
    
    func createSkillWithType(type:personSkillType)  {
        
        initFrame = self.frame
        skillType = type
        detailStr = "123"
        
        let page:CGFloat = 30
        
        let width = (self.frame.size.height - page * 2)
        
    
        let initiative = UIButton.init(frame:CGRect(x:10,y:5,width:width,height:width))
        initiative.setBackgroundImage(WDTool.skillImage(skillType: skillType), for: .normal)
        initiative.addTarget(self, action: #selector(initiativeAction(sender:)), for: .touchUpInside)
        initiative.alpha = 0.2
        self.addSubview(initiative)
        
        WDTool.masksToCircle(View: initiative)
        
        
        detailBtn = UIButton.init(frame: CGRect(x:10,y:WDTool.bottom(View: initiative) + 5,width:width,height:40))
        detailBtn.backgroundColor = UIColor.blue
        detailBtn.setTitle("Detail", for: .normal)
        detailBtn.setTitle("Close", for: .selected)
        detailBtn.addTarget(self, action: #selector(detailAction(sender:)), for: .touchUpInside)
        self.addSubview(detailBtn)
        
        
        switch skillType {
        case .Attack:
            break
        case .Blink:
            self.blinkAction()
            break
        case .Speed:
            self.speedAction()
            break
        case .Boom:
            self.boomAction()
            break
        case .Attack_distance:
            break
        case .NoSelect:
            break
        case .Fire:
            break
        }
        
        
        
    }
    
  
    
    @objc func blinkAction(sender:UIButton) {
        
        let dic:NSDictionary = ["30":"0/5\nReduce Waiting Time 5S","25":"1/5\nReduce Waiting Time 5S","20":"0/5\nReduce Waiting Time 5S","15":"0/5\nReduce Waiting Time 5S","10":"0/5\nReduce Waiting Time 5S","5":"0/5\nReduce Waiting Time 5S"]
        
        if sender.tag == REDUCE_TIME_TAG {
            
            self.blinkCD -= 5

            if self.blinkCD < 5{
                return
            }
            
            
        }else if(sender.tag == INCREASE_DISTANCE_TAG){
            
            self.blinkDistance += 20

            if self.blinkDistance > 300 {
                return
            }
        }
        
        
        blinkCDStr = dic.object(forKey: "\(self.blinkCD)") as! NSString
        detailStr = "Waiting Time:  \(self.blinkCD)S \n Blink Distance: \(self.blinkDistance)" as NSString
        
    }
    
    
    @objc func detailAction(sender:UIButton)  {
       
        sender.isSelected = !sender.isSelected
        self.superview?.bringSubview(toFront: self)
        
        if sender.isSelected == true{
            
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = CGRect(x:10,y:10,width:kScreenWidth - 20,height:kScreenHeight - 20)
            }, completion: { (true) in
                
              self.createDetailLabel(sender: sender)
              self.createDetailImageView(sender: sender)
                
            })
            
        }else{
            
            UIView.animate(withDuration: 0.3) {
                self.frame = self.initFrame
            }
            
            let detailLabel = self.viewWithTag(DETAIL_LABEL_TAG)
            detailLabel?.removeFromSuperview()
            let imageV = self.viewWithTag(IMAGETAG)
            imageV?.removeFromSuperview()
            
        }
    }
    
    
    
    
    func createDetailLabel(sender:UIButton)  {
        
        let height = self.frame.size.height - WDTool.bottom(View: sender) - 20
        let detailLabel = UILabel.init(frame: CGRect(x:WDTool.left(View: sender),y:WDTool.bottom(View: sender) + 10,width:self.frame.size.width - 20,height:height))
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.systemFont(ofSize: 25)
        detailLabel.text = detailStr as String?
        detailLabel.backgroundColor = UIColor.blue
        detailLabel.tag = self.DETAIL_LABEL_TAG
        self.addSubview(detailLabel)
    }
    
    
    func createDetailImageView(sender:UIButton)  {
        
         let width = self.frame.size.width / 2.0 - 20
         let imageView = UIImageView.init(frame: CGRect(x:self.frame.size.width / 2.0 + 10,y:CGFloat(10),width:width,height:self.frame.size.height / 2.0 - 10 - 10 - 5))
         imageView.backgroundColor = UIColor.darkGray
         imageView.tag = self.IMAGETAG
         self.addSubview(imageView)
         
         //gif文件路径
        let path = Bundle.main.path(forResource: gifName as String, ofType: "gif")
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
         imageView.animationDuration = 5
         imageView.startAnimating()
 
    }
    
    
    @objc func initiativeAction(sender:UIButton)  {
        
        if initiativeCount == 1{
            return
        }
        
        initiativeCount += 1
        sender.alpha = 1
    }
    
}
