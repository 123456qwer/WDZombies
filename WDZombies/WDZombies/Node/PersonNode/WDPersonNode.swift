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
  
    var fuzhujiNode:SKSpriteNode = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "fuzhuji_1")!))
    var personBehavior:WDPersonBehavior! = nil
    var fireNode:SKSpriteNode! = nil
    var bloodNode:SKSpriteNode! = nil
    var ggAction:gameOverAction!
    var fuzhujiArr:NSMutableArray = NSMutableArray.init()
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
        
        
        bloodNode = SKSpriteNode.init()
        bloodNode.size = CGSize(width:self.size.width,height:5)
        bloodNode.position = CGPoint(x:-self.size.width / 2.0,y:self.size.height / 2.0 + 5)
        bloodNode.alpha = 0.8
        bloodNode.anchorPoint = CGPoint(x:0,y:0)
        bloodNode.color = UIColor.init(red: 0, green: 165 / 255.0, blue: 129 / 255.0, alpha: 1)
        bloodNode.zPosition = 3
        self.addChild(bloodNode)
        
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
    }
    
 
    
    func setPhyColor()  {
        let phyColorNode:SKSpriteNode = SKSpriteNode.init(color: .blue, size: CGSize(width:20,height:20))
        phyColorNode.position = CGPoint(x:0,y:0)
        phyColorNode.zPosition = 10
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
