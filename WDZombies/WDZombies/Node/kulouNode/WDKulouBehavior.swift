//
//  WDKulouBehavior.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/11/17.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDKulouBehavior: WDBaseNodeBehavior {

    weak var kulouNode:WDKulouNode! = nil
    
    
    //独有方法<被攻击多次||5秒钟闪现一次>
    typealias _blinkMove = (_ kulou:WDKulouNode) -> Void
    var blinkMoveBlock:_blinkMove!
    var timerCount:NSInteger = 0
    
    @objc func blinkTimerAction(){
       
        if kulouNode.canMove {
           
            timerCount += 1
            if timerCount == 5{
                self.blinkMoveBlock(kulouNode)
                timerCount = 0
            }
        }
    }
    
    

 
    func blinkAction(personNode:WDPersonNode) {
        
        kulouNode.canMove = false
        kulouNode.alpha = 0.5
        var page:CGFloat = 80 / 2.0 + 20 / 2.0
        if kulouNode.position.x < personNode.position.x {
            page *= -1
        }
        
        let position = CGPoint(x:personNode.position.x + page,y:personNode.position.y)
        
        let moveA = SKAction.move(to: position, duration: 0.5)
        kulouNode.removePhy()
        self.perform(#selector(setPhy), with: nil, afterDelay: 0.7)
        kulouNode.run(moveA) {
            self.kulouNode.canMove = true
            self.kulouNode.alpha = 1
        }
    }
    


    
  
    
    
    
    //MARK:继承方法
    //被攻击
    override func beAttack(attackNode: WDBaseNode, beAttackNode: WDBaseNode) -> Bool{
       
        let isBreak = super.beAttack(attackNode: attackNode, beAttackNode: beAttackNode)
        if isBreak {
            self.perform(#selector(canMove), with: nil, afterDelay: 0.5)
        }
        return isBreak
    }
    
    //攻击
    override func attack(direction: NSString, nodeDic: NSDictionary) {
       
        let personNode = nodeDic.object(forKey: "personNode")
        
        kulouNode.removeAction(forKey: "move")
        kulouNode.canMove = false
        kulouNode.isMove  = false
        
        let attackAction = SKAction.animate(with: kulouNode.model.attack1Arr, timePerFrame: 0.15)
        self.perform(#selector(hitTheTarget(personNode:)), with: personNode, afterDelay: 0.25)
        kulouNode.run(attackAction) {
            self.kulouNode.canMove = true
        }
    }
    
    override func setNode(node: WDBaseNode) {
        kulouNode = node as! WDKulouNode
        attackTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(blinkTimerAction), userInfo: nil, repeats: true)
    }
    
    
    
    
    
    
    //MARK:私有
    /// 监测人物是否被击中
    @objc func hitTheTarget(personNode:WDPersonNode)  {
        if personNode.isBlink == false && kulouNode != nil{
            let distance:CGFloat = WDTool.calculateNodesDistance(point1:self.kulouNode.position,point2:personNode.position)
            
            let dis = personNode.size.width / 2.0 + kulouNode.size.width / 2.0
            print(dis,distance)
            
            if distance < dis {
                personNode.personBehavior.beAattackAction(attackNode: self.kulouNode, beAttackNode: personNode)
            }
        }
    }
    
    @objc func setPhy()  {
        if kulouNode != nil{
            kulouNode.setPhy()
        }
    }
    
    @objc func canMove()  {
        if kulouNode != nil {
            kulouNode.canMove = true
            timerCount = 0
            kulouNode.texture = kulouNode.model.moveArr[0]
            self.blinkMoveBlock(kulouNode)
        }
    }
}
