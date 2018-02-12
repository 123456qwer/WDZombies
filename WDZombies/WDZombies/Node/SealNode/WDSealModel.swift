//
//  WDSealModel.swift
//  WDZombies
//
//  Created by wudong on 2018/1/10.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDSealModel: WDBaseModel {

    let stayArr:Array<SKTexture> = WDMapManager.sharedInstance.textureDic.object(forKey: SEAL_STAY) as! Array<SKTexture>
    let iceArr:Array<SKTexture> = WDMapManager.sharedInstance.textureDic.object(forKey: SEAl_ICE) as! Array<SKTexture>
    

}
