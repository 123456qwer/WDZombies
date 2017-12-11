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
    var viewArr:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewArr = NSMutableArray.init()
        self.createBG()
        
        bgScrollView = UIScrollView.init(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight))
        bgScrollView.isPagingEnabled = true
        bgScrollView.bounces = false
        self.view.addSubview(bgScrollView)
        
        bgScrollView.contentSize = CGSize(width:kScreenWidth * 2,height:0)
        
    
        //monster1
        self.createMonster1()
       
        //kulou
        self.createMonster2()
        
        let model:WDUserModel = WDUserModel.init()
        _ = model.searchToDB()
        
        //怪物个数
        for index:NSInteger in 0...viewArr.count - 1 {
            
            let view:WDMonsterView = viewArr.object(at: index) as! WDMonsterView
            if model.monsterCount >= index + 1{
                view.setLock(isLock: false)
            }else{
                view.setLock(isLock: true)
            }
        }
        
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
    
    
    func createMonster2()  {
        
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
        
        let moveArr2:NSMutableArray = NSMutableArray.init()
        let attack2Arr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...11 {
            
            if index < 3{
                let name = "green_move_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                moveArr2.add(temp)
              
            }
            
            if index < 12 {
                let name = "green_attack2_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                attack2Arr.add(temp)
            }
            
        
        }
        
        let move:NSArray = [moveArr,moveArr2]
        let attack:NSArray = [attackArr,attack2Arr]
        let strArr:NSArray = ["I am the BOSS!","I am Slow"]
        let arrType:NSArray = [zomType.kulou,zomType.GreenZom]
        let fontArr:NSArray = [UIFont.boldSystemFont(ofSize: 17),UIFont.boldSystemFont(ofSize: 20)]
        
   
        
        for index:NSInteger in 0...arr.count - 1 {
            let view:WDMonsterView = arr.object(at: index) as! WDMonsterView

            if index == 0{
                view.setImage1(images: move.object(at: index) as! NSArray,frame:view.imageView1.frame)
                view.setImage2(images: attack.object(at: index) as! NSArray,frame:view.imageView2.frame)
            }else{
                let width:CGFloat = 100
            
                view.setImage1(images: move.object(at: index) as! NSArray,frame:CGRect(x:-5,y:10,width:width,height:width))
                view.setImage2(images: attack.object(at: index) as! NSArray,frame:CGRect(x:0,y:10,width:width,height:width))
            }
     
            
            view.createWithType(type: arrType.object(at: index) as! zomType)
            view.setDetail(str: strArr.object(at: index) as! String,font:fontArr.object(at: index) as! UIFont)
            
            viewArr.add(view)

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
            
            
            viewArr.add(view)
            
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
