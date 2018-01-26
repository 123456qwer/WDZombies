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
    @objc var level:NSInteger = 1
    @objc var experience:NSInteger = 0  //当前经验值，升级清空
    @objc var skillCount:NSInteger = 0
    @objc var fire_impact:CGFloat = 0  //人物攻击击飞怪物的最远距离
    @objc var attackDistance:CGFloat = 0 //攻击距离,子弹飞行距离
    @objc var mapLevel:NSInteger = 0
    @objc var monsterCount:NSInteger = 0
    @objc var experienceAll:NSInteger = 0 //人物升级需要的经验值
    @objc var score:NSInteger = 0 //人物最后一关总得分
    
    func insertSelfToDB() -> Bool {
        //插入SQL语句
        let insertSQL = "INSERT INTO 't_User' (blood,attack,speed,level,skillCount,fire_impact,attackDistance,mapLevel,monsterCount,experience,experienceAll,score) VALUES ('\(blood)','\(attack)','\(speed)','\(level)','\(skillCount)','\(fire_impact)','\(attackDistance)','\(mapLevel)','\(monsterCount)','\(experience)','\(experienceAll)','\(score)');"
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
        let changeSQL = "UPDATE 't_User' set blood = '\(blood)',attack = '\(attack)',speed = '\(speed)',level = '\(level)',skillCount = '\(skillCount)',fire_impact = '\(fire_impact)',attackDistance = '\(attackDistance)', mapLevel = '\(mapLevel)',monsterCount = '\(monsterCount)',experience = '\(experience)',experienceAll = '\(experienceAll)',score = '\(score)'"
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
    
    
    static func addExperience(nodeExperience:NSInteger) -> Bool{
    let model:WDUserModel = WDUserModel.init()
    _ = model.searchToDB()
        var levelUp = false
    model.experience = model.experience + nodeExperience
        if model.experience > model.experienceAll{
            model.experience = 0
            model.level = model.level + 1
            model.skillCount = model.skillCount + 1
            model.experienceAll = WDUserModel.levelAllExperience(nowLevel: model.level)
            levelUp = true
        }
    _ = model.changeSkillToSqlite()
        
        return levelUp
    }
    
    static func levelAllExperience(nowLevel:NSInteger) -> NSInteger{
        switch nowLevel {
        
        case 1:
            return 200
        case 2:
            return 400
        case 3:
            return 800
        case 4:
            return 800
        case 5:
            return 800
        case 6:
            return 800
        case 7:
            return 800
        case 8:
            return 800
        case 9:
            return 800
            
        default:
            return 10000
        }
        
    }
}
