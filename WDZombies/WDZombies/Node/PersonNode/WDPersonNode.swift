//
//  WDPersonNode.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDPersonNode: WDBaseNode {
  
    var immuneNode:SKSpriteNode = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "immuneAnimation")!))
    
    var fuzhujiNode:SKSpriteNode = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "fuzhuji_1")!))
    var personBehavior:WDPersonBehavior! = nil
    var fireNode:SKSpriteNode! = nil
    var ggAction:gameOverAction!
    var fuzhujiArr:NSMutableArray = NSMutableArray.init()
    var fly_isFire:Bool = false
    var lastRotation:CGFloat = 0
    var isImmune:Bool = false   //是否无敌状态
    var fly_fireArr:NSMutableArray = NSMutableArray.init()
    var beFlashTexture:SKTexture = SKTexture.init(image: UIImage.init(named: "person_beFlash")!)
    deinit {
        print("玩家node释放了！！！！！！！！！！！！！！！！！！！！！！！！！")
        self.removeObserver(personBehavior, forKeyPath: "position")
    }
    
    func setPhy() -> Void {
        self.physicsBody?.categoryBitMask = PLAYER_CATEGORY;
        self.physicsBody?.contactTestBitMask = PLAYER_CONTACT;
        self.physicsBody?.collisionBitMask = PLAYER_COLLISION;
    }
    
    func removePhy() -> Void {
        self.physicsBody?.categoryBitMask = 0;
        self.physicsBody?.contactTestBitMask = 0;
        self.physicsBody?.collisionBitMask = 0;
    
    }
    
    func initWithPersonDic(dic:NSMutableDictionary) -> Void {
      
        personBehavior = WDPersonBehavior.init()
        personBehavior.personNode = self
        self.addObserver(personBehavior, forKeyPath: "position", options: .new , context: nil)
        
        for index:NSInteger in 0...2 {
            let image = UIImage.init(named: "fuzhuji_\(index + 1)")
            let texture = SKTexture.init(image: image!)
            fuzhujiArr.add(texture)
        }
        
        for index:NSInteger in 0...5 {
            let image = UIImage.init(named: "fly_bullet_\(index + 1)")
            let texture = SKTexture.init(image: image!)
            fly_fireArr.add(texture)
        }
        
        moveDic = dic
        fireDic = WDTool.cutFireImage()
        boomBeginArr = WDTool.cutCustomImage(image: UIImage.init(named: "boomBegin")!, line: 1, arrange: 6, size: CGSize(width:130,height:110))
        boomBoomArr = WDTool.cutCustomImage(image: UIImage.init(named: "boomAnimation")!, line: 1, arrange: 6, size: CGSize(width:130,height:110))
        boomBoomArr.removeObject(at: 0)
        
        direction = kLeft
        self.position = CGPoint(x:kScreenWidth,y:kScreenHeight)
        self.zPosition = 10
        
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:20,height:20))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        
        physicsBody.categoryBitMask = PLAYER_CATEGORY;
        physicsBody.contactTestBitMask = PLAYER_CONTACT;
        physicsBody.collisionBitMask = PLAYER_COLLISION;
        physicsBody.isDynamic = true;
        
        
        self.physicsBody = physicsBody;
        self.zPosition = 100;
        
        self.name = PERSON as String
        
        fireNode = SKSpriteNode.init(texture: fireDic.object(forKey: direction) as? SKTexture)
        fireNode.position = WDTool.firePosition(direction:direction)
        fireNode.zPosition = 2
        fireNode.isHidden = true
        self.addChild(fireNode)
        
        

        
        let model:WDUserModel = WDUserModel.init()
        if model.searchToDB(){
            self.wdBlood = model.blood
            self.wdSpeed = model.speed
            self.wdAllBlood = model.blood
            self.wdFire_impact = Int(model.fire_impact)
            self.wdAttackDistance = Int(model.attackDistance)
            self.wdLevel = model.level
            self.wdSkillCount = model.skillCount
        }
      
        fuzhujiNode.zPosition = 10
        fuzhujiNode.xScale = 0.4
        fuzhujiNode.yScale = 0.4
        fuzhujiNode.position = CGPoint(x:self.size.width / 2.0,y:self.size.height / 2.0)
        self.addChild(fuzhujiNode)
        let ac = SKAction.animate(with: fuzhujiArr as! [SKTexture], timePerFrame: 0.15)
        let rep = SKAction.repeatForever(ac)
        fuzhujiNode.run(rep, withKey: "fushuji")
        
