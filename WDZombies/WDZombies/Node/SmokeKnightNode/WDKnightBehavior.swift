//
//  WDKnightBehavior.swift
//  WDZombies
//
//  Created by wudong on 2017/12/12.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDKnightBehavior: WDBaseNodeBehavior {
   
    typealias attack2 = (_ knightNode:WDSmokeKnightNode) -> Void
    typealias attack1 = (_ knightNode:WDSmokeKnightNode) -> Void
    
    
    var blackCircleAttackBlock:attack1!
    var meteoriteAttackBlock:attack2!
    
    var attackTimeCount:NSInteger = 0

    weak var kNight:WDSmokeKnightNode!
    var blood = 0
   

    func blackCircleAttackAction(personNode:WDPersonNode){
        self.blackCircleAnimation(personNode: personNode)
    }
    
    
    func meteoriteAttackAction(personNode:WDPersonNode){
        self.meteoriteAttackAnimation(personNode: personNode)
    }
    
//*************************动画相关******************************************//
    //释放黑色漩涡
    func blackCircleAnimation(personNode:WDPersonNode) {
       
        if kNight.wdBlood <= 0 || kNight.canMove == false{
            return
        }
        
        kNight.canMove = false
        kNight.isMove  = false
        
        let action2 = SKAction.playSoundFileNamed("smoke_attack", waitForCompletion: false)
        let action1 = SKAction.animate(with: kNight.model.attack1Arr, timePerFrame: 0.2)
        let action3 = SKAction.group([action1,action2])
        self.perform(#selector(attackPerson(personNode:)), with: personNode, afterDelay: 0.2 * 3)
        
        kNight.run(action3) {
            self.kNight.canMove = true
        }
    }
    
    
    //meteorite
    func createMeteoriteAnimation(personNode:WDPersonNode,count:NSInteger){
        
        if count == 0 {
            return
        }else{
            
            if kNight == nil {
                return
            }
            let meteoriteShadowNode = SKSpriteNode.init(texture: kNight.model.meteoriteTexture)
            meteoriteShadowNode.zPosition = 2
            let y = personNode.position.y - personNode.size.width / 2.0
            meteoriteShadowNode.position = CGPoint(x:personNode.position.x,y:y)
            meteoriteShadowNode.alpha = 0.3
            personNode.parent?.addChild(meteoriteShadowNode)
            let alphaA = SKAction.fadeAlpha(to: 1, duration: 0.6)
            meteoriteShadowNode.run(alphaA, completion: {
                meteoriteShadowNode.removeFromParent()
            })
            
            
            let fireNode = WDBaseNode.init(texture: kNight.model.meteoriteArr1[0])
            fireNode.position = CGPoint(x:personNode.position.x + 200,y:personNode.position.y + 200)
            fireNode.wdAttack = 3
          
            fireNode.zPosition = 20000
            fireNode.name = KNIGHT_METEORITE_NAME
            personNode.parent?.addChild(fireNode)
            
            let fireAction = SKAction.animate(with: kNight.model.meteoriteArr2, timePerFrame: 0.1)
            let posi = CGPoint(x:personNode.position.x + personNode.size.width / 2.0,y:personNode.position.y + personNode.size.height / 2.0 + 5)
            let flyAction = SKAction.move(to: posi, duration: 0.5)
            let flyAction1 = SKAction.animate(with: kNight.model.meteoriteArr1, timePerFrame: 0.1)
            let musicAction = SKAction.playSoundFileNamed(self.kNight.model.attack2Music, waitForCompletion: false)
            let groupAction = SKAction.group([flyAction,flyAction1,musicAction])
            
            
            
            fireNode.run(groupAction) {
                
                let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:50,height:50))
                physicsBody.affectedByGravity = false;
                physicsBody.allowsRotation = false;
                
                physicsBody.contactTestBitMask = KNIGHT_METEORITE_CONTACT
                physicsBody.categoryBitMask    = 0
                physicsBody.collisionBitMask   = 0
                
                physicsBody.isDynamic = true;
           
                fireNode.physicsBody = physicsBody
                
                fireNode.run(fireAction, completion: {
                    fireNode.removeFromParent()
                })
            }
            let temp = count - 1
            let time: TimeInterval = 0.3
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                //code
                self.createMeteoriteAnimation(personNode: personNode, count: temp)
            }
        }
       
    }
    
    
    @objc func attackPerson(personNode:WDPersonNode)  {
        let distance:CGFloat = WDTool.calculateNodesDistance(point1: self.kNight.position, point2: personNode.position)
        let dis = personNode.size.width / 2.0 + self.kNight.size.width / 2.0
        print(dis,distance)
        
        if distance < dis {
            personNode.personBehavior.beAattackAction(attackNode: self.kNight, beAttackNode: personNode)
        }
    }
    
    
    //陨石攻击
    func meteoriteAttackAnimation(personNode:WDPersonNode) {
        
        if kNight.wdBlood <= 0 || kNight.canMove == false{
            return
        }
        
        kNight.canMove = false
        kNight.isMove  = false
        
        let action1 = SKAction.animate(with: kNight.model.attack2Arr, timePerFrame: 0.2)
        let musicA = SKAction.playSoundFileNamed(kNight.model.attack1Music, waitForCompletion: false)
        let group = SKAction.group([action1,musicA])
        
        let time: TimeInterval = 0.2 * 6
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            //code
            var count:NSInteger = NSInteger(arc4random() % 10)
            if count < 3 {
                count = 3
            }
            self.createMeteoriteAnimation(personNode: personNode, count: count)
        }
        
        
        kNight.run(group) {
            self.kNight.canMove = true
            
            /*
            var temp:CGFloat = 50
            if self.kNight.direction.isEqual(to: kLeft as String){
                temp = -50
            }else{
                temp = 50
            }
            
            let point = CGPoint(x:self.kNight.position.x + temp,y:self.kNight.position.y)
            let distance:CGFloat = WDTool.calculateNodesDistance(point1: point, point2: personNode.position)
            
            let action2 = SKAction.move(to: point, duration: TimeInterval(distance / 400))
            
            personNode.canMove = false
            personNode.isMove  = false
            
            self.perform(#selector(self.canMove), with: nil, afterDelay: TimeInterval(distance / 400.0))
            
            personNode.run(action2, completion: {
                personNode.canMove = true
                self.attack1Animation(personNode: personNode)
            })
            */
        }
        
    }
    
    @objc func canMove() {
        self.kNight.canMove = true
    }
    
    
    override func beAttack(attackNode: WDBaseNode, beAttackNode: WDBaseNode) -> Bool {
        let isBreak:Bool = super.beAttack(attackNode: attackNode, beAttackNode: beAttackNode)
        if isBreak   {
            self.blinkAction(personNode: attackNode as! WDPersonNode)
        }
        return isBreak
    }
    
    override func setNode(node: WDBaseNode) {
        kNight = node as! WDSmokeKnightNode
        attackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(attackTimerAction), userInfo: nil, repeats: true)
    }
    
    func blinkAction(personNode:WDPersonNode) {
        
        kNight.texture = kNight.model.moveArr[0]
        kNight.canMove = false
        kNight.alpha = 0.5
        var page:CGFloat = 80 / 2.0 + 20 / 2.0
        if kNight.position.x < personNode.position.x {
            page *= -1
        }
        
        let position = CGPoint(x:personNode.position.x + page,y:personNode.position.y)
        
        let moveA = SKAction.move(to: position, duration: 0.5)
        kNight.removePhy()
        self.perform(#selector(setPhy), with: nil, afterDelay: 0.7)
        kNight.run(moveA) {
            self.kNight.canMove = true
            self.kNight.alpha = 1
        }
    }
    
    @objc func setPhy()  {
        if kNight != nil{
            kNight.setPhy()
        }
    }
    
    @objc func attackTimerAction(){
       
        if kNight.canMove {
            attackTimeCount += 1
            
            if attackTimeCount == attackAllCount{
                attackTimeCount = 0
                self.meteoriteAttackBlock(kNight)
            }
        }
    }
    
}
