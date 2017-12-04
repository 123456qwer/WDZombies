//
//  WDTool.swift
//  WDZombies
//
//  Created by 吴冬 on 2017/10/20.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

enum  personSkillType{
    
   case NoSelect,SPEED,Attack,Attack_distance,BLINK,BOOM,Fire
};

enum  zomType{
    
    case Normal,Red
};

typealias selectSkill = (_ Bool:Bool, _ skillType:personSkillType, _ skillCount:NSInteger) -> Void
typealias tapAction = (_ view:WDSkillView) -> Void
typealias gameOverAction = () -> Void

//适配
public let kScreenWidth = UIScreen.main.bounds.size.width
public let kScreenHeight = UIScreen.main.bounds.size.height

public let bigBtn = 150 / 750.0 * kScreenWidth
public let smallBtn = 60 / 750.0 * kScreenWidth
public let selectBtn = 60 / 568.0 * kScreenWidth
public let page1 = 20 / 750.0 * kScreenWidth
public let skillImageWidth = 45 / 750.0 * kScreenWidth
public let x_Scale = kScreenWidth / 667.0
public let y_Scale = kScreenHeight / 375.0

//方向
public let kLeft:NSString  = String("kLeft") as NSString
public let kRight:NSString = String("kRight") as NSString
public let kUp:NSString    = String("kUp") as NSString
public let kDown:NSString  = String("kDown") as NSString

public let kLU:NSString = String("kLU") as NSString
public let kLD:NSString = String("kLD") as NSString
public let kRU:NSString = String("kRU") as NSString
public let kRD:NSString = String("kRD") as NSString


public let CHANGE_SKILLVIEW_FRAME_NOTIFICATION = "CHANGE_SKILLVIEW_FRAME_NOTIFICATION"

class WDTool: NSObject {
    static func kScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static func left(View:UIView) -> CGFloat {
        return View.frame.origin.x
    }
    
    static func right(View:UIView) -> CGFloat {
        return View.frame.origin.x + View.frame.size.width
    }
    
    static func top(View:UIView) -> CGFloat {
        return View.frame.origin.y;
    }
    
    static func bottom(View:UIView) -> CGFloat {
        return View.frame.origin.y + View.frame.size.height
    }
    
    static func height(View:UIView) ->CGFloat {
        return View.frame.size.height
    }
    
    
    /// 切割成圆形
    ///
    /// - Parameter View: <#View description#>
    static func masksToCircle(View:UIView) {
        View.layer.masksToBounds = true
        View.layer.cornerRadius = View.frame.size.width / 2.0
    }
    
    
    /// 切割想要的圆角
    ///
    /// - Parameters:
    ///   - View:
    ///   - cornerRadius: 
    static func masksToSize(View:UIView,cornerRadius:CGFloat){
        View.layer.masksToBounds = true
        View.layer.cornerRadius = cornerRadius
    }
    
    /// 人物移动时增加速度特效也移动
    ///
    /// - Parameters:
    ///   - direction: 
    ///   - personNode:
    static func addSpeedSkillMove(direction:NSString,personNode:WDPersonNode) -> Void{
        
        let fireNode = personNode.parent?.childNode(withName: "addSpeed")
        var fire:SKEmitterNode! = nil
        if fireNode != nil {
            fire = fireNode as! SKEmitterNode
        }else{
            return
        }
        fire.position = personNode.position
        var x:CGFloat = 0
        var y:CGFloat = 0
            switch direction {
            case kLeft:
                fire.emissionAngle = 0
                x = 15
                y = -23
                break
            case kRight:
                fire.emissionAngle = CGFloat(Double.pi)
                x = -15
                y = -23
                break
            case kUp:
                fire.emissionAngle = CGFloat(Double.pi + Double.pi / 2.0)
                break
            case kDown:
                fire.emissionAngle = CGFloat(Double.pi / 2.0)
                break
            case kLD:
                fire.emissionAngle = CGFloat(Double.pi / 4.0)
                y = -10
                break
            case kRD:
                fire.emissionAngle = CGFloat(3 * Double.pi / 4.0)
                y = -10
                break
            case kRU:
                fire.emissionAngle = CGFloat(5 * Double.pi / 4.0)
                y = -10
                break
            case kLU:
                fire.emissionAngle = CGFloat(7 * Double.pi / 4.0)
                y = -10
                break
            default:
                break
            }
        
            fire.position = CGPoint(x:personNode.position.x + x,y:personNode.position.y + y)
            fire.targetNode = personNode.parent!
    }
    
