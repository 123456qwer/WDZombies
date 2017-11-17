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
  
    var personBehavior:WDPersonBehavior! = nil
    var fireNode:SKSpriteNode! = nil
    var bloodNode:SKSpriteNode! = nil
    var ggAction:gameOverAction!
    
    deinit {
        self.removeObserver(personBehavior, forKeyPath: "position")
    }
    
    
    
    func initWithPersonDic(dic:NSMutableDictionary) -> Void {
      
        personBehavior = WDPersonBehavior.init()
        personBehavior.personNode = self
        self.addObserver(personBehavior, forKeyPath: "position", options: .new , context: nil)
        
        moveDic = dic
        fireDic = WDTool.cutFireImage()
        boomBeginArr = WDTool.cutCustomImage(image: UIImage.init(named: "boomBegin")!, line: 1, arrange: 6, size: CGSize(width:130,height:110))
        boomBoomArr = WDTool.cutCustomImage(image: UIImage.init(named: "boomAnimation")!, line: 1, arrange: 6, size: CGSize(width:130,height:110))
        boomBoomArr.removeObject(at: 0)
        
        direction = kLeft
        self.position = CGPoint(x:0,y:0)
        self.zPosition = 10
        
        let physicsBody:SKPhysicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:20,height:20))
        physicsBody.affectedByGravity = false;
        physicsBody.allowsRotation = false;
        
        physicsBody.categoryBitMask = player_type;
        physicsBody.contactTestBitMask = normal_zom;
        physicsBody.collisionBitMask = player_type;
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
    }
    
    
}
