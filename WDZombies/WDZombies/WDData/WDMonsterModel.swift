//
//  WDMonsterModel.swift
//  WDZombies
//
//  Created by wudong on 2018/1/10.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit

class WDMonsterModel: NSObject {

//    monsterName' TEXT,'killCount' INTEGER,'beKillCount' INTEGER
   @objc var monsterName:String    = ""
   @objc var killCount:NSInteger   = 0
   @objc var beKillCount:NSInteger = 0
   @objc var overTime:NSInteger    = 0
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    static func initWithMonsterName(monsterName:String) -> WDMonsterModel {
        let model:WDMonsterModel = WDMonsterModel.init()
        model.monsterName = monsterName
        _ = model.searchToDB()
        return model
    }
    
    func insertSelfToDB() -> Bool {
        //插入SQL语句
        let insertSQL = "INSERT INTO 't_Monster' (monsterName,killCount,beKillCount,overTime) VALUES ('\(monsterName)','\(killCount)','\(beKillCount)','\(overTime)');"
        if WDDataManager.shareInstance().execSQL(SQL: insertSQL) {
            print("插入数据成功")
            return true
        }else{
            print("插入数据失败")
            return false
        }
    }
    
    func searchToDB() -> Bool {
        
        let searchSQL = "SELECT * FROM t_Monster where monsterName = '\(monsterName)';"
        let arr:NSArray = WDDataManager.shareInstance().queryDBData(querySQL: searchSQL)! as NSArray
        if arr.count > 0{
            let dic:NSDictionary = arr.object(at: 0) as! NSDictionary
            self.setValuesForKeys(dic as! [String : Any])
        }else{
            return false
        }
        
        return true
    }
    
    func changeMonsterToSqlite() -> Bool {
        //更改
        let changeSQL = "UPDATE 't_Monster' set killCount = '\(killCount)', beKillCount = '\(beKillCount)',overTime = '\(overTime)' where monsterName = '\(monsterName)'"
        if WDDataManager.shareInstance().execSQL(SQL: changeSQL) {
            
            print("修改数据成功")
            return true
        }else{
            
            return false
        }
    }
}
