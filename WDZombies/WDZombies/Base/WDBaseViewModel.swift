//
//  WDBaseViewModel.swift
//  WDZombies
//
//  Created by wudong on 2017/12/19.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit


//***基础协议：基础设置*****//
protocol WDConfigureProtocol {
    
    var wdBlood:CGFloat{ get }
    var wdSpeed:CGFloat{ get }
    var wdAttack:CGFloat{ get }
    var wdFire_impact:CGFloat{ get }
    var wdAttackDistance:CGFloat{ get }
    
    func beAttackTexture(atlasName:String,textureName:String) -> SKTexture
    func animationWithPicName(picName:String) -> Array<SKTexture>
    
}


struct WDConfigureModel:WDConfigureProtocol {
    
    
   
    
    func beAttackTexture(atlasName: String ,textureName:String) -> SKTexture {
        return WDMapManager.sharedInstance.beAttackTextureWithName(atlasName:atlasName, textureName:textureName)
    }
    
    func animationWithPicName(picName: String) -> Array<SKTexture> {
        return WDMapManager.sharedInstance.textureDic.object(forKey: picName) as! Array<SKTexture>
    }
    
    var moveArr:Array<SKTexture>? = nil
    var diedArr:Array<SKTexture>? = nil
    var attack1Arr:Array<SKTexture>? = nil
    var attack2Arr:Array<SKTexture>? = nil
    var beAttackTexture:SKTexture? = nil
    
    var wdSpeed: CGFloat = 1
    var wdAttack: CGFloat = 3
    var wdFire_impact: CGFloat = 100
    var wdAttackDistance: CGFloat = 3
    var wdBlood: CGFloat = 20
    
    
    
   
}




