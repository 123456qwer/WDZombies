//
//  WDBossBehavior_1.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/11/13.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDBossBehavior_1: WDBaseNodeBehavior {

    weak var bossNode:WDBossNode_1! = nil
    
    override func stopMoveAction(direction: NSString) {
         bossNode.isMove = false
         bossNode.canMove = false
    }
    
    
    @objc func shaDowAlpha(node:WDPersonNode) -> Void {
        
        if bossNode.direction.isEqual(to: kLeft as String){
            bossNode.shadowNode.texture = SKTexture.init(image: UIImage.init(named: "boss1_attLeft")!)
        }else{
            bossNode.shadowNode.texture = SKTexture.init(image: UIImage.init(named: "boss1_attRight")!)
        }
        
        let alpha = SKAction.fadeAlpha(to: 1, duration: 0.1)
        let alpha2 = SKAction.fadeAlpha(to: 0, duration: 0.1)
        
        let seq = SKAction.sequence([alpha,alpha2])
        bossNode.shadowNode.run(seq) {
            if !node.isBlink{
                
                let distance:CGFloat = WDTool.calculateNodesDistance(point1:self.bossNode.position,point2:node.position)
                
                if distance < 140 {
                  node.personBehavior.beAattackAction(attackNode: self.bossNode, beAttackNode: node)
                }
    
           }
           
        }
    }
    
    func attack1(node:WDBaseNode) -> Void {
        
        bossNode.isAttack = true
        let attack = SKAction.animate(with: bossNode?.attackDic.object(forKey: bossNode!.direction) as! [SKTexture], timePerFrame: 0.2)
        bossNode.texture = bossNode.attackDic.object(forKey: bossNode.direction) as? SKTexture
        bossNode?.size = CGSize(width:235,height:190)
        
        self.perform(#selector(shaDowAlpha(node:)), with: node, afterDelay: 0.2)
        
        bossNode?.run(attack, completion: {
            self.bossNode?.canMove = true
            self.bossNode?.isMove = false
            self.bossNode?.size = CGSize(width:183,height:174)
            self.bossNode?.isAttack = false

        })
    }
    
    func attack3(node:WDBaseNode) -> Void {
        
        bossNode.isAttack = true
        bossNode.removeAction(forKey: "move")
        bossNode.isMove = false
        bossNode.canMove = false
    
        var name = "boss1Att2_"
        if bossNode.direction.isEqual(to: kLeft as String) {
            name = "boss1Att2_left"
        }else{
            name = "boss1Att2_right"
        }
        
        let arr = WDTool.textureArr(picName: name as NSString, index: 7)
        bossNode.texture = arr.object(at: 0) as? SKTexture
        bossNode.size = CGSize(width:525,height:200)

        let action = SKAction.animate(with: arr as! [SKTexture], timePerFrame: 0.2)
        bossNode.run(action) {
            self.attack3_aeroliteAttack(node: node)
            self.bossNode.canMove = true
            let moveArr:NSMutableArray = self.bossNode.moveDic.object(forKey: self.bossNode.direction) as! NSMutableArray
            self.bossNode.texture = moveArr.object(at: 0) as? SKTexture
            self.bossNode.size = CGSize(width:183,height:174)
            self.bossNode.isAttack = false
        }
    }
    
    func attack3_aeroliteAttack(node:WDBaseNode) -> Void {
       

        let fireNode = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "boss1_att2_star1")!))
        fireNode.position = CGPoint(x:node.position.x + 200,y:node.position.y + 200)
        
        
        let arr = WDTool.textureArr(picName: "boss1_att2_", index: 6)
        let arr1 = WDTool.textureArr(picName: "boss1_att2_star", index: 5)
        fireNode.zPosition = 20000
        node.parent?.addChild(fireNode)
        
        let fireAction = SKAction.animate(with: arr as! [SKTexture], timePerFrame: 0.1)
        let flyAction = SKAction.move(to: node.position, duration: 0.5)
        let flyAction1 = SKAction.animate(with: arr1 as! [SKTexture], timePerFrame: 0.1)
        let groupAction = SKAction.group([flyAction,flyAction1])
        
        fireNode.run(groupAction) {
            fireNode.run(fireAction, completion: {
                fireNode.removeFromParent()
            })
        }
    }
    
    override func attackAction(node: WDBaseNode) {
        
       
        if bossNode.isAttack == true {
            return
        }
        
        self.attack3(node: node);
        
        //self.attack1(node: node)

    }
    
    
     func moveActionForBoss(direction: NSString,personNode:WDPersonNode) {
       
        if bossNode.canMove{
            
            
            let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: bossNode.speed, node: bossNode!)
            bossNode.position = point
            bossNode.zPosition = 3 * 667 - bossNode.position.y;
            let bossDirection = WDTool.calculateDirectionForBoss1(bossPoint: bossNode.position, personPoint: personNode.position)
            
           if !bossDirection.isEqual(to: bossNode.direction as String) || !bossNode.isMove {
            
            bossNode.direction = bossDirection
            WDAnimationTool.boss1MoveAnimation(bossNode: bossNode)
            bossNode.isMove = true
            
            }
        }
        
    }
}
