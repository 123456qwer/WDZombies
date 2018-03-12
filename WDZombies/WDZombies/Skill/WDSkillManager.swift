//
//  WDSkillManager.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/25.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


public let BLINK:String = "blink"
public let SPEED:String = "speed"
public let BOOM :String = "boom"
public let IMMUNE:String = "immune_Injury"
let kMusicKey = "kMusicKey"

class WDSkillManager: NSObject,AVAudioPlayerDelegate {
    
    static let sharedInstance = WDSkillManager.init()
    private override init() {}
  
    

    var modelDic:NSMutableDictionary! = nil
    var playerMusicArr:NSMutableArray = NSMutableArray.init()
    
    func initModelDic() {
        
        if modelDic == nil{
            modelDic = NSMutableDictionary.init()
        }else{
            modelDic.removeAllObjects()
        }
        
        let skillArr:NSArray = [BLINK,SPEED,BOOM,IMMUNE]
        if WDDataManager.shareInstance().openDB(){
            for index:NSInteger in 0...skillArr.count - 1 {
                let skillName = skillArr.object(at: index)
                let model:WDSkillModel = WDSkillModel.init()
                model.skillName = skillName as! String
                if model.searchToDB(){
                    print("技能管理者插入\(model.skillName) 技能成功")
                }else{
                    print("插入技能失败")
                }
                
                modelDic.setObject(model, forKey: model.skillName as NSCopying)
            }
    
        }
        
        WDDataManager.shareInstance().closeDB()
    }
    
    //代理方法播放完毕，删除音频
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playerMusicArr.remove(player)
    }
    
   
    
    func skillWithType(skillView:WDSkillView,node:WDPersonNode) -> Void {
        
        let player = WDSkillMusicPlayer.init()
        
        
        switch skillView.skillType {
        case .Attack?:
            self.addAttackAction(skillView: skillView, node: node)
            break
        case .BLINK?:

    
            node.run(SKAction.playSoundFileNamed(player.blink, waitForCompletion: false))
            self.blinkAction(skillView: skillView, node: node)
            break
        case .SPEED?:
            
            node.run(SKAction.playSoundFileNamed(player.speed, waitForCompletion: false))
            self.addSpeedAction(skillView: skillView, node: node)
            break
        case .BOOM?:
            
            self.perform(#selector(boomMusic(dic:)), with: ["player":player], afterDelay: 1.5)
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
        case .immune_Injury?:
            
            node.run(SKAction.playSoundFileNamed(player.dun, waitForCompletion: false))
            self.immuneAction(skillView: skillView, node: node)
            break
        }
        
        if (player.player != nil) {
            player.player.delegate = self
        }
    }
    
    //炸弹延迟调用
    @objc func boomMusic(dic:NSDictionary) -> Void {
        let musicPlayer:WDSkillMusicPlayer = dic.object(forKey: "player") as! WDSkillMusicPlayer
        musicPlayer.playWithName(musicName: musicPlayer.boom)
        playerMusicArr.add(musicPlayer.player)
        
        musicPlayer.player.delegate = self
    }
    
    /// 公用
    /// - Returns:
    func createLabelWithNumber(str:String,skillView:WDSkillView,node:WDPersonNode,color:UIColor) -> NSDictionary {
        
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
    
    
    //免疫伤害技能
    func immuneAction(skillView:WDSkillView,node:WDPersonNode) -> Void {
        let model:WDSkillModel = modelDic.object(forKey: IMMUNE) as! WDSkillModel
        let pasDic:NSDictionary = self.createLabelWithNumber(str: "\(model.skillLevel1)", skillView: skillView, node: node, color: UIColor.blue)
        let imageView:UIImageView = pasDic.object(forKey: "imageView") as! UIImageView
        imageView.removeFromSuperview()
        node.isImmune = true
        node.immuneNode.isHidden = false
        
        self.perform(#selector(immuneReduce(dic:)), with: pasDic, afterDelay: TimeInterval(model.skillLevel2))
    }
    
    //炸弹技能
    func boomAction(skillView:WDSkillView,node:WDPersonNode) -> Void {
        
         let model:WDSkillModel = modelDic.object(forKey: BOOM) as! WDSkillModel
         let pasDic:NSDictionary = self.createLabelWithNumber(str: "\(model.skillLevel1)", skillView: skillView, node: node, color: UIColor.blue)
         let imageView:UIImageView = pasDic.object(forKey: "imageView") as! UIImageView
         imageView.removeFromSuperview()
        WDAnimationTool.boomAnimation(node:node)
    }
    
    
    //闪现技能
    func blinkAction(skillView:WDSkillView,node:WDPersonNode) -> Void {
        
        let model:WDSkillModel = modelDic.object(forKey: BLINK) as! WDSkillModel
        let pasDic:NSDictionary = self.createLabelWithNumber(str: "\(model.skillLevel1)", skillView: skillView, node: node ,color: UIColor.black)
     
        let imageView:UIImageView = pasDic.object(forKey: "imageView") as! UIImageView
        imageView.removeFromSuperview()
     
        WDAnimationTool.blinkAnimation(node: node,model:model)

    }
    
    
    //增加移速技能
    func addSpeedAction(skillView:WDSkillView,node:WDPersonNode) -> Void {
        
        let model:WDSkillModel = modelDic.object(forKey: SPEED) as! WDSkillModel
        let pasDic:NSDictionary = self.createLabelWithNumber(str: "\(model.skillLevel1)", skillView: skillView, node: node ,color: UIColor.blue)
      
        node.wdSpeed += 2
   
        self.perform(#selector(speedReduce(dic:)), with: pasDic, afterDelay: TimeInterval(model.skillLevel2))
        let emitter:SKEmitterNode = WDAnimationTool.createEmitterNode(name:"Fire")
        emitter.name = "addSpeed"
        emitter.position = node.position
        node.parent?.addChild(emitter)
        
    }
    
    
    
    
    
    
    @objc func immuneReduce(dic:NSDictionary) -> Void {
         let personNode:WDPersonNode = dic.object(forKey: "personNode") as! WDPersonNode
        personNode.isImmune = false
        personNode.immuneNode.isHidden = true
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
