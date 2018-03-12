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
    
    //默认死亡音效
    var diedMusic:String = "green_died"
    var attack1Music:String = "green_attack1"
    var attack2Music:String = "green_attack2"

    
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
    
    func setUsualPhyBody(size:CGSize,point:CGPoint) -> SKPhysicsBody {
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: size, center: point)

        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        physicsBody.categoryBitMask = USUAL_ZOM_CATEGORY;
        physicsBody.contactTestBitMask = USUAL_ZOM_CONTACT;
        physicsBody.collisionBitMask = USUAL_ZOM_COLLISION;
        physicsBody.isDynamic = true;
        
        return physicsBody
    }
    
    
    /// 配置怪物属性:基本属性,move,died,attack,beAttack
    func configureWithZomName(zomName:String){
        if zomName == GREEN_ZOM_NAME{
            self.configureGreenZom()
        }else if zomName == KNIGHT_NAME{
            self.configureKnightZom()
        }else if zomName == KULOU_NAME{
            self.configureKulouZom()
        }else if zomName == SQUID_NAME{
            self.configureSquidZom()
        }else if zomName == OX_NAME{
            self.configureOXZom()
        }else if zomName == KULOU_KNIGHT_NAME{
            self.configureKulouKnightZom()
        }else if zomName == SEAL_NAME{
            self.configureSealZom()
        }else if zomName == DOG_NAME{
            self.configureDogZom()
        }
    }
    
    //狗
    func configureDogZom(){
        self.setTextureWithString(moveName: DOG_MOVE, diedName: DOG_DIED, attack1Name: DOG_ATTACK1, attack2Name: "none")
        beAttackTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "dogPic", textureName: "dog_beAttack")
    }
    
    //海狮
    func configureSealZom(){
        self.setTextureWithString(moveName: SEAL_MOVE, diedName: SEAL_DIED, attack1Name: SEAL_ATTACK1, attack2Name: "none")
        beAttackTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "sealPic", textureName: "seal_died_1")
    }
    
    //骷髅骑士
    func configureKulouKnightZom() {
        self.setTextureWithString(moveName: KULOU_KNIGHT_MOVE, diedName: KULOU_KNIGHT_DIED, attack1Name: KULOU_KNIGHT_ATTACK1, attack2Name: "none")
        beAttackTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "kulouNightPic", textureName: "kulou_knight_died_1")
    }
    
    //公牛
    func configureOXZom() {
        self.setTextureWithString(moveName: OX_MOVE, diedName: OX_DIED, attack1Name: OX_ATTACK1, attack2Name: "none")
        beAttackTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "OXNodePic", textureName: "ox_beAttack")
    }
    
    //鱿鱼
    func configureSquidZom(){
        self.setTextureWithString(moveName: SQUID_MOVE, diedName: SQUID_DIED, attack1Name: SQUID_ATTACK1, attack2Name: "none")
        beAttackTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "squidNodePic", textureName: "squid_beAttack")
    }
    
    //绿僵尸
    func configureGreenZom(){
        self.diedMusic = "green_died"
        self.setTextureWithString(moveName: GREEN_MOVE, diedName: GREEN_DIED, attack1Name: GREEN_ATTACK1, attack2Name: GREEN_ATTACK2)
        beAttackTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "greenZomPic", textureName: "green_bAttack")
    }
    
    //雾骑士
    func configureKnightZom(){
        self.attack2Music = "smoke_attack3"
        self.attack1Music = "smoke_attack2"
        self.setTextureWithString(moveName: KNIGHT_MOVE, diedName: KNIGHT_DIED, attack1Name: KNIGHT_ATTACK1, attack2Name: KNIGHT_ATTACK2)
        beAttackTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "knightNodePic", textureName: "wuqishi_bAttack")
    }
    
    
    //骷髅
    func configureKulouZom(){
        self.diedMusic = "kulou_died"
        self.attack1Music = "kulou_attack"
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



