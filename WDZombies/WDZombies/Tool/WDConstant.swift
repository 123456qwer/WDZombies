//
//  WDConstant.swift
//  WDZombies
//
//  Created by wudong on 2017/12/7.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

let kPrintLog = 1  // 控制台输出开关 1：打开   0：关闭
let autoFire = true
// 控制台打印
func WDLog(item: Any...) {
    if kPrintLog == 1 {
        print(item.last!)
    }
}

//是否开启自动攻击
func WDAutoFire() -> Bool{
   return autoFire
}

//普通僵尸
public let NORMAL_ZOM       = "NORMAL_ZOM"

//红头僵尸
public let RED_ZOM          = "RED_ZOM"


//骷髅僵尸
public let KULOU_MOVE       = "KULOU_MOVE"
public let KULOU_DIED       = "KULOU_DIED"
public let KULOU_ATTACK     = "KULOU_ATTACK"
public let KULOU_NAME       = "KULOU_NAME"

//绿色僵尸
public let GREEN_MOVE       = "GREEN_MOVE"
public let GREEN_ATTACK1    = "GREEN_ATTACK1"
public let GREEN_ATTACK2    = "GREEN_ATTACK2"
public let GREEN_DIED       = "GREEN_DIED"
public let GREEN_SMOKE      = "GREEN_SMOKE"
public let GREEN_SMOKE_NAME = "GREEN_SMOKE_NAME"
public let GREEN_ZOM_NAME   = "GREEN_ZOM_NAME"
public let GREEN_CLAW_NAME  = "GREEN_CLAW_NAME"

//雾骑士
public let KNIGHT_MOVE    = "KNIGHT_MOVE"
public let KNIGHT_ATTACK1 = "KNIGHT_ATTACK1"
public let KNIGHT_ATTACK2 = "KNIGHT_ATTACK2"
public let KNIGHT_DIED    = "KNIGHT_DIED"
public let KNIGHT_NAME    = "KNIGHT_NAME"
public let KNIGHT_METEORITE1 = "KNIGHT_METEORITE1"
public let KNIGHT_METEORITE2 = "KNIGHT_METEORITE2"


//鱿鱼
public let SQUID_MOVE    = "SQUID_MOVE"
public let SQUID_ATTACK1 = "SQUID_ATTACK1"
public let SQUID_ATTACK2 = "SQUID_ATTACK2"
public let SQUID_DIED    = "SQUID_DIED"
public let SQUID_NAME    = "SQUID_NAME"
public let SQUID_INK     = "SQUID_INK"


//公牛
public let OX_MOVE       = "OX_MOVE"
public let OX_STAY       = "OX_STAY"
public let OX_ATTACK1    = "OX_ATTACK1"
public let OX_NAME       = "OX_NAME"
public let OX_DIED       = "OX_DIED"
public let OX_LIGHT      = "OX_LIGHT"

//骷髅骑士
public let KULOU_KNIGHT_MOVE    = "KULOU_KNIGHT_MOVE"
public let KULOU_KNIGHT_DIED    = "KULOU_KNIGHT_DIED"
public let KULOU_KNIGHT_ATTACK1 = "KULOU_KNIGHT_ATTACK1"
public let KULOU_KNIGHT_NAME    = "KULOU_KNIGHT_NAME"
public let KULOU_KNIGHT_STAY    = "KULOU_KNIGHT_STAY"

//海豹
public let SEAL_NAME       = "SEAL_NAME"
public let SEAL_MOVE       = "SEAL_MOVE"
public let SEAL_DIED       = "SEAL_DIED"
public let SEAL_STAY       = "SEAL_STAY"
public let SEAL_ATTACK1    = "SEAL_ATTACK1"
public let SEAl_ICE        = "SEAL_ICE"

//狗
public let DOG_NAME        = "DOG_NAME"
public let DOG_MOVE        = "DOG_MOVE"
public let DOG_DIED        = "DOG_DIED"
public let DOG_STAY        = "DOG_STAY"
public let DOG_ATTACK1     = "DOG_ATTACK1"
public let DOG_FIRE        = "DOG_FIRE"
public let DOG_STAY_FIRE   = "DOG_STAY_FIRE"


//玩家
public let PERSON_NAME    = "PERSON_NAME"
public let PERSON_FIRE    = "PERSON_FIRE"
public let PERSON_BOOM1   = "PERSON_BOOM1"
public let PERSON_BOOM2   = "PERSON_BOOM2"

//声音
public let MOVE_SOUND     = "MOVE_SOUND"

class WDConstant: NSObject {


    
}
