//
//  WDMoveView.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/24.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit


class WDMoveView: UIView {

    typealias moveAction = (_ direction:NSString) -> Void
    typealias stopAction = (_ direction:NSString) -> Void
    var movePoint:CGPoint!
    var starPoint:CGPoint!
    
    var bigCircle:UIImageView! = nil
    var smallCircle:UIImageView! = nil
    var _direction:NSString! = nil
    var link:CADisplayLink! = nil
    var count:NSInteger!
    var moveAction:moveAction!
    var stopAction:stopAction!
    
    var _location:CGPoint!
    
    func initWithFrame(frame:CGRect) -> Void {
        self.frame = frame
        count = 0
        _direction = ""
        
        let smallWidth:CGFloat = 50 / 1334.0 * (kScreenWidth * 2)
        let bigWidth:CGFloat = 150 / 1334.0 * (kScreenWidth * 2)
        let page:CGFloat     = 100 / 1334.0 * (kScreenWidth * 2)
        _location = CGPoint(x:page,y:kScreenHeight - page)
        
        smallCircle = UIImageView()
        smallCircle.image = UIImage(named:"smallCircle.png")
        smallCircle.frame = CGRect(x:0,y:0,width:smallWidth,height:smallWidth)
        smallCircle.alpha = 0.3
       // smallCircle.isHidden = true
        
        self.addSubview(smallCircle)
        
        
        bigCircle = UIImageView()
        bigCircle.image = UIImage(named:"bigCircle.png")
        bigCircle.frame = CGRect(x:0,y:0,width:bigWidth,height:bigWidth)
        bigCircle.alpha = 0.3
       // bigCircle.isHidden = true
        
        bigCircle.center = _location
        smallCircle.center = _location
        
        starPoint = _location
        movePoint = _location
            
        self.addSubview(bigCircle)
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        for touch:UITouch in touches {
//            let location:CGPoint = touch.location(in: self)
//            smallCircle.center = location;
//            bigCircle.center   = location;
//
//            movePoint = location;
//            starPoint = location;
//
////            smallCircle.isHidden = false;
////            bigCircle.isHidden = false;
//        }
//    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        smallCircle.isHidden = true
//        bigCircle.isHidden   = true
        
        if (link != nil){
            link.invalidate()
            link = nil
        }
   
        bigCircle.center = _location
        smallCircle.center = _location
        
        count = 0
        
        self.stopAction(_direction!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch:UITouch in touches {
            
            let location:CGPoint = touch.location(in: self)
            let BigX:CGFloat = fabs(location.x - starPoint.x);
            let BigY:CGFloat = fabs(location.y - starPoint.y);
            
            let edge:CGFloat = sqrt(BigX * BigX + BigY * BigY);
            
            let x_long:CGFloat = 50 / edge * BigX;
            let y_long:CGFloat = 50 / edge * BigY;
            
            if (edge >= 50) {
                
                if (location.x > starPoint.x) {
                    movePoint.x = starPoint.x + x_long;
                }else{
                    movePoint.x = starPoint.x - x_long;
                }
                
                if (location.y > starPoint.y) {
                    movePoint.y = starPoint.y + y_long;
                }else{
                    movePoint.y = starPoint.y - y_long;
                }
                
            }else{
                
                movePoint.x = location.x;
                movePoint.y = location.y;
            }
            
            smallCircle.center = movePoint
            
            let direction:NSString = WDTool.calculateDirection(point1: location, point2: starPoint)
            
        
            if !_direction.isEqual(to: direction as String){
                _direction = direction
            }
            
            if link == nil{
                link = CADisplayLink(target: self, selector: #selector(self.move))
                link.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
            }
            
            //print(direction)

            
        }
        
    }

    @objc func move() -> Void {
        self.moveAction(_direction!)
        //count = count + 1
        //print(count)
    }
    
    
    
    
    
    
    
    
}