//        let nodea11 = SKSpriteNode.init(color: UIColor.orange, size: self.frame.size)
//        self.addChild(nodea11)
        
        immuneNode.xScale = 0.1
        immuneNode.yScale = 0.1
        immuneNode.alpha = 0.8
        immuneNode.anchorPoint = CGPoint(x:0.5,y:0.5)
        immuneNode.position = CGPoint(x:-immuneNode.frame.size.width / 2.0 - self.frame.size.width / 2.0,y:0)
        immuneNode.zPosition = 1
        
        self.addChild(immuneNode)
        
        let action_im1 = SKAction.move(to: CGPoint(x:self.frame.size.width / 2.0 + immuneNode.frame.size.width / 2.0,y:0), duration: 1)
   

        immuneNode.isHidden = true
        self.immuneA11(zPosition: -1, action: action_im1)
  
        self.setPhyColor()
        
    }
    
    
    //护盾node
    func immuneA11(zPosition:CGFloat,action:SKAction) {
      
        if self.wdBlood <= 0 {
            immuneNode.removeAllActions()
            immuneNode.removeFromParent()
            return
        }
    
        
        if zPosition > 0 {
            
            let action_im2 = SKAction.move(to: CGPoint(x:-immuneNode.frame.size.width / 2.0 - self.frame.size.width / 2.0,y:0), duration: 0.7)
        
        
            immuneNode.run(action, completion: {
                self.immuneA11(zPosition: -1, action: action_im2)
                self.immuneNode.zPosition = zPosition
            })

            
        }else{
            
            let action_im1 = SKAction.move(to: CGPoint(x:self.frame.size.width / 2.0 + immuneNode.frame.size.width / 2.0,y:0), duration: 0.7)
            immuneNode.run(action, completion: {
                self.immuneA11(zPosition: 1, action: action_im1)
                self.immuneNode.zPosition = zPosition
            })

        }
 
    }
 
    
    func setPhyColor()  {
        let phyColorNode:SKSpriteNode = SKSpriteNode.init(color: .blue, size: CGSize(width:20,height:20))
        phyColorNode.position = CGPoint(x:0,y:0)
        phyColorNode.zPosition = 0
        self.addChild(phyColorNode)
    }
    
    func createLevelUpNode()  {
        let arr:NSMutableArray = NSMutableArray.init()
        let textures = SKTextureAtlas.init(named: "Level")
        for index:NSInteger in 0...textures.textureNames.count - 1 {
            let name = "level_\(index + 1)"
            let temp = textures.textureNamed(name)
            arr.add(temp)
        }
        
        let texture:SKTexture = arr.lastObject as! SKTexture
        arr.removeLastObject()
        
        let action = SKAction.animate(with: arr as! [SKTexture], timePerFrame: TimeInterval(0.3 / CGFloat(arr.count)))
        let repeatA = SKAction.repeat(action, count: 5)
        let upNode:SKSpriteNode = SKSpriteNode.init(texture: arr.object(at: 0) as? SKTexture)
        self.addChild(upNode)
        
        upNode.zPosition = 2
        upNode.position = CGPoint(x:0,y:upNode.size.height + 30)
        upNode.run(repeatA) {
            
            let action1 = SKAction.fadeAlpha(to: 0, duration: 1.0)
            upNode.size = CGSize(width:37,height:14)
            upNode.texture = texture
            upNode.run(action1, completion: {
   
                upNode.removeFromParent()
                //self.ggAction()
            })
        }
    }
    
    
    
    
    
    
    
    
    
}
