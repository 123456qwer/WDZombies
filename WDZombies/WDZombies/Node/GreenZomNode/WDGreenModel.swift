//
//  WDGreenModel.swift
//  WDZombies
//
//  Created by wudong on 2017/12/19.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit
class WDGreenModel: WDBaseModel {

    var smokeArr:Array<SKTexture> = WDMapManager.sharedInstance.textureDic.object(forKey: GREEN_SMOKE) as! Array<SKTexture>
    var clawArr:Array<SKTexture> = WDMapManager.sharedInstance.textureDic.object(forKey: GREEN_CLAW_NAME) as! Array<SKTexture>
    
    
    func physics() -> SKPhysicsBody{
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:40,height:40))
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        
        physicsBody.categoryBitMask = GREEN_ZOM_CATEGORY
        physicsBody.contactTestBitMask = GREEN_ZOM_CONTACT
        physicsBody.collisionBitMask = GREEN_ZOM_COLLISION
        physicsBody.isDynamic = true
        
        return physicsBody
    }

    
}
