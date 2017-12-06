//
//  WDDataManager.swift
//  WDZombies
//
//  Created by wudong on 2017/11/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SQLite3


class WDDataManager: NSObject {

    var canUseSkillPoint:NSInteger = 0
    
    static func initData(){
        
        let userModel:WDUserModel = WDUserModel.init()
        userModel.blood = 10
        userModel.speed = 3
        userModel.attack = 1
        userModel.fire_impact = 10
        userModel.attackDistance = 170
        userModel.skillCount = 1
        userModel.level = 0
        userModel.mapLevel = 0
        
        if userModel.insertSelfToDB(){
            print("人物属性插入成功")
        }
        
        
        let nameStrArr:NSArray = [BOOM,BLINK,SPEED]
        let detailStrAarr:NSArray = ["Waiting Time: 50S \n Damage: 5","Waiting Time: 30S \n Blink Distance: 200","Waiting Time: 50S \n Hold Time: 5S"]
        let level1StrArr:NSArray = ["0/5 \n Reduce Waiting Time 5S","0/5 \n Reduce Waiting Time 5S","0/5\n Reduce Waiting Time 5S"]
        let level2StrArr:NSArray = ["0/5 \n Increase Damage 1","0/5 \n Increase Distance 20","0/5 \n Increase Hold Time 1"]
        let level1Arr:NSArray = [50,30,50]
        let level2Arr:NSArray = [5,200,2]
        
        for index:NSInteger in 0...2 {
            
            let skillModel:WDSkillModel = WDSkillModel.init()
            skillModel.skillName = nameStrArr.object(at: index) as! String
            
            skillModel.skillLevel1Str = level1StrArr.object(at: index) as! String
            skillModel.skillLevel2Str = level2StrArr.object(at: index) as! String
            skillModel.skillDetailStr = detailStrAarr.object(at: index) as! String

            skillModel.skillLevel1 = level1Arr.object(at: index) as! Int
            skillModel.skillLevel2 = level2Arr.object(at: index) as! Int
            skillModel.haveLearn   = 0
            
            if skillModel.insertSelfToDB(){
                print("插入成功了!!!!again")
            }
        }
        
    }
    
    static let instance = WDDataManager()
    //对外提供创建单例对象的接口
    class func shareInstance() -> WDDataManager {
        return instance
    }
 
    var db:OpaquePointer? = nil
    
    
    func closeDB() {
        sqlite3_close(db)
    }
    
    func openDB() -> Bool {
        
        let dicumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        let DBPath = (dicumentPath! as NSString).appendingPathComponent("appDB.sqlite")
        let cDBPath = DBPath.cString(using: String.Encoding.utf8)
        
        if sqlite3_open(cDBPath, &db) != SQLITE_OK {
            print("数据库打开失败")
        }
        
        return creatTable()
    }
    
    

    
    //创建表
    func creatTable() -> Bool {
        //建表的SQL语句
        let creatUserTable = "CREATE TABLE IF NOT EXISTS 't_Skill' ( 'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'skillName' TEXT,'haveLearn' INTEGER,'skillLevel1' INTEGER,'skillLevel2' INTEGER,'skillLevel1Str' TEXT,'skillLevel2Str' TEXT,'skillDetailStr' TEXT);"
        let createUserTable2 = "CREATE TABLE IF NOT EXISTS 't_User' ( 'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'blood' TEXT,'attack' TEXT,'speed' TEXT,'level' INTEGER,'skillCount' INTEGER,'fire_impact' TEXT,'attackDistance' TEXT,'mapLevel' INTEGER)"
        //let creatCarTable = "CREATE TABLE IF NOT EXISTS 't_Car' ('ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'type' TEXT,'output' REAL,'master' TEXT);"
        //执行SQL语句-创建表 依然,项目中一般不会只有一个表
        return creatTableExecSQL(SQL_ARR: [creatUserTable,createUserTable2])
    }
    
    
    //执行建表SQL语句
    func creatTableExecSQL(SQL_ARR : [String]) -> Bool {
        for item in SQL_ARR {
            if execSQL(SQL: item) == false {
                return false
            }
        }
        return true
    }
    
    //执行SQL语句
    func execSQL(SQL : String) -> Bool {
        // 1.将sql语句转成c语言字符串
        let cSQL = SQL.cString(using: String.Encoding.utf8)
        //错误信息
        let errmsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        if sqlite3_exec(db, cSQL, nil, nil, errmsg) == SQLITE_OK {
            return true
        }else{
            print("SQL 语句执行出错 -> 错误信息: 一般是SQL语句写错了 \(String(describing: errmsg))")
            return false
        }
    }
    
    
    
    /// 删除所有数据
    ///
    /// - Returns: 
    func removeAllData() -> Bool {
        
        let SQL:String = "DELETE FROM t_Skill"
        return self.execSQL(SQL: SQL)
    }
    
    //查询数据库中数据
    func queryDBData(querySQL : String) -> [[String : AnyObject]]? {
        //定义游标对象
        var stmt : OpaquePointer? = nil
        
        //将需要查询的SQL语句转化为C语言
        if querySQL.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            let cQuerySQL = (querySQL.cString(using: String.Encoding.utf8))!
            //进行查询前准备操作
            // 1> 参数一:数据库对象
            // 2> 参数二:查询语句
            // 3> 参数三:查询语句的长度:-1
            // 4> 参数四:句柄(游标对象)
            
            if sqlite3_prepare_v2(db, cQuerySQL, -1, &stmt, nil) == SQLITE_OK {
                //准备好之后进行解析
                var queryDataArrM = [[String : AnyObject]]()
                while sqlite3_step(stmt) == SQLITE_ROW {
                    //1.获取 解析到的列(字段个数)
                    let columnCount = sqlite3_column_count(stmt)
                    //2.遍历某行数据
                    var dict = [String : AnyObject]()
                    for i in 0..<columnCount {
                        // 取出i位置列的字段名,作为字典的键key
                        let cKey = sqlite3_column_name(stmt, i)
                        let key : String = String(validatingUTF8: cKey!)!
                        
                        //取出i位置存储的值,作为字典的值value
                        let cValue = sqlite3_column_text(stmt, i)
                        let value =  String(cString:cValue!)
                        dict[key] = value as AnyObject
                    }
                    queryDataArrM.append(dict)
                }
                return queryDataArrM
            }
        }
        return nil
    }

    
    
}
