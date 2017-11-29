//
//  WDUserModel.swift
//  WDZombies
//
//  Created by wudong on 2017/11/29.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

class WDUserModel: NSObject {

    @objc var blood:CGFloat = 0
    @objc var attack:CGFloat = 0
    @objc var speed:CGFloat = 0
    @objc var level:NSInteger = 0
    @objc var skillCount:NSInteger = 0
    @objc var fire_impact:CGFloat = 0  //人物攻击击飞怪物的最远距离
    @objc var attackDistance:CGFloat = 0 //攻击距离,子弹飞行距离
    @objc var mapLevel:NSInteger = 0
    
    func insertSelfToDB() -> Bool {
        //插入SQL语句
        let insertSQL = "INSERT INTO 't_User' (blood,attack,speed,level,skillCount,fire_impact,attackDistance,mapLevel) VALUES ('\(blood)','\(attack)','\(speed)','\(level)','\(skillCount)','\(fire_impact)','\(attackDistance)','\(mapLevel)');"
        if WDDataManager.shareInstance().execSQL(SQL: insertSQL) {
            print("插入数据成功")
            return true
        }else{
            print("插入数据失败")
            return false
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    func changeSkillToSqlite() -> Bool {
        //更改
        let changeSQL = "UPDATE 't_User' set blood = '\(blood)',attack = '\(attack)',speed = '\(speed)',level = '\(level)',skillCount = '\(skillCount)',fire_impact = '\(fire_impact)',attackDistance = '\(attackDistance)', mapLevel = '\(mapLevel)'"
        if WDDataManager.shareInstance().execSQL(SQL: changeSQL) {
            
            print("修改数据成功")
            return true
        }else{
            
            return false
        }
    }
    
    
    
    func searchToDB() -> Bool {
        
        let searchSQL = "SELECT * FROM t_User"
        let arr:NSArray = WDDataManager.shareInstance().queryDBData(querySQL: searchSQL)! as NSArray
        if arr.count > 0{
            let dic:NSDictionary = arr.object(at: 0) as! NSDictionary
            self.setValuesForKeys(dic as! [String : Any])
        }else{
            return false
        }
        
        
        return true
    }
    
    
}
