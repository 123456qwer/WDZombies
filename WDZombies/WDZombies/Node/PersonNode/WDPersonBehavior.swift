//
//  WDPersonBehavior.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit
import AudioToolbox

class WDPersonBehavior: WDBaseNodeBehavior {

    weak var personNode:WDPersonNode! = nil
    var lastRotation:CGFloat = 0
    var isGameOver = false
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "position" {
            WDTool.addSpeedSkillMove(direction: personNode.direction, personNode: personNode)
        }
    }
    
    /// 操作停止移动
    ///
    /// - Parameter direction: 方向
    override func stopMoveAction(direction:NSString) -> Void {
        
        if direction != "" {
            self.personNode.texture = (self.personNode.moveDic.object(forKey: direction)as! NSMutableArray).object(at: 0) as? SKTexture
            self.personNode.direction = direction
            self.personNode.removeAction(forKey: "move")
            self.personNode.isMove = false
        }
        
        
    }
    
    
    /// 人物移动
    ///
    /// - Parameter direction: 方向
    override func moveAction(direction:NSString) -> Void {
      
        if personNode.canMove {
            let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: personNode.wdSpeed, node: personNode!)
            personNode.position = point
            personNode.zPosition = 3 * 667 - personNode.position.y
            
            if !direction.isEqual(to: personNode.direction as String) || !personNode.isMove {
                
                WDAnimationTool.moveAnimation(direction: direction, dic: personNode.moveDic,node:personNode)
                if personNode.fly_isFire == false{
                    WDAnimationTool.fuzhujiRotateAnimation(direction: direction, personNode: personNode)
                }
                
                personNode.direction = direction
                personNode.isMove = true
            }
        }
    }
    
    
    func reduceBlood(number:CGFloat,monsterName:String)  {
        
        //震动效果
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        personNode.wdBlood -= number
        if personNode.wdBlood <= 0 && isGameOver == false{
            personNode.canMove = false
            personNode.removePhy()
            personNode.alpha = 0
            self.personNode.ggAction()
            isGameOver = true
            
            let model:WDMonsterModel = WDMonsterModel.initWithMonsterName(monsterName:monsterName)
            model.beKillCount = model.beKillCount + 1
            _ = model.changeMonsterToSqlite()
            
            return
        }
        
        let percentage:CGFloat = personNode.wdBlood / personNode.wdAllBlood
        let width:CGFloat = personNode.size.width * percentage
        //let x:CGFloat = personNode.size.width - width
        var bloodColor = UIColor.green
        
        if percentage >= 0.7{
            bloodColor = UIColor.init(red: 0, green: 165 / 255.0, blue: 129 / 255.0, alpha: 1)
        }else if percentage < 0.7 &&  percentage >= 0.4{
            bloodColor = UIColor.init(red: 255 / 255.0, green: 232 / 255.0, blue: 81 / 255.0, alpha: 1)
        }else if percentage < 0.4 && percentage >= 0.2{
            bloodColor = UIColor.init(red: 240 / 255.0, green: 136 / 255.0, blue: 66 / 255.0, alpha: 1)
        }else{
            bloodColor = UIColor.init(red: 115 / 255.0, green: 21 / 255.0, blue: 26 / 255.0, alpha: 1)
        }
        
        if #available(iOS 10.0, *) {
            let colorAction = SKAction.colorize(with: bloodColor, colorBlendFactor: 1, duration: 0.1)
            var widthAction:SKAction? = nil
            widthAction = SKAction.scale(to: CGSize(width:width,height:5), duration: 0.1)
            let group = SKAction.group([colorAction,widthAction!])
            personNode.bloodNode.run(group)
        } else {
            personNode.bloodNode.size = CGSize(width:width,height:5)
            personNode.color = bloodColor
        }
    }
    
    
    /// 人物受到伤害
    ///
    /// - Parameters:
    ///   - attackNode:
    ///   - beAttackNode:
    override func beAattackAction(attackNode: WDBaseNode, beAttackNode: WDBaseNode) {
       
        self.reduceBlood(number: attackNode.wdAttack,monsterName: attackNode.name!)
        self.reduceBloodLabel(node: personNode, attackNode: attackNode)
        
        WDAnimationTool.bloodAnimation(node:personNode)
        WDAnimationTool.beAttackAnimationForPerson(attackNode: attackNode, beAttackNode: beAttackNode as! WDPersonNode)
    }
    

    func autoAttackAction(node:WDBaseNode,zomNode:WDBaseNode) {
   
        personNode.fuzhujiNode.zRotation = lastRotation
        let x1:CGFloat = node.position.x - zomNode.position.x
        let y1:CGFloat = node.position.y - zomNode.position.y
            
        let count:CGFloat = atan2(y1, x1)
        let count1 = CGFloat(Double.pi)
        var endRotation = count + count1
        let temp = endRotation
        //避免旋转一周的尴尬
        if fabs(lastRotation - endRotation) > CGFloat(Double.pi){
            if endRotation > lastRotation{
                endRotation = -(CGFloat(Double.pi * 2) - endRotation)
            }else{
                endRotation = (CGFloat(Double.pi * 2) + endRotation)
            }
        }
        
        lastRotation = temp
        let ran = SKAction.rotate(toAngle: endRotation , duration: 0.25 / 2.0)
            personNode.fuzhujiNode.run(ran)
        WDAnimationTool.autoFireAnimation(node: personNode, zomNode: zomNode)
    }
    
    //被闪电击中
    func beFlashAttack(){
        personNode.removeAllActions()
        personNode.texture = personNode.beFlashTexture
        personNode.canMove = false
        personNode.isMove = false
        self.perform(#selector(canMove), with: nil, afterDelay: 0.5)
    }
    
    //被冰击中
    func beIceAttack(){
        let colorAction = SKAction.colorize(with: UIColor.blue, colorBlendFactor: 0.6, duration: 0.5)
        let colorAction2 = SKAction.colorize(with: UIColor.blue, colorBlendFactor: 0, duration: 0.5)
        let seq = SKAction.sequence([colorAction,colorAction2])
        personNode.wdSpeed = 1.5
        personNode.run(seq) {
            self.personNode.wdSpeed = 3
        }
        
    }
    
    @objc func canMove()  {
        personNode.canMove = true
    }
    
    override func attackAction(node: WDBaseNode) {
        personNode.fireNode.position = WDTool.firePosition(direction: personNode.direction)
        personNode.fireNode.texture = personNode.fireDic.object(forKey: personNode.direction) as? SKTexture
        personNode.fireNode.isHidden = false
        self.perform(#selector(hiddenFireNode), with: nil, afterDelay: 0.1)
        WDAnimationTool.fireAnimation(node: node as! WDPersonNode, zomNode: WDBaseNode.init())
    }
    
    @objc func hiddenFireNode() -> Void {
        personNode.fireNode.isHidden = true
    }
    
}
