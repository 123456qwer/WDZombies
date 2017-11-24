//
//  WDSkillModel.swift
//  WDZombies
//
//  Created by wudong on 2017/11/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

class WDSkillModel: NSObject {

    var skillName:NSString = ""
    var skillLevel1:Int = 0
    var skillLevel2:Int = 0
    
    var skillLevel1Str:NSString = ""
    var skillLevel2Str:NSString = ""
    
    var skillDetailStr:NSString = ""
    var haveLearn:Int = 0
    
    // 'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'skillName' TEXT,'skillLevel1' INTEGER,'skillLevel2' INTEGER,'skillLevel1Str' TEXT,'skillLevel2Str' TEXT,'skillDetailStr' TEXT
    //"UPDATE 't_User' SET icon='\(newIcon)' WHERE name='name_6'"
    func changeSkillToSqlite() -> Bool {
        //更改
        let changeSQL = "UPDATE 't_Skill' set haveLearn = '\(haveLearn)',skillLevel1 = '\(skillLevel1)',skillLevel2 = '\(skillLevel2)',skillLevel1Str = '\(skillLevel1Str)',skillLevel2Str = '\(skillLevel2Str)',skillDetailStr = '\(skillDetailStr)'"
        if WDDataManager.shareInstance().execSQL(SQL: changeSQL) {
          
            print("修改数据成功")
            return true
        }else{
            
            return false
        }
        
    }
    
    func insertSelfToDB() -> Bool {
        //插入SQL语句
        let insertSQL = "INSERT INTO 't_Skill' (skillName,haveLearn,skillLevel1,skillLevel2,skillLevel1Str,skillLevel2Str,skillDetailStr) VALUES ('\(skillName)','\(haveLearn)',\(skillLevel1),'\(skillLevel2)',\(skillLevel1Str),\(skillLevel2Str),\(skillDetailStr));"
        if WDDataManager.shareInstance().execSQL(SQL: insertSQL) {
            print("插入数据成功")
            return true
        }else{
            print("插入数据失败")
            return false
        }
    }
    
    func searchToDB() -> Bool {
        
        let searchSQL = "SELECT * FROM t_Skill where skillName = '\(skillName)';"
        let dic = WDDataManager.shareInstance().queryDBData(querySQL: searchSQL)
        print(dic!)
        
        return true
    }
}
