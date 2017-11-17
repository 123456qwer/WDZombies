//
//  WDBaseNodeBehavior.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDBaseNodeBehavior: NSObject {

    func stopMoveAction(direction:NSString) -> Void {}
    func moveAction(direction:NSString) -> Void {}
    func attackAction(node:WDBaseNode) -> Void {}
    func beAattackAction(attackNode:WDBaseNode,beAttackNode:WDBaseNode) -> Void {}
    func diedAction() -> Void {}
}
