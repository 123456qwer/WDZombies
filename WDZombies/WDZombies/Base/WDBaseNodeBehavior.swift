//
//  WDBaseNodeBehavior.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDBaseNodeBehavior: NSObject {

        
    
    typealias diedReturn = (_ node:WDBaseNode) -> Void
    
    
    var alreadyDied:diedReturn?
    var xScale:CGFloat = 1
    var yScale:CGFloat = 1

    func stopMoveAction(direction:NSString) -> Void {}
    func moveAction(direction:NSString) -> Void {}
    func attackAction(node:WDBaseNode) -> Void {}
    func beAattackAction(attackNode:WDBaseNode,beAttackNode:WDBaseNode) -> Void {}
    func diedAction() -> Void {}
    
///////////////////////以上重构之前的方法//////////////////////
    
    
    weak var node:WDBaseNode!
    
    
    typealias _moveBlock = (_ node:WDBaseNode) -> Void
    var addUpToBlood = 0
    var attackAllCount = 0
    
    
    var moveBlock:_moveBlock!
    var moveLink:CADisplayLink!
    var attackTimer:Timer!
  
    //MARK:对外
    /// 创建link，开始移动
    func starMove(){
        moveLink = CADisplayLink.init(target: self, selector: #selector(_linkMove))
        moveLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    /// 僵尸移动
    func move(direction:NSString,nodeDic:NSDictionary){
        
        if node.wdBlood <= 0 {
            self.node.canMove = false
            self.clearAction()
            return
        }
        
        if node.canMove == true {
            
            let personNode:WDPersonNode = nodeDic.object(forKey: "personNode") as! WDPersonNode
            let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: node.speed, node: node)
            node.position = point
            node.zPosition = 3 * 667 - node.position.y;
            let bossDirection = WDTool.calculateDirectionForBoss1(bossPoint: node.position, personPoint: personNode.position)
            
            if !bossDirection.isEqual(to: node.direction as String) || !node.isMove {
                
                node.removeAction(forKey: "move")
                let moveAction = SKAction.animate(with: node.nodeModel.moveArr, timePerFrame: 0.2)
                let repeatAction = SKAction.repeatForever(moveAction)
                if bossDirection.isEqual(to: kLeft as String){
                    node.xScale = xScale
                    node.yScale = yScale
                }else{
                    node.xScale = -1 * xScale
                    node.yScale = yScale
                }
                
                node.run(repeatAction, withKey: "move")
                node.direction = bossDirection
                node.isMove = true
            }
        }
    }
    
    
    /// 僵尸停止移动
    func stopMove(direction:NSString,nodeDic:NSDictionary){
    }
    
    
  
    
    /// 僵尸攻击
    func attack(direction:NSString,nodeDic:NSDictionary){
        
    }
    
    
    
    /// 僵尸被攻击
    func beAttack(attackNode:WDBaseNode,beAttackNode:WDBaseNode) -> Bool{
        beAttackNode.wdBlood -= attackNode.wdAttack
        addUpToBlood += NSInteger(attackNode.wdAttack)
        
        
        if beAttackNode.wdBlood <= 0 {
            self.died()
            self._removePhysics()
            return false
        }
        
        self.reduceBloodLabel(node: beAttackNode, attackNode: attackNode)

        
        if addUpToBlood >= 10 && beAttackNode.canMove == true{
            
            beAttackNode.removeAllActions()
            beAttackNode.canMove = false
            beAttackNode.isMove = false
            addUpToBlood = 0
            beAttackNode.texture = beAttackNode.nodeModel.beAttackTexture
            
            return true
        }else{
            return false
        }
    
    }
    
    /// 僵尸死亡
    func died(){
        
        node.removeAllActions()
        let diedAction = SKAction.animate(with: node.nodeModel.diedArr , timePerFrame: 0.2)
        node.run(diedAction) {
            self.alreadyDied!(self.node)
            self.node.removeFromParent()
        }
    }
    
    
    
    /// 伤害数值显示
    func reduceBloodLabel(node:WDBaseNode,attackNode:WDBaseNode)  {
        
        WDAnimationTool.bloodAnimation(node: node)
        
        var xScale:CGFloat = 1
        if node.xScale < 0 {
            xScale = -1
        }
        
        let label:SKLabelNode = SKLabelNode.init(text: "-\(NSInteger(attackNode.wdAttack))")
        label.zPosition = 1000
        label.fontColor = UIColor.red
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.fontName = "Helvetica-Bold"
        label.fontSize = 25
        label.xScale = xScale
        label.position = CGPoint(x:0,y:0)
        
        let alphaAction = SKAction.fadeAlpha(to: 0, duration: 1)
        let moveAction  = SKAction.moveTo(y: node.frame.size.height, duration: 1)
        let groupAction = SKAction.group([alphaAction,moveAction])
        node.addChild(label)
        label.run(groupAction) {
            label.removeFromParent()
        }
    }
    
    
    func setNode(node:WDBaseNode){
        
    }
    
    func clearAction(){
        self._removeLink()
        self._removeTimer()
    }
    
////////////////////////////
    
    //MARK:私有
    func _removeLink()  {
        if moveLink != nil{
            moveLink.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
            moveLink.invalidate()
            moveLink = nil
        }
    }
    
    func _removeTimer() {
        if attackTimer != nil {
            attackTimer.invalidate()
            attackTimer = nil
        }
    }
    
    
    @objc func _linkMove(){
        if (node != nil) {
            if node.wdBlood<=0{
                self._removeLink()
            }
            
            moveBlock(node)
        }
       
    }
    
    @objc func _canMove(){
        if node != nil {
            node.canMove = true
        }
    }
    
    func _removePhysics(){
        node.physicsBody?.categoryBitMask = 0;
        node.physicsBody?.contactTestBitMask = 0;
        node.physicsBody?.collisionBitMask = 0;
    }
    
}
