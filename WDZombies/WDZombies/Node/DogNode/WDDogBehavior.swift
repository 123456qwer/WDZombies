//
//  WDDogBehavior.swift
//  WDZombies
//
//  Created by 吴冬 on 2018/1/21.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDDogBehavior: WDBaseNodeBehavior {
  
    typealias fireAttack = (_ dogNode:WDDogNode) -> Void
    weak var dogNode:WDDogNode!
    var fireTimes = 0
    var _fireNode:SKSpriteNode!
    var fireEmitter:SKEmitterNode!
    var link:CADisplayLink!
    var fireAttackBlock:fireAttack!
    
    
    
    /// 火球攻击
    @objc func fireAttackTimeAction(){
        if dogNode.canMove {
            fireTimes += 1
            if fireTimes == 5{
                fireAttackBlock(dogNode)
                fireTimes = 0
            }
        }
    }
    
    
    @objc func fireNodeMove() {
        if dogNode != nil {
            fireEmitter.position = self.firePosition(fireNode: _fireNode)
            fireEmitter.targetNode = dogNode.parent!
        }
        
    }
    
    func firePosition(fireNode:SKSpriteNode) -> CGPoint {
        var x:CGFloat = 0
        let y:CGFloat = -12
        if fireNode.xScale > 0 {
            x = -20
        }else{
            x = 20
        }
        
        return CGPoint(x:fireNode.position.x + x,y:fireNode.position.y + y)
    }
    
    /// 火球攻击逻辑
    @objc func createFireNode(personNode:WDPersonNode){
        if dogNode == nil {
            return
        }
        let fireNode = SKSpriteNode.init(texture: dogNode.model.fireArr[0])
        var position = CGPoint(x:0,y:0)
        fireNode.name = DOG_FIRE
        var x:CGFloat = 0
        var arc:CGFloat = 0
      
        if dogNode.xScale > 0 {
            position = CGPoint(x:dogNode.position.x - dogNode.size.width / 2.0,y:dogNode.position.y)
            fireNode.xScale = 1
            x = -500
            arc = 0
            
        }else{
            position = CGPoint(x:dogNode.position.x + dogNode.size.width / 2.0,y:dogNode.position.y)
            fireNode.xScale = -1
            x = 500
            arc = CGFloat(Double.pi)

        }
        fireNode.position = position
        fireNode.zPosition = 3000
        personNode.parent?.addChild(fireNode)
        
        
        let arr:NSMutableArray = NSMutableArray.init()
        arr.add(dogNode.model.fireArr[0])
        arr.add(dogNode.model.fireArr[1])

   
        let time = 500 / 400.0
        
  
        let fireAction = SKAction.animate(with: arr as! [SKTexture], timePerFrame: 0.1)
        let moveA = SKAction.move(to: CGPoint(x:dogNode.position.x + x,y:dogNode.position.y), duration: TimeInterval(time))
        let rep = SKAction.repeat(fireAction, count: Int(time / (0.1 * 2)))
        let grou = SKAction.group([rep,moveA])
        
        let physicsBody:SKPhysicsBody = self.setPhysicsBody(size: CGSize(width:40,height:40))
        fireNode.physicsBody = physicsBody
        
        
        self.clearLinkAndFire()
        
        let emitter:SKEmitterNode = WDAnimationTool.createEmitterNode(name:"Fire")
        emitter.position = self.firePosition(fireNode: fireNode)
        personNode.parent?.addChild(emitter)
        emitter.emissionAngle = arc
        emitter.name = "flyFire"
        
        
        fireEmitter = emitter
        _fireNode = fireNode

      
        let dis = CADisplayLink.init(target: self, selector: #selector(fireNodeMove))
        dis.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        link = dis
        
        fireNode.run(grou) {
            
            self.clearLinkAndFire()
            
            if self.dogNode == nil{
                return
            }
            
            let physicsBody:SKPhysicsBody = self.setPhysicsBody(size: CGSize(width:110,height:110))
            fireNode.physicsBody = physicsBody
            
            let arr:NSMutableArray = NSMutableArray.init()
            arr.add(self.dogNode.model.fireArr[2])
            arr.add(self.dogNode.model.fireArr[3])
            arr.add(self.dogNode.model.fireArr[4])

            let boomAction = SKAction.animate(with: arr as! [SKTexture], timePerFrame: 0.1)
            fireNode.run(boomAction, completion: {
                fireNode.removeFromParent()
                let physicsBody = self.setPhysicsBody(size: CGSize(width:30,height:30))
                let emitter:SKEmitterNode = WDAnimationTool.createEmitterNode(name:"DogFire")
                emitter.name = DOG_STAY_FIRE
                emitter.particleSpeed = CGFloat(arc4random() % 300)
                emitter.position = fireNode.position
                emitter.physicsBody = physicsBody
                personNode.parent?.addChild(emitter)
            })
        }
    }
    
    func setPhysicsBody(size:CGSize) -> SKPhysicsBody {
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: size)
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        physicsBody.contactTestBitMask = PLAYER_CATEGORY;
        physicsBody.categoryBitMask = 0
        physicsBody.collisionBitMask = 0
        
        return physicsBody
    }
    
    func clearLinkAndFire()  {
        if (link != nil) {
            link.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
            link.invalidate()
            link = nil
        }
        
        if fireEmitter != nil{
            fireEmitter.removeAllActions()
            fireEmitter.removeFromParent()
            fireEmitter = nil
        }
    }
    
    
    
    
    //MARK:复写
    override func setNode(node: WDBaseNode) {
        dogNode = node as! WDDogNode
        attackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireAttackTimeAction), userInfo: nil, repeats: true)
    
    }
    
    override func attack(direction: NSString, nodeDic: NSDictionary) {
        if dogNode.canMove{
            
            dogNode.removeAction(forKey: "move")
            dogNode.canMove = false
            dogNode.isMove  = false
            let attack = SKAction.animate(with: dogNode.model.attack1Arr, timePerFrame: 0.1)
            let personNode:WDPersonNode = nodeDic.object(forKey: "personNode") as! WDPersonNode
            
            self.perform(#selector(createFireNode(personNode:)), with: personNode, afterDelay: 0.1 * 9)
            
            let musicA = SKAction.playSoundFileNamed(self.dogNode.model.attack1Music, waitForCompletion: false)
            let gr = SKAction.group([attack,musicA])
            dogNode.run(gr, completion: {
                self.dogNode.canMove = true
            })
            
        }
    }
    
    override func beAttack(attackNode: WDBaseNode, beAttackNode: WDBaseNode) -> Bool {
        let isBreak = super.beAttack(attackNode: attackNode, beAttackNode: beAttackNode)
        if isBreak {
            self.perform(#selector(canMove), with: nil, afterDelay: 0.5)
        }
        
        return isBreak
    }
    
    @objc func canMove() {
        if dogNode != nil {
            dogNode.canMove = true
        }
    }
    
    override func clearAction() {
        super.clearAction()
        self.clearLinkAndFire()
    }
    
   
}
