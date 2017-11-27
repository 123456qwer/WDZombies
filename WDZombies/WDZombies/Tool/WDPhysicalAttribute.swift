//
//  WDPhysicalAttribute.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/25.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

//body.categoryBitMask = 0;  <类别掩码，为0时代表我谁也碰撞不了>
//body.contactTestBitMask = 0; <碰撞检测掩码，为0时代表不触发检测>
//body.collisionBitMask = 0;  <允许碰撞掩码，为0时代表谁也碰撞不了我>
//想要发生碰撞，需要 categoryBitMask & collisionBitMask 运算，为非0，可以发生碰撞

let player_type:UInt32 = 0x03;
let wall_type:UInt32    = 0x01;
let fire_type:UInt32    = 0x04;
let normal_zom:UInt32   = 0x06;
let connonFire_type:UInt32  = 0x02;
let connon_type: UInt32  = 0x08;


let ZOMBIE:NSString = "zombie"
let PERSON:NSString = "person"
let FIRE:NSString   = "fire"
let MAGIC:NSString   = "magic"
let BOSS1:NSString = "BOSS1"
let KULOU:NSString = "KULOU"


class WDPhysicalAttribute: NSObject {

}
