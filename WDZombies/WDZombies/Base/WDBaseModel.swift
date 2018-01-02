//
//  WDBaseModel.swift
//  WDZombies
//
//  Created by wudong on 2017/12/19.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDBaseModel: NSObject {
    
    var moveArr:Array<SKTexture>! = nil
    var diedArr:Array<SKTexture>! = nil
    var attack1Arr:Array<SKTexture>! = nil
    var attack2Arr:Array<SKTexture>! = nil
    var beAttackTexture:SKTexture! = nil
    
    var wdSpeed: CGFloat = 1
    var wdAttack: CGFloat = 3
    var wdFire_impact: CGFloat = 100
    var wdAttackDistance: CGFloat = 3
    var wdBlood: CGFloat = 20
    
    
    func randomBornPosition() -> CGPoint {
        let x:CGFloat = CGFloat(arc4random() % UInt32(kScreenHeight*2));
        let y:CGFloat = CGFloat(arc4random() % UInt32(kScreenWidth*2));
        return CGPoint(x:x, y:y)
    }
    
    func configureWithZomName(zomName:String){
        if zomName == GREEN_ZOM_NAME{
            self.configureGreenZom()
        }else if zomName == KNIGHT_NAME{
            self.configureKnightZom()
        }else if zomName == KULOU_NAME{
            self.configureKulouZom()
        }else if zomName == SQUID_NAME{
            self.configureSquidZom()
        }
    }
    
    func configureSquidZom(){
        self.setTextureWithString(moveName: SQUID_MOVE, diedName: SQUID_DIED, attack1Name: SQUID_ATTACK1, attack2Name: "none")
        beAttackTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "squidNodePic", textureName: "squid_beAttack")
    }
    
    func configureGreenZom(){
        self.setTextureWithString(moveName: GREEN_MOVE, diedName: GREEN_DIED, attack1Name: GREEN_ATTACK1, attack2Name: GREEN_ATTACK2)
        beAttackTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "greenZomPic", textureName: "green_bAttack")
    }
    
    func configureKnightZom(){
        self.setTextureWithString(moveName: KNIGHT_MOVE, diedName: KNIGHT_DIED, attack1Name: KNIGHT_ATTACK1, attack2Name: KNIGHT_ATTACK2)
        beAttackTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "knightNodePic", textureName: "wuqishi_bAttack")
    }
    
    func configureKulouZom(){
        self.setTextureWithString(moveName: KULOU_MOVE, diedName: KULOU_DIED, attack1Name: KULOU_ATTACK, attack2Name: "none")
        beAttackTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "kulouPic", textureName: "kulou_battack")
    }
    
    
    func setTextureWithString(moveName:String,diedName:String,attack1Name:String,attack2Name:String)  {
        if moveName != "none"{
             moveArr = WDMapManager.sharedInstance.textureDic.object(forKey: moveName) as! Array<SKTexture>
        }
        
        if diedName != "none"{
            diedArr = WDMapManager.sharedInstance.textureDic.object(forKey: diedName) as! Array<SKTexture>
        }
       
        if attack1Name != "none" {
             attack1Arr = WDMapManager.sharedInstance.textureDic.object(forKey: attack1Name) as! Array<SKTexture>
        }
        
        if attack2Name != "none" {
            attack2Arr = WDMapManager.sharedInstance.textureDic.object(forKey: attack2Name) as! Array<SKTexture>
        }
       
        
    }
    
    
}



