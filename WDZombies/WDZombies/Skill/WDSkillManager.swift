//
//  WDSkillManager.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/25.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDSkillManager: NSObject {
    
    static let sharedInstance = WDSkillManager.init()
    private override init() {}
    
    
    func skillWithType(skillView:WDSkillView,node:WDPersonNode) -> Void {
        
        switch skillView.skillType {
        case .Attack?:
            self.addAttackAction(skillView: skillView, node: node)
            break
        case .Blink?:
            self.blinkAction(skillView: skillView, node: node)
            break
        case .Speed?:
            self.addSpeedAction(skillView: skillView, node: node)
            break
        case .Boom?:
            self.boomAction(skillView: skillView, node: node)
            break
        case .Attack_distance?:

            break
        case .NoSelect?:
            
            break
   
        case .Fire?:
            
            break
        case .none:
            break
        }

    }
    
    
    /// 公用
    /// - Returns:
    func createLabelWithNumber(str:NSString,skillView:WDSkillView,node:WDPersonNode,color:UIColor) -> NSDictionary {
        
        skillView.isUserInteractionEnabled = false
        skillView.alpha = 0.2
        
       let timeLabel:UILabel = UILabel.init(frame: CGRect(x:0,y:0,width:skillView.frame.size.width,height:skillView.frame.size.height))
        timeLabel.textAlignment = .center
        timeLabel.tag = 100
        timeLabel.font = UIFont.systemFont(ofSize: 25)
        timeLabel.text = str as String
        timeLabel.textColor = color
        skillView.addSubview(timeLabel)
        skillView.addTimerWithLabel(label: timeLabel)
        
        let fileUrl:NSURL = Bundle.main.url(forResource: "skillFrame", withExtension: "gif")! as NSURL
        let gifSource:CGImageSource = CGImageSourceCreateWithURL(fileUrl, nil)!;
        let frameCout:size_t = CGImageSourceGetCount(gifSource)
        //print(gifSource)
        let arr:NSMutableArray = NSMutableArray.init()
        for index:size_t in 0...frameCout - 1 {
            
            let imageRef:CGImage = CGImageSourceCreateImageAtIndex(gifSource,index,nil)!
            let image:UIImage = UIImage.init(cgImage: imageRef)
            arr.add(image)
            
        }
        
        let imageView:UIImageView = UIImageView.init(frame: CGRect(x:0,y:0,width:skillView.frame.size.width,height:skillView.frame.size.height))
        imageView.tag = 200
        imageView.animationImages = arr as? [UIImage]
        imageView.animationDuration = 0.3
        imageView.startAnimating()
        skillView.addSubview(imageView)
        
        return  ["personNode":node,"imageView":imageView]
    }
    
    
    
    //增加攻击
    func addAttackAction(skillView:WDSkillView,node:WDPersonNode) -> Void {
        let pasDic:NSDictionary = self.createLabelWithNumber(str: "20", skillView: skillView, node: node, color: UIColor.blue)
        node.wdAttack += 2
        self.perform(#selector(attackReduce(dic:)), with: pasDic, afterDelay: 5)
    }
    
    
    //炸弹技能
    func boomAction(skillView:WDSkillView,node:WDPersonNode) -> Void {
         let pasDic:NSDictionary = self.createLabelWithNumber(str: "1", skillView: skillView, node: node, color: UIColor.blue)
         let imageView:UIImageView = pasDic.object(forKey: "imageView") as! UIImageView
         imageView.removeFromSuperview()
        WDAnimationTool.boomAnimation(node:node)
    }
    
    
    //闪现技能
    func blinkAction(skillView:WDSkillView,node:WDPersonNode) -> Void {
        let pasDic:NSDictionary = self.createLabelWithNumber(str: "30", skillView: skillView, node: node ,color: UIColor.black)
     
        let imageView:UIImageView = pasDic.object(forKey: "imageView") as! UIImageView
        imageView.removeFromSuperview()
     
        WDAnimationTool.blinkAnimation(node: node)
        
        
    }
    
    
    //增加移速技能
    func addSpeedAction(skillView:WDSkillView,node:WDPersonNode) -> Void {
        
        
        let pasDic:NSDictionary = self.createLabelWithNumber(str: "30", skillView: skillView, node: node ,color: UIColor.blue)
      
        node.wdSpeed += 2
   
        self.perform(#selector(speedReduce(dic:)), with: pasDic, afterDelay: 5)
        let emitter:SKEmitterNode = WDAnimationTool.createEmitterNode(name:"Fire")
        emitter.name = "addSpeed"
        emitter.position = node.position
        node.parent?.addChild(emitter)
        
    }
    
    
    
    
    
    

    
    @objc func speedReduce(dic:NSDictionary) -> Void {
        let personNode:WDPersonNode = dic.object(forKey: "personNode") as! WDPersonNode
        let node = personNode.parent?.childNode(withName: "addSpeed")
        node?.removeFromParent()
        let imageView:UIImageView = dic.object(forKey: "imageView") as! UIImageView
        imageView.removeFromSuperview()
        personNode.wdSpeed -= 2
    }
 
    @objc func attackReduce(dic:NSDictionary) -> Void {
        let personNode:WDPersonNode = dic.object(forKey: "personNode") as! WDPersonNode
  
        let imageView:UIImageView = dic.object(forKey: "imageView") as! UIImageView
        imageView.removeFromSuperview()
        personNode.wdAttack -= 2
    }
    
}
