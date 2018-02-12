//
//  WDOXModel.swift
//  WDZombies
//
//  Created by wudong on 2018/1/4.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDOXModel: WDBaseModel {

    let stayArr:Array<SKTexture> = WDMapManager.sharedInstance.textureDic.object(forKey: OX_STAY) as! Array<SKTexture>
    let lightArr:Array<SKTexture> = WDMapManager.sharedInstance.textureDic.object(forKey: OX_LIGHT) as! Array<SKTexture>
    

}
