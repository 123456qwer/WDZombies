//
//  WDAnimationTool.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/26.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit
class WDAnimationTool: NSObject {
    
   
    /// boss移动动画
    ///
    /// - Parameter bossNode: <#bossNode description#>
    static func boss1MoveAnimation(bossNode:WDBaseNode) -> Void {
       
        bossNode.removeAction(forKey: "move")
        let moveAction:SKAction = SKAction.animate(with: bossNode.moveDic.object(forKey: bossNode.direction) as! [SKTexture], timePerFrame: 0.2)
        let repeatAction:SKAction = SKAction.repeatForever(moveAction)
        bossNode.run(repeatAction, withKey: "move")
    }
 
    /// 角色移动动画
    ///
    /// - Parameters:
    ///   - direction: 方向
    ///   - dic: [texture]
    /// - Returns: 方法
    static func moveAnimation(direction:NSString,dic:NSMutableDictionary,node:WDBaseNode) -> Void{
        if dic.count == 0{
            return
        }
        node.removeAction(forKey: "move")
        let moveArr:NSMutableArray = NSMutableArray.init()
        for index: NSInteger in 1...2 {
            moveArr.add((dic.object(forKey: direction)!as! NSMutableArray).object(at: index))
        }
        
        let moveAction:SKAction = SKAction.animate(with: moveArr as! [SKTexture], timePerFrame: 0.2)
        let repeatAction:SKAction = SKAction.repeatForever(moveAction)
        node.run(repeatAction, withKey: "move")
    }
    
    static func initRotateDirection(direction:NSString) -> CGFloat{
        var endRotation:CGFloat = 0
        switch direction {
        case kLeft:
            endRotation = CGFloat(Double.pi)
            break
        case kRight:
            endRotation = 0
            break
        case kUp:
            endRotation = CGFloat(Double.pi / 2.0)
            break
        case kDown:
            endRotation = CGFloat(Double.pi / 2.0 + Double.pi)
            break
        case kLD:
            endRotation = CGFloat(Double.pi + Double.pi / 4.0)
            break
        case kRD:
            endRotation = CGFloat(Double.pi / 4.0 + Double.pi + Double.pi / 2.0)
            break
        case kRU:
            endRotation = CGFloat(Double.pi / 4.0)
            break
        case kLU:
            endRotation = CGFloat(Double.pi / 2.0 + Double.pi / 4.0)
            break
        default:
            break
        }
        
        return endRotation
    }
    
    static func fuzhujiRotateAnimation(direction:NSString,personNode:WDPersonNode){
        
        //俩个计算为了避免转一周
        let time:TimeInterval = 0.15
        var action:SKAction!
        let starRotation = personNode.lastRotation
        personNode.fuzhujiNode.zRotation = starRotation
        var endRotation:CGFloat = 0
        
        switch direction {
        case kLeft:
            endRotation = CGFloat(Double.pi)
            break
        case kRight:
            endRotation = 0
            break
        case kUp:
            endRotation = CGFloat(Double.pi / 2.0)
            break
        case kDown:
            endRotation = CGFloat(Double.pi / 2.0 + Double.pi)
            break
        case kLD:
            endRotation = CGFloat(Double.pi + Double.pi / 4.0)
            break
        case kRD:
            endRotation = CGFloat(Double.pi / 4.0 + Double.pi + Double.pi / 2.0)
            break
        case kRU:
            endRotation = CGFloat(Double.pi / 4.0)
            break
        case kLU:
            endRotation = CGFloat(Double.pi / 2.0 + Double.pi / 4.0)
            break
        default:
            break
        }
        
        personNode.lastRotation = endRotation
        //旋转超过180度
        if fabs(starRotation - endRotation) > CGFloat(Double.pi){
            if endRotation > starRotation{
                endRotation = -(CGFloat(Double.pi * 2) - endRotation)
            }else{
                endRotation = (CGFloat(Double.pi * 2) + endRotation)
            }
        }
        
//        print(endRotation)
//        print(direction)
        
        action = SKAction.rotate(toAngle: endRotation, duration: time)
        personNode.fuzhujiNode.run(action, withKey: "rotation")
    }
    