    /// 根据类型返回对应技能图片
    ///
    /// - Parameter skillType: 技能类型
    /// - Returns: 图片
    static func skillImage(skillType:personSkillType) ->UIImage{
        switch skillType {
        case .Attack:
            return UIImage(named:"addAttack.jpg")!
        case .BLINK:
            return UIImage(named:"blink.jpg")!
        case .SPEED:
            return UIImage(named:"addSpeed.jpg")!
        case .BOOM:
            return UIImage(named:"boomIcon.png")!
        case .Attack_distance:
            return UIImage(named:"addDistance.jpg")!
        case .NoSelect:
            return UIImage(named:"starGame.png")!
        case .Fire:
            return UIImage(named:"fire.png")!
        }
    }
    
    
    /// 技能名称
    ///
    /// - Parameter skillType:
    /// - Returns: 
    static func skillName(skillType:personSkillType) ->String{
        switch skillType {
        case .Attack:
            return "123"
        case .BLINK:
            return BLINK
        case .SPEED:
            return SPEED
        case .BOOM:
            return BOOM
        case .Attack_distance:
            return "123"
        case .NoSelect:
            return "123"
        case .Fire:
            return "123"
        }
    }
    
    
   /// 移动距离
   ///
   /// - Parameters:
   ///   - direction: 朝向
   ///   - speed: 速度
   ///   - personNode: 人物
   /// - Returns: 移动位置
   static func calculateMovePoint(direction:NSString,speed:CGFloat,node:SKSpriteNode) -> CGPoint {
        
        var x:CGFloat = node.position.x;
        var y:CGFloat = node.position.y;
        
        
        
        var speed1:CGFloat = sqrt((speed * speed)/2.0);
        
        //相反方向
        if speed < 0 {
            speed1 = -1 * speed1
        }
        
        if direction.isEqual(to: kUp as String) {
            y+=speed
        }else if direction.isEqual(to: kDown as String){
            y-=speed
        }else if direction.isEqual(to: kLeft as String){
            x-=speed
        }else if direction.isEqual(to: kRight as String){
            x+=speed
        }else if direction.isEqual(to: kLU as String){
            y+=speed1
            x-=speed1
        }else if direction.isEqual(to: kRU as String){
            y+=speed1
            x+=speed1
        }else if direction.isEqual(to: kLD as String){
            y-=speed1
            x-=speed1
        }else if direction.isEqual(to: kRD as String){
            y-=speed1
            x+=speed1
        }

    
    return WDTool.overStepTest(point: CGPoint(x:x,y:y))
    
    }
    
    static func textureArr(picName:NSString,index:NSInteger) -> NSMutableArray{
        
        let arr = NSMutableArray.init()
        for index:NSInteger in 1...index {
            let imageName = "\(picName)\(index)"
            let texture = SKTexture.init(image: UIImage.init(named: imageName)!)
            arr.add(texture)
        }
        
        return arr
    }
    
    //越界判断
    static func overStepTest(point:CGPoint) -> CGPoint {
        var x:CGFloat = point.x;
        var y:CGFloat = point.y;
        if x > 2000 - 50{
            x = 2000 - 50;
        }
        
        if y > 1124 - 30{
            y = 1124 - 30;
        }
        
        if x < 0 + 30{
            x = 0 + 30;
        }
        
        if y < 0 + 30{
            y = 30;
        }
        return CGPoint(x:x,y:y)
    }
    
    
   static func calculateDirectionForBoss1(bossPoint:CGPoint,personPoint:CGPoint) -> NSString {
        var direction:NSString?

        if bossPoint.x > personPoint.x {
            direction = kLeft
        }else{
            direction = kRight
        }
        
        return direction!
    }
    
