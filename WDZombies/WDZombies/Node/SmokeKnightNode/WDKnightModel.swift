//
//  WDKnightModel.swift
//  WDZombies
//
//  Created by wudong on 2017/12/19.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDKnightModel: WDBaseModel {

    let meteoriteArr1:Array<SKTexture> = WDMapManager.sharedInstance.textureDic.object(forKey: KNIGHT_METEORITE1) as! Array<SKTexture>
    let meteoriteArr2:Array<SKTexture> = WDMapManager.sharedInstance.textureDic.object(forKey: KNIGHT_METEORITE2) as! Array<SKTexture>
    
    let meteoriteTexture:SKTexture = WDMapManager.sharedInstance.beAttackTextureWithName(atlasName: "knightNodePic", textureName: "meteoriteShadow")
    
    
 
    
}
