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
    weak var kNight:WDSmokeKnightNode!
    var blood = 0
    
    func moveActionForKnight(direction:NSString,personNode:WDPersonNode)  {
        
        if kNight.canMove == true {
            
            let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: kNight.speed, node: kNight)
            kNight.position = point
            kNight.zPosition = 3 * 667 - kNight.position.y;
            let bossDirection = WDTool.calculateDirectionForBoss1(bossPoint: kNight.position, personPoint: personNode.position)
            
            if !bossDirection.isEqual(to: kNight.direction as String) || !kNight.isMove {
                
                kNight.removeAction(forKey: "move")
                
                let moveAction = SKAction.animate(with: kNight.model.moveArr, timePerFrame: 0.2)
                let repeatAction = SKAction.repeatForever(moveAction)
                if bossDirection.isEqual(to: kLeft as String){
                    kNight.xScale = xScale
                    kNight.yScale = yScale
                }else{
                    kNight.xScale = -1 * xScale
                    kNight.yScale = yScale
                }
                
                kNight.run(repeatAction, withKey: "move")
                kNight.direction = bossDirection
                kNight.isMove = true
                
            }
        }
    }
    
    
    func attack1Action(personNode:WDPersonNode){
        self.attack1Animation(personNode: personNode)
    }
    
    func attack2Action(personNode:WDPersonNode){
        self.attack2Animation(personNode: personNode)
    }
    
    override func beAattackAction(attackNode: WDBaseNode, beAttackNode: WDBaseNode) {
        kNight.wdBlood -= attackNode.wdAttack
        blood += NSInteger(attackNode.wdAttack)
        
        self.reduceBloodLabel(node: kNight, attackNode: attackNode)
        
        if kNight.wdBlood <= 0 {
            self.diedAction()
            kNight.diedAction(kNight)
            kNight.setPhysicsBody(isSet: false)
            return
        }
        
        if blood >= 10 && kNight.canMove == true{
            
            kNight.removeAllActions()
            kNight.canMove = false
            kNight.isMove = false
            kNight.setPhysicsBody(isSet: false)
            blood = 0
            kNight.texture = kNight.model.beAttackTexture
            self.perform(#selector(moveTexture), with: nil, afterDelay: 0.5)
            var page:CGFloat = 40 / 2.0 + 20 / 2.0
            if kNight.position.x < attackNode.position.x {
                page *= -1
            }
            let position = CGPoint(x:attackNode.position.x + page,y:attackNode.position.y)

            let action1 = SKAction.fadeAlpha(to: 0, duration: 0.5)
            let action2 = SKAction.move(to: position, duration: 0.5)
            let action3 = SKAction.fadeAlpha(to: 1, duration: 0.3)
            
            let seq = SKAction.sequence([action1,action2,action3])
            kNight.run(seq, completion: {
                
                self.kNight.canMove = true
                self.kNight.setPhysicsBody(isSet: true)
            })
            
        }
    }
    
    @objc func moveTexture() {
        kNight.texture = kNight.model.moveArr[0]
    }
    
//*************************动画相关******************************************//
    //释放黑色漩涡
    func attack1Animation(personNode:WDPersonNode) {
       
        if kNight.wdBlood <= 0 || kNight.canMove == false{
            return
        }
        
        kNight.canMove = false
        kNight.isMove  = false
        

        let action1 = SKAction.animate(with: kNight.model.attack1Arr, timePerFrame: 0.2)
        self.perform(#selector(attackPerson(personNode:)), with: personNode, afterDelay: 0.2 * 3)
        
        kNight.run(action1) {
            self.kNight.canMove = true
        }
    }
    
    //meteorite
    func createMeteoriteAnimation(personNode:WDPersonNode,count:NSInteger){
        
        if count == 0 {
            return
        }else{
            
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
            
            
            let fireNode = WDBaseNode.init(texture: SKTexture.init(image: UIImage.init(named: "boss1_att2_star1")!))
            fireNode.position = CGPoint(x:personNode.position.x + 200,y:personNode.position.y + 200)
            fireNode.wdAttack = 3
          
            fireNode.zPosition = 20000
            fireNode.name = KNIGHT_METEORITE_NAME
            personNode.parent?.addChild(fireNode)
            
            let fireAction = SKAction.animate(with: kNight.model.meteoriteArr1, timePerFrame: 0.1)
            let posi = CGPoint(x:personNode.position.x + personNode.size.width / 2.0,y:personNode.position.y + personNode.size.height / 2.0 + 5)
            let flyAction = SKAction.move(to: posi, duration: 0.5)
            let flyAction1 = SKAction.animate(with: kNight.model.meteoriteArr2, timePerFrame: 0.1)
            let groupAction = SKAction.group([flyAction,flyAction1])
            
            
            
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
    
    //吸引玩家到当前位置，攻击2
    func attack2Animation(personNode:WDPersonNode) {
        
        if kNight.wdBlood <= 0 || kNight.canMove == false{
            return
        }
        
        kNight.canMove = false
        kNight.isMove  = false
        
        let action1 = SKAction.animate(with: kNight.model.attack2Arr, timePerFrame: 0.2)
        
        let time: TimeInterval = 0.2 * 6
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            //code
            var count:NSInteger = NSInteger(arc4random() % 10)
            if count < 3 {
                count = 3
            }
            self.createMeteoriteAnimation(personNode: personNode, count: count)
        }
        
        kNight.run(action1) {
            
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
    
    override func diedAction() {
        
        kNight.removeAllActions()
        
        let diedAction = SKAction.animate(with: kNight.model.diedArr, timePerFrame: 0.2)
        kNight.run(diedAction) {
            self.kNight.removeFromParent()
        }
        
    }
    
}