    /// 僵尸朝向
    ///
    /// - Parameters:
    ///   - point1: zom
    ///   - point2: per
    /// - Returns: 
    static func calculateDirectionForZom(point1:CGPoint,point2:CGPoint) -> NSString {
        
        let x:CGFloat = point1.x - point2.x
        let y:CGFloat = point1.y - point2.y
        
        let count:CGFloat = atan2(y, x) * 180 / CGFloat(Double.pi)
        var direction:NSString?
        
        if (count <= 20 && count >= -20) {
            direction = kLeft;
        }else if(count <= -70 && count >= -110){
            direction = kUp;
        }else if(count <= -160 || count >= 160){
            direction = kRight;
        }else if(count <= 110 && count >= 70){
            direction = kDown;
        }
        
        if (direction == nil) {
            if (count < -20 && count > -70) {
                direction = kLU;
            }else if(count < -110 && count > -160){
                direction = kRU;
            }else if(count < 160 && count > 110){
                direction = kRD;
            }else if(count < 70 && count > 20){
                direction = kLD;
            }
        }
        
        return direction!;
    }
    
    
    /// 人物朝向
    ///
    /// - Parameters:
    ///   - point1: 移动坐标
    ///   - point2: 起始坐标
    /// - Returns: 方向
    static func calculateDirection(point1:CGPoint,point2:CGPoint) -> NSString {
        
        let x:CGFloat = point1.x - point2.x
        let y:CGFloat = point1.y - point2.y
        
        let count:CGFloat = atan2(y, x) * 180 / CGFloat(Double.pi)
        var direction:NSString?
        
        if (count <= 20 && count >= -20) {
            direction = kRight;
        }else if(count <= -70 && count >= -110){
            direction = kUp;
        }else if(count <= -160 || count >= 160){
            direction = kLeft;
        }else if(count <= 110 && count >= 70){
            direction = kDown;
        }
        
        if (direction == nil) {
            if (count < -20 && count > -70) {
                direction = kRU;
            }else if(count < -110 && count > -160){
                direction = kLU;
            }else if(count < 160 && count > 110){
                direction = kLD;
            }else if(count < 70 && count > 20){
                direction = kRD;
            }
        }
        
        return direction!;
    }
    
    
    
    /// 俩个node之间距离
    ///
    /// - Parameters:
    ///   - point1:
    ///   - point2:
    /// - Returns: 
    static func calculateNodesDistance(point1:CGPoint,point2:CGPoint) -> CGFloat {
        let x:CGFloat = fabs(point1.x - point2.x);
        let y:CGFloat = fabs(point1.y - point2.y);
        
        return sqrt(x * x + y * y);
    }
    
    
    
    /// 反方向
    ///
    /// - Parameter direction:
    /// - Returns: 
    static func oppositeDirection(direction:NSString) -> NSString {
        let dic:NSDictionary = [kDown:kUp,kUp:kDown,kLeft:kRight,kRight:kLeft,kLU:kRD,kLD:kRU,kRU:kLD,kRD:kLU]
        return dic.object(forKey: direction) as! NSString
    }
    
    /// 1行图片
    ///
    /// - Parameters:
    ///   - image:
    ///   - line: 1
    ///   - arrange: var
    ///   - size:
    /// - Returns: arr
    static func
    cutCustomImage(image:UIImage,line:NSInteger,arrange:NSInteger,size:CGSize) -> NSMutableArray {
        
        let imageRef:CGImage = image.cgImage!
        let count:NSInteger = line * arrange - 1
        let textureArr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...count {
            
            let x:CGFloat = CGFloat((index % arrange) * NSInteger(size.width))
            let y:CGFloat = CGFloat((index / arrange) * NSInteger(size.height))
            //print(y)
            let rect:CGRect = CGRect(x:x,y:y,width:size.width,height:size.height)
            let cutImage:CGImage = imageRef.cropping(to: rect)!
            let texture:SKTexture = SKTexture.init(cgImage: cutImage)
            
            textureArr.add(texture)
            
        }
        
        return textureArr
    }
    
