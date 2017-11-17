//
//  WDMapManager.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDMapManager: NSObject {

    var x_arr:NSMutableArray! = nil
    var y_arr:NSMutableArray! = nil
    
    static let sharedInstance = WDMapManager.init()
    private override init() {}
    
    func createX_Y(x:NSInteger,y:NSInteger) -> Void {
       
        x_arr = NSMutableArray()
        for index:NSInteger in 0...x {
            let x:CGFloat = CGFloat(index)
            if (x  < 667 / 2.0 ) {
                x_arr.add(0)
            }else if(x  > 2 * 667.0 + 667.0 / 2.0){
                x_arr.add(-667.0 * 2)
            }else{
                x_arr.add(-(x - 667.0 / 2.0))
            }
        }
        
        y_arr = NSMutableArray()
        for index:NSInteger in 0...y {
            let y:CGFloat = CGFloat(index)
            if (y  < 375 / 2.0 ) {
                y_arr.add(0)
            }else if(y  > 2 * 375 + 375 / 2.0){
                y_arr.add(-375 * 2)
            }else{
                y_arr.add(-(y  - 375 / 2.0))
            }
        }
    }
    
    
    func setMapPosition(point:CGPoint,mapNode:SKSpriteNode) -> Void {
       
        let x:NSInteger = NSInteger(point.x);
        let y:NSInteger = NSInteger(point.y);
        
        let bg_x:CGFloat = x_arr.object(at: x) as! CGFloat
        let bg_y:CGFloat = y_arr.object(at: y) as! CGFloat
       
        mapNode.position = CGPoint(x:bg_x,y:bg_y)
    }
    
    
    
}
