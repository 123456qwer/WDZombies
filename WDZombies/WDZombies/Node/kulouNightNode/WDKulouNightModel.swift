//
//  WDKulouNightModel.swift
//  WDZombies
//
//  Created by wudong on 2018/1/5.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDKulouNightModel: WDBaseModel {
    let stayArr:Array<SKTexture> = WDMapManager.sharedInstance.textureDic.object(forKey: KULOU_KNIGHT_STAY) as! Array<SKTexture>

}
