//
//  WDMonsterVC.swift
//  WDZombies
//
//  Created by wudong on 2017/12/1.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDMonsterVC: WDBaseViewController {

    var bgScrollView:UIScrollView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createBG()

        bgScrollView = UIScrollView.init(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight))
        bgScrollView.isPagingEnabled = true
        bgScrollView.bounces = false
        self.view.addSubview(bgScrollView)
        
        bgScrollView.contentSize = CGSize(width:kScreenWidth * 5,height:0)
        
    
        //monster1
        self.createMonster1()
       
        //kulou
        self.createKulou()
        
        
        
        self.createBackBtn()
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createView(frame:CGRect,bgImage:UIImage) -> NSMutableArray{
        
        let imageView1:UIImageView = UIImageView.init(frame: frame)
        imageView1.isUserInteractionEnabled = true
        imageView1.image = bgImage
        bgScrollView.addSubview(imageView1)
        
        let page:CGFloat = 30
        let width:CGFloat = (kScreenWidth - page * 3) / 2.0
        let height:CGFloat = (kScreenHeight - page * 2)
        let arr:NSMutableArray = NSMutableArray.init()
        for index:Int in 0...1 {
            let x:CGFloat = CGFloat(index) * page + page + CGFloat(index) * width
            let y:CGFloat = page
            
            let view:WDMonsterView = WDMonsterView.init(frame: CGRect(x:x,y:y,width:width,height:height))
            view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            imageView1.addSubview(view)
            arr.add(view)
        }
        
        return arr
    }
    
    
    func createKulou()  {
        
        let arr:NSMutableArray = self.createView(frame: CGRect(x:kScreenWidth,y:0,width:kScreenWidth,height:kScreenHeight), bgImage: UIImage.init(named: "sun.jpg")!)

        let textures = SKTextureAtlas.init(named: "kulouPic")
        let moveArr:NSMutableArray = NSMutableArray.init()
        let attackArr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...textures.textureNames.count - 1 {
            if index < 4{

                
                let name = "skull_move_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                moveArr.add(temp)
                
                let attackName = "kulou_attack_\(index + 1)"
                let temp1:UIImage = UIImage.init(named: attackName)!
                attackArr.add(temp1)
            }
        }
        
        
        let move:NSArray = [moveArr,[]]
        let attack:NSArray = [attackArr,[]]
        let strArr:NSArray = ["I am the BOSS!","Stronger than left :("]
        let arrType:NSArray = [zomType.kulou,zomType.Red]
        let fontArr:NSArray = [UIFont.boldSystemFont(ofSize: 17),UIFont.boldSystemFont(ofSize: 20)]
        
        for index:NSInteger in 0...arr.count - 1 {
            let view:WDMonsterView = arr.object(at: index) as! WDMonsterView
            view.setImage1(images: move.object(at: index) as! NSArray,frame:view.imageView1.frame)
            view.setImage2(images: attack.object(at: index) as! NSArray,frame:view.imageView2.frame)
            view.createWithType(type: arrType.object(at: index) as! zomType)
            view.setDetail(str: strArr.object(at: index) as! String,font:fontArr.object(at: index) as! UIFont)
        }
       
        
    }
    
    func createMonster1()  {
        
        let arr:NSMutableArray = self.createView(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight), bgImage: UIImage.init(named: "redSun.jpg")!)
   
        let arrType:NSArray = [zomType.Normal,zomType.Red]
        let strArr:NSArray = ["Normal Zombie,Just Begin","Stronger than left :("]
        let fontArr:NSArray = [UIFont.boldSystemFont(ofSize: 17),UIFont.boldSystemFont(ofSize: 20)]
        let imageArr:NSArray = [[UIImage.init(named: "monster_1_move")!,UIImage.init(named: "monster_2_move")!],[UIImage.init(named: "monster_1_move_red")!,UIImage.init(named: "monster_2_move_red")!]]
        
        let monster1AttackArr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...3 {
            let image = UIImage.init(named: "monster_\(index + 1)_attack")
            monster1AttackArr.add(image!)
        }
        
        let monster2AttackArr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...3 {
            let image = UIImage.init(named: "monster_\(index + 1)_attack_red")
            monster2AttackArr.add(image!)
        }
        
        
        let monsterAttack:NSArray = [monster1AttackArr,monster2AttackArr]
        
        
        for index:Int in 0...arr.count - 1 {
           
            let view:WDMonsterView = arr.object(at: index) as! WDMonsterView
            view.setImage1(images: imageArr.object(at: index) as! NSArray,frame:view.imageView1.frame)
            view.setImage2(images: monsterAttack.object(at: index) as! NSArray,frame:view.imageView2.frame)
            view.createWithType(type: arrType.object(at: index) as! zomType)
            view.setDetail(str: strArr.object(at: index) as! String,font:fontArr.object(at: index) as! UIFont)
        }
    }
    
    deinit {
        print("怪兽列表释放了")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}