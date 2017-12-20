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
    var mapDic:NSMutableDictionary!
    var textureDic:NSMutableDictionary!

    
    static let sharedInstance = WDMapManager.init()
    private override init() {}
    
    func setZom()  {
        let moveDic = WDTool.cutMoveImage(moveImage: UIImage.init(named: "NormalZom.png")!)
        let attackDic = WDTool.cutMoveImage(moveImage: UIImage.init(named: "NormalAttack.png")!)
        let diedArr   = WDTool.cutCustomImage(image: UIImage.init(named:"NormalDied.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:50))
        
        let redMoveDic = WDTool.cutMoveImage(moveImage: UIImage.init(named: "RedNormalZom.png")!)
        let redAttackDic = WDTool.cutMoveImage(moveImage: UIImage.init(named: "RedNormalAttack.png")!)
        let redDiedArr   = WDTool.cutCustomImage(image: UIImage.init(named:"RedNormalDied.png")!, line: 1, arrange: 4, size: CGSize(width:50,height:50))
        
        self.textureDic.setObject(moveDic, forKey: "normalZomMove" as NSCopying)
        self.textureDic.setObject(attackDic, forKey: "normalZomAttack" as NSCopying)
        self.textureDic.setObject(diedArr, forKey: "normalZomDied" as NSCopying)
        
        self.textureDic.setObject(redMoveDic, forKey: "redNormalZomMove" as NSCopying)
        self.textureDic.setObject(redAttackDic, forKey: "redNormalZomAttack" as NSCopying)
        self.textureDic.setObject(redDiedArr, forKey: "redNormalZomDied" as NSCopying)
    }
    
    func setGreenZom() {
        let textures = SKTextureAtlas.init(named: "greenZomPic")
        
        let moveArr:NSMutableArray = NSMutableArray.init()
        let attack1Arr:NSMutableArray = NSMutableArray.init()
        let attack2Arr:NSMutableArray = NSMutableArray.init()
        let diedArr:NSMutableArray = NSMutableArray.init()
        let smokeArr:NSMutableArray = NSMutableArray.init()
        let clawArr:NSMutableArray = NSMutableArray.init()
        
        for index:NSInteger in 0...11 {
            
            if index < 3{
                let name = "green_move_\(index + 1)"
                let temp = textures.textureNamed(name)
                moveArr.add(temp)
                
                let name2 = "green_attack1_\(index + 1)"
                let temp2 = textures.textureNamed(name2)
                attack1Arr.add(temp2)
            }
            
            if index < 12 {
                let name = "green_attack2_\(index + 1)"
                let temp = textures.textureNamed(name)
                attack2Arr.add(temp)
            }
            
            if index < 5 {
                let name = "green_smoke\(index + 1)"
                let temp = textures.textureNamed(name)
                smokeArr.add(temp)
            }
            
            if index < 5 {
                let name = "green_claw_\(index + 1)"
                let temp = textures.textureNamed(name)
                clawArr.add(temp)
            }
            
            if index < 10{
                let name = "green_died_\(index + 1)"
                let temp = textures.textureNamed(name)
                diedArr.add(temp)
            }
        }
        
        self.textureDic.setObject(moveArr, forKey: GREEN_MOVE as NSCopying)
        self.textureDic.setObject(attack1Arr, forKey: GREEN_ATTACK1 as NSCopying)
        self.textureDic.setObject(attack2Arr, forKey: GREEN_ATTACK2 as NSCopying)
        self.textureDic.setObject(diedArr, forKey: GREEN_DIED as NSCopying)
        self.textureDic.setObject(smokeArr, forKey: GREEN_SMOKE as NSCopying)
        self.textureDic.setObject(clawArr, forKey: GREEN_CLAW_NAME as NSCopying)
    }
    
    func setKnightZom() {
        
        let textures = SKTextureAtlas.init(named: "knightNodePic")
        
        let moveArr:NSMutableArray = NSMutableArray.init()
        let attack1Arr:NSMutableArray = NSMutableArray.init()
        let attack2Arr:NSMutableArray = NSMutableArray.init()
        let diedArr:NSMutableArray = NSMutableArray.init()
      
        for index:NSInteger in 0...11 {
            
            if index < 8{
             
                let name2 = "wuqishi_attack1_\(index + 1)"
                let temp2 = textures.textureNamed(name2)
                attack1Arr.add(temp2)
            }
            
            if index < 11 {
                let name = "wuqishi_attack2_\(index + 1)"
                let temp = textures.textureNamed(name)
                attack2Arr.add(temp)
            }
            
            if index < 5 {
                let name = "wuqishi_move_\(index + 1)"
                let temp = textures.textureNamed(name)
                moveArr.add(temp)
            }
            
         
            
            if index < 7{
                let name = "wuqishi_died_\(index + 1)"
                let temp = textures.textureNamed(name)
                diedArr.add(temp)
            }
        }
        
        self.textureDic.setObject(moveArr, forKey: KNIGHT_MOVE as NSCopying)
        self.textureDic.setObject(attack1Arr, forKey: KNIGHT_ATTACK1 as NSCopying)
        self.textureDic.setObject(attack2Arr, forKey: KNIGHT_ATTACK2 as NSCopying)
        self.textureDic.setObject(diedArr, forKey: KNIGHT_DIED as NSCopying)
    
    }
    
    func setKulouZom(){
        let moveArr = NSMutableArray.init()
        let diedArr = NSMutableArray.init()
        let attackArr = NSMutableArray.init()
        
        let textures = SKTextureAtlas.init(named: "kulouPic")
        for index:NSInteger in 0...4 {
            
            if index < 4{
                let name = "skull_move_\(index + 1)"
                let temp = textures.textureNamed(name)
                moveArr.add(temp)
                
                let attackName = "kulou_attack_\(index + 1)"
                let temp1 = textures.textureNamed(attackName)
                attackArr.add(temp1)
            }
            
            if index < 5{
                let name = "kulou_died_\(index + 1)"
                let temp = textures.textureNamed(name)
                diedArr.add(temp)
            }
        }
        
        self.textureDic.setObject(moveArr, forKey: KULOU_MOVE as NSCopying)
        self.textureDic.setObject(attackArr, forKey: KULOU_ATTACK as NSCopying)
        self.textureDic.setObject(diedArr, forKey: KULOU_DIED as NSCopying)
    }
    
    func setPic()  {
        
        self.mapDic = NSMutableDictionary.init()
        self.textureDic = NSMutableDictionary.init()
        
        self.setZom()
        self.setGreenZom()
        self.setKnightZom()
        self.setKulouZom()
    }
    
    
    func beAttackTextureWithName(atlasName:String,textureName:String) -> SKTexture {
        let textures = SKTextureAtlas.init(named: atlasName)
        return textures.textureNamed(textureName)
    }
    
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