    static func fuzhujiMoveAnimation(direction:NSString,fuzhuji:SKSpriteNode){
        
        //俩个计算为了避免转一周
        var action:SKAction!
        switch direction {
        case kLeft:
            action = SKAction.rotate(toAngle: CGFloat(Double.pi), duration: 0.25)
            break
        case kRight:
             action = SKAction.rotate(toAngle: CGFloat(2*Double.pi), duration: 0.25)
            break
        case kUp:
             action = SKAction.rotate(toAngle: CGFloat(Double.pi / 2.0), duration: 0.25)
            break
        case kDown:
             action = SKAction.rotate(toAngle: CGFloat(Double.pi / 2.0 + Double.pi), duration: 0.25)
            break
        case kLD:
             action = SKAction.rotate(toAngle: CGFloat(Double.pi + Double.pi / 4.0), duration: 0.25)
            break
        case kRD:
             action = SKAction.rotate(toAngle: CGFloat(Double.pi / 4.0 + Double.pi + Double.pi / 2.0), duration: 0.25)
            break
        case kRU:
             action = SKAction.rotate(toAngle: CGFloat(Double.pi / 4.0), duration: 0.25)
            break
        case kLU:
             action = SKAction.rotate(toAngle: CGFloat(Double.pi / 2.0 + Double.pi / 4.0), duration: 0.25)
            break
        default:
            break
        }
        
        fuzhuji.run(action)
    }
    
    /// 人物被攻击动画
    ///
    /// - Parameters:
    ///   - attackNode:
    ///   - beAttackNode:
    static func beAttackAnimationForPerson(attackNode: WDBaseNode, beAttackNode: WDPersonNode) -> Void {
        let direction:NSString = WDTool.oppositeDirection(direction: attackNode.direction)
        beAttackNode.direction = direction
        let impact:NSInteger = attackNode.wdFire_impact
        let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: CGFloat(-impact), node: beAttackNode)
        