    static func cutFireImage() -> NSMutableDictionary{
        let arr = [kLeft,kRight,kUp,kDown,kLU,kRU,kLD,kRD]
        let imageRef = UIImage.init(named:"fireAc.png")!.cgImage!
        let dic = NSMutableDictionary.init()
        var x:CGFloat = 0
        for key:NSString in arr{
            let rect = CGRect(x:x,y:0,width:45,height:45)
            let cutImage = imageRef.cropping(to: rect)!
            let texture = SKTexture.init(cgImage: cutImage)
            
            dic.setValue(texture, forKey: key as String)
            x += 45
        }
        
        return dic
    }
    
    /// 人物移动图片&攻击图片
    ///
    /// - Parameter personImage: 整体图片
    /// - Returns: @{@"kLeft":@[pic1,pic2]}
    static func cutMoveImage(moveImage:UIImage) -> NSMutableDictionary {
        
        let directionArr:Array<NSString> = [kLeft,kRight,kUp,kDown,kLU,kRU,kLD,kRD]
        
        let imageRef:CGImage = moveImage.cgImage!
        let dic:NSMutableDictionary = NSMutableDictionary()
        
        let picArr:NSMutableArray = NSMutableArray()
        
        
        for _:NSInteger in 0...7 {
            let arr:NSMutableArray = NSMutableArray()
            picArr.add(arr)
        }
        
        
        
        for index:NSInteger in 0...23 {
            
            let x:CGFloat = CGFloat((index % 3) * 50)
            let y:CGFloat = CGFloat((index / 3) * 50)
            
            let arrIndex:NSInteger = index / 3
            
            let rect:CGRect = CGRect(x:x,y:y,width:50,height:50)
            let cutImage:CGImage = imageRef.cropping(to: rect)!
            
            let texture:SKTexture = SKTexture.init(cgImage: cutImage)
            let mutableArr:NSMutableArray = picArr.object(at: arrIndex) as! NSMutableArray
            mutableArr.add(texture)
        }
        
        var a:NSInteger = 0
        for key:NSString in directionArr {
            dic.setValue(picArr.object(at: a), forKey: key as String)
            a = a + 1
        }
        
        return dic
    }
    
    
    
    /// 子弹走向
    ///
    /// - Parameter personNode: person
    /// - Returns: 
    static func fireMovePoint(personNode:WDPersonNode) -> CGPoint {
        
        let direction:NSString = personNode.direction
        let point:CGPoint = personNode.position
        let distance:CGFloat = CGFloat(personNode.wdAttackDistance)
        var x:CGFloat = 0
        var y:CGFloat = 0
        let dis1:CGFloat = sqrt((distance * distance) / 2.0);
        let gunPosition:CGFloat = 10
        
        if direction.isEqual(to: kUp as String) {
            x = point.x + gunPosition
            y = point.y + distance
        }else if direction.isEqual(to: kDown as String){
            x = point.x - gunPosition
            y = point.y - distance
        }else if direction.isEqual(to: kLeft as String){
            x = point.x - distance;
            y = point.y;
        }else if direction.isEqual(to: kRight as String){
            x = point.x + distance;
            y = point.y;
        }else if direction.isEqual(to: kLU as String){
            y = point.y + dis1;
            x = point.x - dis1;
        }else if direction.isEqual(to: kRU as String){
            y = point.y + dis1;
            x = point.x + dis1;
        }else if direction.isEqual(to: kLD as String){
            y = point.y - dis1;
            x = point.x - dis1;
        }else if direction.isEqual(to: kRD as String){
            y = point.y - dis1;
            x = point.x + dis1;
        }
        
        
        return CGPoint(x:x,y:y)
    }
    
    static func firePosition(direction:NSString) -> CGPoint {
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        if direction.isEqual(to: kUp as String) {
            x = 8;
            y = 36;
        }else if direction.isEqual(to: kDown as String){
            x = -8;
            y = -36;
        }else if direction.isEqual(to: kLeft as String){
            x = -35;
            y = -3;
        }else if direction.isEqual(to: kRight as String){
            x = 35;
            y = -3;
        }else if direction.isEqual(to: kLU as String){
            x = -20;
            y = 23;
        }else if direction.isEqual(to: kRU as String){
            x = 31;
            y = 23;
        }else if direction.isEqual(to: kLD as String){
            x = -31;
            y = -23;
        }else if direction.isEqual(to: kRD as String){
            x = 20;
            y = -23;
        }
        return CGPoint(x:x,y:y)
    }
    
    
}
