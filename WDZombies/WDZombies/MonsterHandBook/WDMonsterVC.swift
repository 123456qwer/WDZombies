//
//  WDMonsterVC.swift
//  WDZombies
//
//  Created by wudong on 2017/12/1.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

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

        
        
        
        self.createBackBtn()
    }

   
    func createMonster1()  {
        
        let imageView1:UIImageView = UIImageView.init(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight))
        imageView1.isUserInteractionEnabled = true
        imageView1.image = UIImage.init(named: "sun.jpg")
        bgScrollView.addSubview(imageView1)
        
        let page:CGFloat = 30
        let width:CGFloat = (kScreenWidth - page * 3) / 2.0
        let height:CGFloat = (kScreenHeight - page * 2)
        
        
        
        let arr:NSArray = [zomType.Normal,zomType.Red]
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
        
        
        for index:Int in 0...1 {
            let x:CGFloat = CGFloat(index) * page + page + CGFloat(index) * width
            let y:CGFloat = page
            
            
            let view:WDMonsterView = WDMonsterView.init(frame: CGRect(x:x,y:y,width:width,height:height))
            view.backgroundColor = UIColor.cyan
            imageView1.addSubview(view)
            if index == 0{
                view.setImage1(images: imageArr.object(at: index) as! NSArray)
                view.setImage2(images: monster1AttackArr)
                view.createWithType(type: arr.object(at: index) as! zomType)
                view.setDetail(str: strArr.object(at: index) as! String,font:fontArr.object(at: index) as! UIFont)
            }else{
                view.setImage1(images: imageArr.object(at: index) as! NSArray)
                view.setImage2(images: monster2AttackArr)
                view.createWithType(type: arr.object(at: index) as! zomType)
                view.setDetail(str: strArr.object(at: index) as! String,font:fontArr.object(at: index) as! UIFont)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
