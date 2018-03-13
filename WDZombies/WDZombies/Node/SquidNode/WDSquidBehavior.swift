//
//  WDSquidBehavior.swift
//  WDZombies
//
//  Created by wudong on 2017/12/26.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDSquidBehavior: WDBaseNodeBehavior {

    typealias attack1 = (_ squidN:WDSquidNode) -> Void
    var inkAttackBlock:attack1!

    
    weak var squidNode:WDSquidNode!
    var attackTimeCount:NSInteger = 0

    
    //墨汁攻击timer计时
    @objc func inkAttack(){
        if squidNode.canMove {
            attackTimeCount += 1
            if attackTimeCount == 5{
                self.inkAttackBlock(squidNode)
                attackTimeCount = 0
            }
        }
    }
    
   
    //墨汁攻击
    func fiveInkAttack(personNode:WDPersonNode,count:NSInteger){
        if count <= 0 {
            self.squidNode.canMove = true
            return
        }else{
            let attackAction = SKAction.animate(with: squidNode.model.attack1Arr, timePerFrame: 0.2)
            let bossDirection = WDTool.calculateDirectionForBoss1(bossPoint: squidNode.position, personPoint: personNode.position)
            if bossDirection.isEqual(to: kLeft as String){
                squidNode.xScale = xScale
                squidNode.yScale = yScale
            }else{
                squidNode.xScale = -1 * xScale
                squidNode.yScale = yScale
            }
            
            squidNode.run(attackAction) {
                let c = count - 1
                self.fiveInkAttack(personNode: personNode, count: c)
                self.createInkAttack(personNode: personNode)
                
            }
        }
    }
    
    //设置墨汁物理属性
    @objc func setInkPhy(inkNode:SKSpriteNode){
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:50,height:50))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        physicsBody.contactTestBitMask = PLAYER_CATEGORY;
        physicsBody.categoryBitMask = 0
        physicsBody.collisionBitMask = 0
        inkNode.physicsBody = physicsBody
    }
    
    //创建墨汁node
    func createInkAttack(personNode:WDPersonNode){
        
        if squidNode == nil {
            return
        }
        
        let inkNode:SKSpriteNode = SKSpriteNode.init(texture: squidNode.model.inkArr[0])
        inkNode.zPosition = 3000
        inkNode.name = SQUID_INK
        var x:CGFloat = 0
        if squidNode.xScale < 0 {
            x = squidNode.position.x + squidNode.size.width / 2.0 - 10
        }else{
            x = squidNode.position.x - squidNode.size.width / 2.0 + 10
        }
        
        let position = CGPoint(x:x,y:squidNode.position.y - 20)
        inkNode.position = position
        squidNode.parent?.addChild(inkNode)
        self.setInkPhy(inkNode: inkNode)
        //角度
        let x1:CGFloat = personNode.position.x - inkNode.position.x
        let y1:CGFloat = personNode.position.y - inkNode.position.y
        
        let count:CGFloat = atan2(y1, x1)
        let count1 = CGFloat(Double.pi / 2.0)
        inkNode.zRotation = count + count1
        
        let distance = WDTool.calculateNodesDistance(point1: personNode.position, point2: inkNode.position)
        let time = distance / 330
        
        let inkAction  = SKAction.animate(with: squidNode.model.inkArr, timePerFrame: TimeInterval(time / 6.0))
        let moveAction = SKAction.move(to: personNode.position, duration: TimeInterval(time))
        let musicA = SKAction.playSoundFileNamed(self.squidNode.model.attack1Music, waitForCompletion: false)
        let groupAction = SKAction.group([inkAction,moveAction,musicA])
     
        
        inkNode.run(groupAction) {
            let alphaA = SKAction.fadeAlpha(to: 0, duration: 1)
            inkNode.run(alphaA, completion: {
                inkNode.removeFromParent()
            })
        }
        
    }
    
    //被攻击10次
    @objc func beAttackBreak(){
        self.inkAttackBlock(squidNode)
    }
    
    
    //MARK:继承方法
    override func attack(direction: NSString, nodeDic: NSDictionary) {
        let personNode = nodeDic.object(forKey: "personNode")
        
        squidNode.removeAction(forKey: "move")
        squidNode.isMove = false
        squidNode.canMove = false
        
        self.fiveInkAttack(personNode: personNode as! WDPersonNode, count: NSInteger(arc4random() % 10))
    }
    
    
    override func beAttack(attackNode: WDBaseNode, beAttackNode: WDBaseNode) -> Bool {
        
        let isBreak = super.beAttack(attackNode: attackNode, beAttackNode: beAttackNode)
        if isBreak{
            self.perform(#selector(beAttackBreak), with: nil, afterDelay: 0.5)
            attackTimeCount = 0
        }
        
        return isBreak
    }
    
  
    
    override func setNode(node: WDBaseNode) {
        squidNode = node as! WDSquidNode
        attackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(inkAttack), userInfo: nil, repeats: true)
    }
}