        let moveAction:SKAction = SKAction.move(to: point, duration: 0.2)
        beAttackNode.run(moveAction)
        beAttackNode.zPosition = 3 * 667 - beAttackNode.position.y;
        beAttackNode.texture = (beAttackNode.moveDic.object(forKey: direction) as! NSMutableArray).object(at: 0) as? SKTexture
    }
    
    
    /// 僵尸被攻击动画
    ///
    /// - Parameters:
    ///   - attackNode:
    ///   - beAttackNode: 
    static func beAttackAnimationForZom(attackNode: WDPersonNode, beAttackNode: WDZombieNode) -> Void {
        
        beAttackNode.canMove = false
        beAttackNode.isMove  = false
        beAttackNode.removeAction(forKey: "move")
        
        let impact:NSInteger = NSInteger(arc4random()) % NSInteger(attackNode.wdFire_impact)
        let direction:NSString = WDTool.oppositeDirection(direction: beAttackNode.direction)
        let point:CGPoint = WDTool.calculateMovePoint(direction: direction, speed: CGFloat(impact), node: beAttackNode)
        let moveAction:SKAction = SKAction.move(to: point, duration: 0.2)
        beAttackNode.run(moveAction) {
            beAttackNode.canMove = true
        }
        beAttackNode.zPosition = 3 * 667 - beAttackNode.position.y
        
    }
    
  
    
    
    /// 出血动画
    ///
    /// - Parameter node:
    static func bloodAnimation(node:SKSpriteNode) -> Void {
       
        
        let blood:NSInteger = NSInteger(arc4random() % 8) + 1;
        let bloodName:NSString = "blood\(blood)" as NSString
        let image:UIImage = UIImage.init(named: bloodName as String)!
        let texture:SKTexture = SKTexture.init(image: image)
        let bloodNode:SKSpriteNode = SKSpriteNode.init(texture: texture)
        bloodNode.zPosition = 1
        bloodNode.position = node.position
        bloodNode.xScale = 0.4
        bloodNode.yScale = 0.4
        node.parent?.addChild(bloodNode)
        
        let alphaAction:SKAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let removeAction:SKAction = SKAction.removeFromParent()
        let seq = SKAction.sequence([alphaAction,removeAction])
        bloodNode.run(seq)
 
    }
    
    static func autoFireAnimation(node:WDPersonNode,zomNode:WDBaseNode) -> Void {
        
        let texture:SKTexture = node.fly_fireArr[0] as! SKTexture
        let firNode:SKSpriteNode = SKSpriteNode.init(texture: texture)

        
        let fireX:CGFloat = node.position.x + node.fuzhujiNode.position.x
        let fireY:CGFloat = node.position.y + node.fuzhujiNode.position.y
        
        let distance:CGFloat = WDTool.calculateNodesDistance(point1: zomNode.position, point2: node.position)
        let p :CGPoint = zomNode.position
 
        
        firNode.position = CGPoint(x:fireX,y:fireY)
        firNode.zPosition = 2.0;
        firNode.name = FIRE as String
        firNode.xScale = 0.3
        firNode.yScale = 0.3
        node.parent?.addChild(firNode)
        let action:SKAction = SKAction.move(to: p, duration: TimeInterval(distance / 300.0))
        let firA = SKAction.animate(with: node.fly_fireArr as! [SKTexture], timePerFrame: TimeInterval(distance / 300.0 / 6.0))
        let groupA = SKAction.group([action,firA])
        let removeAction = SKAction.removeFromParent()
        let seq = SKAction.sequence([groupA,removeAction])
        firNode.run(seq)
        
        let body:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:20,height:29))
        
        body.affectedByGravity = false;
        body.allowsRotation = false;
        
        body.isDynamic = false;
        body.contactTestBitMask = NORMAL_ZOM_CATEGORY;
        body.categoryBitMask = 0
        body.collisionBitMask = 0
        firNode.physicsBody = body
        
        if node.wdAttack == 3 {
            let emitter:SKEmitterNode = WDAnimationTool.createEmitterNode(name:"Spark")
            emitter.name = "addAttack"
            emitter.position = CGPoint(x:0,y:0)
            firNode.addChild(emitter)
        }
        
    }
    
    /// 玩家攻击动画
    ///
    /// - Parameter node:
    static func fireAnimation(node:WDPersonNode,zomNode:WDBaseNode) -> Void {
        
        let texture:SKTexture = SKTexture.init(image: UIImage.init(named: "smallCircle")!)
        let firNode:SKSpriteNode = SKSpriteNode.init(texture: texture)

        let p:CGPoint = WDTool.fireMovePoint(personNode: node)
        let x:CGFloat = fabs(node.position.x - p.x);
        let y:CGFloat = fabs(node.position.y - p.y);
        let distance:CGFloat = sqrt(fabs(x * x)+fabs(y * y));
//        let distance:CGFloat = WDTool.calculateNodesDistance(point1: zomNode.position, point2: node.position)
//        let p :CGPoint = zomNode.position
        firNode.position = node.position
        firNode.zPosition = 2.0;
        firNode.name = FIRE as String
        firNode.xScale = 0.1
        firNode.yScale = 0.1
        node.parent?.addChild(firNode)
        let action:SKAction = SKAction.move(to: p, duration: TimeInterval(distance / 700.0))
        let removeA = SKAction.removeFromParent()
        let seq = SKAction.sequence([action,removeA])
        firNode.run(seq)
        
        let body:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:20,height:29))
        
        body.affectedByGravity = false;
        body.allowsRotation = false;
        
        body.isDynamic = false;
        body.contactTestBitMask = NORMAL_ZOM_CATEGORY;
        body.categoryBitMask = 0
        body.collisionBitMask = 0
        firNode.physicsBody = body
        
        if node.wdAttack == 3 {
            let emitter:SKEmitterNode = WDAnimationTool.createEmitterNode(name:"Spark")
            emitter.name = "addAttack"
            emitter.position = CGPoint(x:0,y:0)
            firNode.addChild(emitter)
        }
        
    }
    
    
    /// 僵尸攻击动画
    ///
    /// - Parameters:
    ///   - zombieNode:
    ///   - personNode:
    static func zomAttackAnimation(zombieNode:WDZombieNode,personNode:WDPersonNode) ->Void{
    
        
        let animationArr:NSMutableArray = zombieNode.attackDic.object(forKey: zombieNode.direction) as! NSMutableArray
        let attackAction:SKAction = SKAction.animate(with: animationArr as! [SKTexture], timePerFrame: 0.2)
        let musicA = SKAction.playSoundFileNamed(zombieNode.behavior.musicPlayer.normalZomAttack, waitForCompletion: false)
        let group = SKAction.group([musicA,attackAction])
        
        zombieNode.run(group) {
            let distance:CGFloat = WDTool.calculateNodesDistance(point1:zombieNode.position,point2:personNode.position)
            var page:CGFloat = 30
            if zombieNode.isBoss {
                page = 50
            }
            
            if distance < page{
                zombieNode.behavior.attackAction(node: personNode)
                //闪现中不被攻击
                if personNode.isBlink == false{
                    //重新调用攻击方法(避免触碰后不在触发攻击的状态)
                    personNode.personBehavior.beAattackAction(attackNode: zombieNode, beAttackNode: personNode)
                }
                
            }else{
                zombieNode.canMove = true
            }
        }
    }
    
    /// 魔法攻击动画
    ///
    /// - Parameters:
    ///   - zom: <#zom description#>
    ///   - person: <#person description#>
    static func magicAnimation(zom:WDZombieNode,person:WDPersonNode) ->Void {
       
        if zom.wdBlood <= 0 {
            return
        }
        
       
        
        zom.canMove = false
        zom.isMove  = false
        let alphaA = SKAction.fadeAlpha(to: 0, duration: 0.3)
       
       
        zom.removeAction(forKey: "move")
        zom.removePhy()
        zom.run(alphaA) {
            let speed:CGFloat = 250 / 0.5
            let magic:SKEmitterNode = WDAnimationTool.createEmitterNode(name:"Magic")
            magic.position = zom.position
            zom.parent?.addChild(magic)

            let circle = UIBezierPath.init(roundedRect: CGRect(x:-25,y:-25,width:50,height:50), cornerRadius: 25)
            let action = SKAction.follow(circle.cgPath, asOffset: true, orientToPath: false, duration: 0.3)
            let action3 = SKAction.move(to: zom.position, duration: 0)
            let seq = SKAction.sequence([action,action3])
            let rep = SKAction.repeat(seq, count: 10)
            
            magic.targetNode = zom.parent
            magic.zPosition = 1000
            magic.run(rep, completion: {
                
                //避免碰撞过后距离近，不在攻击
                let distance1:CGFloat = WDTool.calculateNodesDistance(point1:zom.position,point2:person.position)
                if distance1 < 30{
                    if person.wdBlood > 0{
                        zom.behavior.attackAction(node: person)
                    }
                }
                
                let distance = WDTool.calculateNodesDistance(point1: magic.position, point2: person.position)
                let dura = distance / speed
                let move = SKAction.move(to: person.position, duration: TimeInterval(dura))
                
                let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:20,height:20))
                physicsBody.affectedByGravity = false;
                physicsBody.allowsRotation = false;
                
                physicsBody.categoryBitMask = 0x01;
                physicsBody.contactTestBitMask = 0x01;
                physicsBody.collisionBitMask = 0;
                physicsBody.isDynamic = true;
                
                magic.physicsBody = physicsBody
                magic.name = "magic"
                magic.run(move, completion: {
                
                    zom.position = magic.position
                    zom.setPhy()

                    magic.removeFromParent()
                    
                    let alphaAction = SKAction.fadeAlpha(to: 1, duration: 0.3)
                    zom.run(alphaAction, completion: {
                          zom.canMove = true
                          zom.redZomAttackCount = 0
                    })
                })
            })
        }
        
       
    }
    
    
    
    /// 炸弹动画
    ///
    /// - Parameter node: <#node description#>
    static func boomAnimation(node:WDPersonNode) -> Void{
        
        let beginBoom:NSMutableArray = WDMapManager.sharedInstance.textureDic.object(forKey: PERSON_BOOM1) as! NSMutableArray
        let boomBoom:NSMutableArray = WDMapManager.sharedInstance.textureDic.object(forKey: PERSON_BOOM2) as! NSMutableArray
        
        let boomNode:SKSpriteNode = SKSpriteNode.init(texture: beginBoom.object(at: 0) as? SKTexture)
        boomNode.position = node.position;
        boomNode.zPosition = 100;
        boomNode.xScale = 0.8;
        boomNode.yScale = 0.8;
        boomNode.name = BOOM as String;
        node.parent?.addChild(boomNode)
        
        let boomBeginAn:SKAction = SKAction.animate(with: beginBoom as! [SKTexture], timePerFrame: 1.5 / 6.0)
        boomNode.run(boomBeginAn) {
            let boomBomAn:SKAction = SKAction.animate(with: boomBoom as! [SKTexture], timePerFrame: 0.5 / 5.0)
            let body:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: boomNode.size)
            
            body.affectedByGravity = false;
            body.allowsRotation = false;
            
            body.isDynamic = false;
            body.categoryBitMask = player_type;
            body.contactTestBitMask = normal_zom;
            body.collisionBitMask = player_type ;
            boomNode.physicsBody = body;
            let removeA = SKAction.removeFromParent()
            let seq = SKAction.sequence([boomBomAn,removeA])
            boomNode.run(seq)
        }
        
    }
    
    
    
    
    
   /// 闪现动画
   ///
   /// - Parameter node: <#node description#>
    static func blinkAnimation(node:WDPersonNode,model:WDSkillModel) -> Void {
    
    node.removeAction(forKey: "move")
    node.canMove = false
    node.isMove  = false
    

    let point:CGPoint = WDTool.calculateMovePoint(direction: node.direction, speed: CGFloat(model.skillLevel2), node: node)
    
    let hide:SKAction = SKAction.fadeAlpha(to: 0, duration: 0.1)
    let moveAction:SKAction = SKAction.move(to: point, duration: 0.3)
    let appear:SKAction = SKAction.fadeAlpha(to: 1, duration: 0.1)
    
    let seq:SKAction = SKAction.sequence([hide,moveAction,appear])

    let dic = ["point1":point,"point2":node.position,"node":node] as [String : Any]
    self.perform(#selector(flashAction(dic:)), with: dic, afterDelay: 0.1)
   
    
    node.physicsBody?.contactTestBitMask = 0
    node.physicsBody?.categoryBitMask = 0
    node.physicsBody?.collisionBitMask = 0;
    node.isBlink = true
    node.run(seq) {
        node.isBlink = false
        node.canMove = true
        node.setPhy()
    }
    
    
    }
    
    
    
    static func createEmitterNode(name:NSString) -> SKEmitterNode{
        let str:NSString = Bundle.main.path(forResource: name as String, ofType: "sks")! as NSString
        let emitter:SKEmitterNode = (NSKeyedUnarchiver.unarchiveObject(withFile: str as String) as? SKEmitterNode)!
        return emitter

    }
    
   static func zomDiedAnimation(node:WDBaseNode) -> Void {
    
        node.removeAllActions()
        
        node.canMove = false
        node.physicsBody = nil
        node.zPosition = 1
        let diedAction = SKAction.animate(with: node.diedArr as! [SKTexture], timePerFrame: 0.2)
        node.run(diedAction) {
            node.removeFromParent()
        }
    }
    
    @objc static func flashAction(dic:NSDictionary) -> Void {
       
        let point1:CGPoint = dic.object(forKey: "point1") as! CGPoint
        let point2:CGPoint = dic.object(forKey: "point2") as! CGPoint
        let node:WDPersonNode = dic.object(forKey: "node") as! WDPersonNode
        WDAnimationTool.drawLightning(x1: point1.x, y1: point1.y, x2: point2.x, y2: point2.y, displace: 50, personNode: node)
        
    }
    
    static func drawLightning(x1:CGFloat,y1:CGFloat,x2:CGFloat,y2:CGFloat,displace:CGFloat,personNode:WDPersonNode)
    {
      
        if (displace < 1) {
       
        } else {
            
            var mid_x = (x2+x1)/2;
            var mid_y = (y2+y1)/2;
            
            let randomValue:CGFloat = CGFloat(arc4random() / UInt32(RAND_MAX)) - 0.5
            mid_x += randomValue * displace;
            if personNode.direction.isEqual(to: kRU as String) || personNode.direction.isEqual(to: kLD as String){
                mid_y -= randomValue * displace;
            }else{
                mid_y += randomValue * displace;
            }
            
            WDAnimationTool.drawLightning(x1: x1, y1: y1, x2: mid_x, y2: mid_y, displace: displace / 2.0, personNode: personNode)
            WDAnimationTool.drawLightning(x1: x2, y1: y2, x2: mid_x, y2: mid_y, displace: displace / 2.0 ,personNode: personNode)
       
            let alpha = SKAction.fadeAlpha(to: 0, duration: 0.4)
            
            let linePoint = CGPoint(x:mid_x,y:mid_y)
            
            
            let node1 = SKSpriteNode.init()
            node1.size = CGSize(width:15,height:15)
            node1.position = linePoint
            node1.zPosition = 2
            node1.color = UIColor.white
            node1.alpha = 0.2
            personNode.parent?.addChild(node1)
            
            let node = SKSpriteNode.init()
            node.size = CGSize(width:5,height:5)
            node.position = linePoint
            node.zPosition = 2
            node.color = UIColor.white
            personNode.parent?.addChild(node)
            
            node1.run(alpha, completion: {
                node1.removeFromParent()
            })
            node.run(alpha, completion: {
                node.removeFromParent()
            })
            
            //print(mid_x,mid_y,randomValue)
        }
    }
    
    
 
    
}
