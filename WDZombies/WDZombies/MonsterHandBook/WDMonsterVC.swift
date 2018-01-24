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
        
        bgScrollView.contentSize = CGSize(width:kScreenWidth * 5,height:0)
        
    
        //monster1
        self.createMonster1()
       
        //kulou & greenZom
        self.createMonster2()
        
        //雾骑士 & 鱿鱼
        self.createMonster3()
        
        //公牛 & 骷髅骑士
        self.createMonster4()

        //海豹 & 狗
        self.createMonster5()
        
        let model:WDUserModel = WDUserModel.init()
        _ = model.searchToDB()
    
        //怪物个数
        for index:NSInteger in 0...viewArr.count - 1 {
            let view:WDMonsterView = viewArr.object(at: index) as! WDMonsterView
            //FIXME: 怪物个数
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
    
    func createKillArrWithName(name1:String,name2:String) -> NSArray{
        let model1:WDMonsterModel = WDMonsterModel.init()
        model1.monsterName  = name1
        _ = model1.searchToDB()
        
        let model2:WDMonsterModel = WDMonsterModel.init()
        model2.monsterName  = name2
        _ = model2.searchToDB()
       
        let kill1:String = "killed:\(model1.killCount)\n be killed:\(model1.beKillCount)"
        let kill2:String = "killed:\(model2.killCount)\n be killed:\(model2.beKillCount)"

        return [kill1,kill2]
    }
    
    func createMonster1()  {
        
        
        let arr:NSMutableArray = self.createView(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight), bgImage: UIImage.init(named: "redSun.jpg")!)
    
        
        let arrType:NSArray = [zomType.Normal,zomType.Red]
        let strArr:NSArray = self.createKillArrWithName(name1: NORMAL_ZOM, name2: RED_ZOM)
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

    func createMonster2()  {
        
        let arr:NSMutableArray = self.createView(frame: CGRect(x:kScreenWidth,y:0,width:kScreenWidth,height:kScreenHeight), bgImage: UIImage.init(named: "sun.jpg")!)

        let moveArr:NSMutableArray = NSMutableArray.init()
        let attackArr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...3 {
                let name = "book_kulou_move_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                moveArr.add(temp)
                
                let attackName = "book_kulou_attack_\(index + 1)"
                let temp1:UIImage = UIImage.init(named: attackName)!
                attackArr.add(temp1)
            
        }
        
        let moveArr2:NSMutableArray = NSMutableArray.init()
        let attack2Arr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...11 {
            
            if index < 3{
                let name = "book_green_move_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                moveArr2.add(temp)
              
            }
            
            if index < 12 {
                let name = "book_green_attack_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                attack2Arr.add(temp)
            }
        }
        
        let move:NSArray = [moveArr,moveArr2]
        let attack:NSArray = [attackArr,attack2Arr]
        let strArr:NSArray = self.createKillArrWithName(name1: KULOU_NAME, name2: GREEN_ZOM_NAME)
        let arrType:NSArray = [zomType.kulou,zomType.GreenZom]
        let fontArr:NSArray = [UIFont.boldSystemFont(ofSize: 17),UIFont.boldSystemFont(ofSize: 20)]
    
        for index:NSInteger in 0...arr.count - 1 {
            let view:WDMonsterView = arr.object(at: index) as! WDMonsterView

          
            view.setImage1(images: move.object(at: index) as! NSArray,frame:view.imageView1.frame)
            view.setImage2(images: attack.object(at: index) as! NSArray,frame:view.imageView2.frame)
            view.createWithType(type: arrType.object(at: index) as! zomType)
            view.setDetail(str: strArr.object(at: index) as! String,font:fontArr.object(at: index) as! UIFont)
            
            viewArr.add(view)
        }
    }
   
    
    func createMonster3()  {
//        universe
        let arr:NSMutableArray = self.createView(frame: CGRect(x:kScreenWidth * 2,y:0,width:kScreenWidth,height:kScreenHeight), bgImage: UIImage.init(named: "universe.jpg")!)
        
        let moveArr:NSMutableArray = NSMutableArray.init()
        let attack1Arr:NSMutableArray = NSMutableArray.init()
        let moveArr2:NSMutableArray = NSMutableArray.init()
        let attack2Arr:NSMutableArray = NSMutableArray.init()
        
        for index:NSInteger in 0...7{
            let moveName = "book_squid_move_\(index + 1)"
            let moveTemp:UIImage = UIImage.init(named: moveName)!
            moveArr2.add(moveTemp)
            
            if index < 6{
                let attack = "book_squid_attack_\(index + 1)"
                let attackTemp:UIImage = UIImage.init(named: attack)!
                attack2Arr.add(attackTemp)
            }
        }
        
        
        for index:NSInteger in 0...10 {
        
            if index < 11 {
                let name = "book_kinght_attack_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                attack1Arr.add(temp)
            }
            
            if index < 5 {
                let name = "book_kinght_move_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                moveArr.add(temp)
            }
        }
        
        let move:NSArray = [moveArr,moveArr2]
        let attack:NSArray = [attack1Arr,attack2Arr]
        let strArr:NSArray = self.createKillArrWithName(name1: KNIGHT_NAME, name2: SQUID_NAME)
        let arrType:NSArray = [zomType.kNight,zomType.Squid]
        let fontArr:NSArray = [UIFont.boldSystemFont(ofSize: 17),UIFont.boldSystemFont(ofSize: 20)]
        
        for index:NSInteger in 0...arr.count - 1 {
            let view:WDMonsterView = arr.object(at: index) as! WDMonsterView
            
            view.setImage1(images: move.object(at: index) as! NSArray,frame:view.imageView1.frame)
            view.setImage2(images: attack.object(at: index) as! NSArray,frame:view.imageView2.frame)
            view.createWithType(type: arrType.object(at: index) as! zomType)
            view.setDetail(str: strArr.object(at: index) as! String,font:fontArr.object(at: index) as! UIFont)
            
            viewArr.add(view)
        }
    }

    func createMonster4() {
        let arr:NSMutableArray = self.createView(frame: CGRect(x:kScreenWidth * 3,y:0,width:kScreenWidth,height:kScreenHeight), bgImage: UIImage.init(named: "redSun.jpg")!)
        
        let moveArr:NSMutableArray = NSMutableArray.init()
        let attack1Arr:NSMutableArray = NSMutableArray.init()
        let moveArr2:NSMutableArray = NSMutableArray.init()
        let attack2Arr:NSMutableArray = NSMutableArray.init()
        
        for index:NSInteger in 0...7{
            let moveName = "book_ox_stay_\(index + 1)"
            let moveTemp:UIImage = UIImage.init(named: moveName)!
            moveArr.add(moveTemp)
            
            if index < 6{
                let attackName = "ox_attack_\(index + 1)"
                let attackPic  = UIImage.init(named: attackName)!
                attack1Arr.add(attackPic)
            }
            
            let kulouA = "kulou_knight_attack_\(index + 1)"
            let kulouAImage = UIImage.init(named: kulouA)!
            attack2Arr.add(kulouAImage)
        }
        
        
        for index:NSInteger in 0...3 {
          
            let name = "kulou_knight_move_\(index + 1)"
            let temp:UIImage = UIImage.init(named: name)!
            moveArr2.add(temp)
            
        }
        
        let move:NSArray = [moveArr,moveArr2]
        let attack:NSArray = [attack1Arr,attack2Arr]
        let strArr:NSArray = self.createKillArrWithName(name1: OX_NAME, name2: KULOU_KNIGHT_NAME)
        let arrType:NSArray = [zomType.ox,zomType.kulouKnight]
        let fontArr:NSArray = [UIFont.boldSystemFont(ofSize: 17),UIFont.boldSystemFont(ofSize: 20)]
        
        
        let frame1Arr = [CGRect(x:0,y:0,width:163/2.0,height:197/2.0),CGRect(x:0,y:0,width:170/2.0,height:170/2.0)]
        let frame2Arr = [CGRect(x:0,y:0,width:200/2.0,height:250/2.0),CGRect(x:0,y:0,width:170/2.0,height:170/2.0)]
        
        
        for index:NSInteger in 0...arr.count - 1 {
            let view:WDMonsterView = arr.object(at: index) as! WDMonsterView
            
            view.setImage1(images: move.object(at: index) as! NSArray,frame:frame1Arr[index])
            
            view.setImage2(images: attack.object(at: index) as! NSArray,frame:frame2Arr[index])
            view.createWithType(type: arrType.object(at: index) as! zomType)
            view.setDetail(str: strArr.object(at: index) as! String,font:fontArr.object(at: index) as! UIFont)
            
            viewArr.add(view)
        }
    }
    
    func createMonster5() {
       
        let arr:NSMutableArray = self.createView(frame: CGRect(x:kScreenWidth * 4,y:0,width:kScreenWidth,height:kScreenHeight), bgImage: UIImage.init(named: "universe.jpg")!)
        
        let moveArr:NSMutableArray = NSMutableArray.init()
        let attack1Arr:NSMutableArray = NSMutableArray.init()
        let moveArr2:NSMutableArray = NSMutableArray.init()
        let attack2Arr:NSMutableArray = NSMutableArray.init()
        
        for index:NSInteger in 0...10{
          
            //130 / 150
            let attackName = "seal_attack_\(index + 1)"
            let attackPic  = UIImage.init(named: attackName)!
            attack1Arr.add(attackPic)
            
            if index < 6{
                
                let moveName = "seal_move_\(index + 1)"
                let moveTemp:UIImage = UIImage.init(named: moveName)!
                moveArr.add(moveTemp)
            }
         
        }
        
        for index:NSInteger in 0...11{
            
            //130 / 150
            let attackName = "dog_attack_\(index + 1)"
            let attackPic  = UIImage.init(named: attackName)!
            attack2Arr.add(attackPic)
            
            if index < 8{
                
                let moveName = "dog_move_\(index + 1)"
                let moveTemp:UIImage = UIImage.init(named: moveName)!
                moveArr2.add(moveTemp)
            }
            
        }
        
      
        
        let move:NSArray = [moveArr,moveArr2]
        let attack:NSArray = [attack1Arr,attack2Arr]
        let strArr:NSArray = self.createKillArrWithName(name1: SEAL_NAME, name2: DOG_NAME)
        let arrType:NSArray = [zomType.seal,zomType.dog]
        let fontArr:NSArray = [UIFont.boldSystemFont(ofSize: 17),UIFont.boldSystemFont(ofSize: 20)]
        
        
        let frame1Arr = [CGRect(x:0,y:0,width:130 * 0.7,height:150 * 0.7),CGRect(x:0,y:0,width:180 * 0.7,height:130 * 0.7)]
        let frame2Arr = [CGRect(x:0,y:0,width:130 * 0.7,height:150 * 0.7),CGRect(x:0,y:0,width:180 * 0.7,height:130 * 0.7)]
        
        
        for index:NSInteger in 0...arr.count - 1 {
            let view:WDMonsterView = arr.object(at: index) as! WDMonsterView
            
            view.setImage1(images: move.object(at: index) as! NSArray,frame:frame1Arr[index])
            
            view.setImage2(images: attack.object(at: index) as! NSArray,frame:frame2Arr[index])
            view.createWithType(type: arrType.object(at: index) as! zomType)
            view.setDetail(str: strArr.object(at: index) as! String,font:fontArr.object(at: index) as! UIFont)
            
            viewArr.add(view)
        }
    }
    
    
    
    
    deinit {
        print("怪兽列表释放了")
    }

}
