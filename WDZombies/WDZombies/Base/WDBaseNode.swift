//
//  WDBaseNode.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDBaseNode: SKSpriteNode {
    
 
    var moveDic:NSMutableDictionary! = nil
    var attackDic:NSMutableDictionary! = nil
    var diedArr:NSMutableArray! = nil
    var direction:NSString! = nil
    var fireDic:NSMutableDictionary! = nil
    var isMove:Bool! = false
    var canMove:Bool! = true
    var isBlink:Bool! = false
    var isAttack:Bool! = false
    var isBoss:Bool!

    
    var wdLevel:NSInteger = 0
    var wdSkillCount:NSInteger = 0

    
    
//    self.beatOff = 5;
//    self.passiveSpeeds = 25;
    
    var wdAllBlood:CGFloat = 10
    var wdSpeed:CGFloat = 3
    var wdAttack:CGFloat = 1
    var wdBlood:CGFloat = 10
    var wdFire_impact = 10   //人物攻击击飞怪物的最远距离
    var wdAttackDistance = 170
    
    
    func configureModel(){} //设置属性
    func clearAction(){}      //清理
    
///////////////////////----共有---/////////////////////////
    
    var nodeBehavior:WDBaseNodeBehavior!
    var nodeModel:WDBaseModel!
    var experience:CGFloat = 20
    
    func setPhyBodyColor(size:CGSize,point:CGPoint){
//        let phyColorNode:SKSpriteNode = SKSpriteNode.init(color: .blue, size: size)
//        phyColorNode.position = point
//        phyColorNode.zPosition = 0
//        self.addChild(phyColorNode)
    }
    
}
