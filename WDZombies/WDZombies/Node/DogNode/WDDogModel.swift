//
//  WDDogModel.swift
//  WDZombies
//
//  Created by 吴冬 on 2018/1/21.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDDogModel: WDBaseModel {

    let stayArr:Array<SKTexture> = WDMapManager.sharedInstance.textureDic.object(forKey: DOG_STAY) as! Array<SKTexture>
    let fireArr:Array<SKTexture> = WDMapManager.sharedInstance.textureDic.object(forKey: DOG_FIRE) as! Array<SKTexture>
    
  
}
