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
 
    
    func physics() -> SKPhysicsBody{
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:100,height:100), center: CGPoint(x:0,y:-50))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        physicsBody.categoryBitMask = GREEN_ZOM_CATEGORY;
        physicsBody.contactTestBitMask = GREEN_ZOM_CONTACT;
        physicsBody.collisionBitMask = GREEN_ZOM_COLLISION;
        physicsBody.isDynamic = true;
        
        return physicsBody
    }
}
