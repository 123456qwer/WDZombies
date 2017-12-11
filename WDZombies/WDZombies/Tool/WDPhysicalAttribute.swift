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


//player
let PLAYER_CATEGORY:UInt32     = 0x01    //0000  0001
let PLAYER_CONTACT:UInt32      = 0x02    //0000  0010
let PLAYER_COLLISION:UInt32    = 0x04    //0000  0100

//normalZom
let NORMAL_ZOM_CATEGORY:UInt32 = 0x2c    //0010  1100
let NORMAL_ZOM_CONTACT:UInt32  = 0x11    //0001  0001
let NORMAL_ZOM_COLLISION:UInt32 = 0x21   //0010  0001

//骷髅
let KULOU_CATEGORY:UInt32      = 0x04    //0000  0100
let KULOU_CONTACT:UInt32       = 0x01    //0000  0001
let KULOU_COLLISION:UInt32     = 0x01    //0000  0001

//greenZom
let GREEN_ZOM_CATEGORY:UInt32      = 0x04    //0000  0100
let GREEN_ZOM_CONTACT:UInt32       = 0x01    //0000  0001
let GREEN_ZOM_COLLISION:UInt32     = 0x01    //0000  0001

let ZOMBIE:NSString = "zombie"
let PERSON:NSString = "person"
let FIRE:NSString   = "fire"
let MAGIC:NSString   = "magic"
let BOSS1:NSString = "BOSS1"
let KULOU:NSString = "KULOU"


class WDPhysicalAttribute: NSObject {

}
