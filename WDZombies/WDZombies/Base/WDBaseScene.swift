//
//  WDBaseScene.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDBaseScene: SKScene {

    var isCreateScene:Bool! = false
    var personNode:WDPersonNode! = nil
    var bgNode:SKSpriteNode! = nil
    var ggAction:gameOverAction!
    var nextAction:gameNextAction!

    override func didMove(to view: SKView) {
        
    }
    
    func moveAction(direction:NSString) -> Void {
    }
    
    func stopMoveAction(direction:NSString) -> Void {
    }
    
    func fireAction(direction:NSString) -> Void {
    }
    
    func skillAction(skillType:personSkillType) -> Void {
    }
    
    func createZombies(timer:Timer) -> Void {
    }
    
    func gameOver() {
        
    }
}
