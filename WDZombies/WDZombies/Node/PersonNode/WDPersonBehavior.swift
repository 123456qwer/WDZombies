//
//  WDPersonBehavior.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDPersonBehavior: WDBaseNodeBehavior {

    weak var personNode:WDPersonNode! = nil
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
        }
      
        
       
     
        if !direction.isEqual(to: personNode.direction as String) || !personNode.isMove {
           
            WDAnimationTool.moveAnimation(direction: direction, dic: personNode.moveDic,node:personNode)
            personNode.direction = direction
            personNode.isMove = true
        }
  
    }
    
    
    func reduceBlood(number:CGFloat)  {
        personNode.wdBlood -= number
        if personNode.wdBlood <= 0 && isGameOver == false{
            let diedAction = SKAction.fadeAlpha(to: 0, duration: 0.1)
            personNode.removePhy()
            personNode.run(diedAction, completion: {
            self.personNode.ggAction()
            })
            isGameOver = true
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
       
        self.reduceBlood(number: attackNode.wdAttack)
        self.reduceBloodLabel(node: personNode, attackNode: attackNode)
        
        WDAnimationTool.bloodAnimation(node:personNode)
        WDAnimationTool.beAttackAnimationForPerson(attackNode: attackNode, beAttackNode: beAttackNode as! WDPersonNode)
    }
    

    func autoAttackAction(node:WDBaseNode,zomNode:WDBaseNode) {
       
        personNode.direction = WDTool.calculateAutoDirection(point1: zomNode.position, point2:node.position )
        let arr:NSMutableArray = personNode.moveDic.object(forKey: personNode.direction) as! NSMutableArray
        personNode.texture = arr[0] as? SKTexture
        personNode.fireNode.position = WDTool.firePosition(direction: personNode.direction)
        
       
        
        personNode.fireNode.texture = personNode.fireDic.object(forKey: kUp) as? SKTexture
        let x1:CGFloat = node.position.x - zomNode.position.x
        let y1:CGFloat = node.position.y - zomNode.position.y
        
        let count:CGFloat = atan2(y1, x1)
        let count1 = CGFloat(Double.pi / 2.0)
        personNode.fireNode.zRotation = count + count1
        
        personNode.fireNode.isHidden = false
        self.perform(#selector(hiddenFireNode), with: nil, afterDelay: 0.1)
 
        WDAnimationTool.autoFireAnimation(node: personNode, zomNode: zomNode)
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
