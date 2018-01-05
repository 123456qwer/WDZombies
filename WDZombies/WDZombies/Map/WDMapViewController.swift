//
//  WDMapViewController.swift
//  WDZombies
//
//  Created by wudong on 2017/11/30.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit
import SpriteKit

class WDMapViewController: UIViewController {

    typealias dismissAction = (_ mapName:String ,_ level:NSInteger) -> Void
    
    let MAP_1 = 10
    let MAP_2 = 20
    let MAP_3 = 30
    let MAP_4 = 40
    let MAP_5 = 50
    let MAP_6 = 60
    let MAP_7 = 70

    var bgScrollView:UIScrollView!
    
    var disMiss:dismissAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImage:UIImageView = UIImageView.init(frame: self.view.frame)
        bgImage.image = UIImage.init(named: "sun.jpg")
        self.view.addSubview(bgImage)
        
        bgScrollView = UIScrollView.init(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight))
        bgScrollView.isPagingEnabled = true
        bgScrollView.contentSize = CGSize(width:kScreenWidth * 7.0,height:kScreenHeight)
        bgScrollView.bounces = false
        self.view.addSubview(bgScrollView)
        
        let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
        
        self.setMap1(model: model)
        self.setMap2(model: model)
        self.setMap3(model: model)
        self.setMap4(model: model)
        self.setMap5(model: model)
        self.setMap6(model: model)
        self.setMap7(model: model)
        
        let backBtn:UIButton = UIButton.init(frame: CGRect(x:kScreenWidth - 10 - 50,y:10,width:50,height:50))
        backBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage.init(named: "back"), for: .normal)
        self.view.addSubview(backBtn)
    }
    
    
    
//MARK:选择地图
    @objc func selectMapName(sender:UIButton)  {
        if sender.tag == MAP_1{
            self.dismiss(animated: false, completion: {
                self.disMiss("WDMap_1Scene",1)
            })
        }else if sender.tag == MAP_2{
            self.dismiss(animated: false, completion: {
                self.disMiss("WDMap_1Scene",2)
            })
        }else if sender.tag == MAP_3{
            self.dismiss(animated: false, completion: {
                self.disMiss("WDMap_1Scene",3)
            })
        }else if sender.tag == MAP_4{
            self.dismiss(animated: false, completion: {
                self.disMiss("WDMap_1Scene",4)
            })
        }else if sender.tag == MAP_5{
            self.dismiss(animated: false, completion: {
                self.disMiss("WDMap_1Scene",5)
            })
        }else if sender.tag == MAP_6{
            self.dismiss(animated: false, completion: {
                self.disMiss("WDMap_1Scene",6)
            })
        }else if sender.tag == MAP_7{
            self.dismiss(animated: false, completion: {
                self.disMiss("WDMap_1Scene",7)
            })
        }
    }
    
    
    

    
    @objc func backAction(sender:UIButton)  {
        self.dismiss(animated: true) {
        }
    }

    
    func setMap1(model:WDUserModel)  {
     
        let images:NSMutableArray = [UIImage.init(named: "monster_1_move")!,UIImage.init(named: "monster_2_move")!]
        self.setView(tag: MAP_1, width: 167 / 2.0, height: 197 / 2.0, imageArr: images , count: 0, model: model ,x:20)
    }
    
    func setMap2(model:WDUserModel)  {
      
        let images:NSMutableArray = [UIImage.init(named: "monster_1_move_red")!,UIImage.init(named: "monster_2_move_red")!]
        self.setView(tag: MAP_2, width: 167 / 2.0, height: 197 / 2.0, imageArr: images, count: 1, model: model ,x:20 + kScreenWidth )
    }
    
    
    func setMap3(model:WDUserModel)  {
      
        let textures = SKTextureAtlas.init(named: "kulouPic")
        let moveArr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...textures.textureNames.count - 1 {
            if index < 4{
                
                let name = "skull_move_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                moveArr.add(temp)
            }
        }
        
        self.setView(tag: MAP_3, width: 167 / 2.0, height: 197 / 2.0, imageArr: moveArr, count: 2, model: model ,x :20 + kScreenWidth * 2)
    }
    
    
    func setMap4(model:WDUserModel) {
       
        let textures = SKTextureAtlas.init(named: "greenZomPic")
        let moveArr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...textures.textureNames.count - 1 {
            if index < 3{
                let name = "green_move_\(index + 1)_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                moveArr.add(temp)
            }
            
            if index > 3{
                break
            }
        }
        
        self.setView(tag: MAP_4, width: 125 * 0.8, height: 125 * 0.8, imageArr: moveArr, count: 3, model: model,x:20 + 3 * kScreenWidth)
    }
    
    func setMap5(model:WDUserModel) {
        
        let textures = SKTextureAtlas.init(named: "greenZomPic")
        let moveArr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...textures.textureNames.count - 1 {
            if index < 5{
                let name = "wuqishi_move_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                moveArr.add(temp)
            }
            
            if index > 5{
                break
            }
        }
        
        self.setView(tag: MAP_5, width: 165 * 0.8, height: 165 * 0.8, imageArr: moveArr, count: 4, model: model,x:20 + 4 * kScreenWidth)
    }
    
    func setMap6(model:WDUserModel) {
        let moveArr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...7 {
            let name = "squid_move_\(index + 1)"
            let temp:UIImage = UIImage.init(named: name)!
            moveArr.add(temp)
        }
        
        self.setView(tag: MAP_6, width: 140 * 0.8, height: 100 * 0.8, imageArr: moveArr, count: 5, model: model, x: 20 + 5 * kScreenWidth)
    }
    
    func setMap7(model:WDUserModel)  {
        let moveArr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...7 {
            let name = "ox_stay_\(index + 1)"
            let temp:UIImage = UIImage.init(named: name)!
            moveArr.add(temp)
        }
        
        self.setView(tag: MAP_7, width: 200 * 0.8, height: 250 * 0.8, imageArr: moveArr, count: 6, model: model, x: 20 + 6 * kScreenWidth)
    }
    
    //count 是当前怪物数量
    func setView(tag:NSInteger,width:CGFloat,height:CGFloat,imageArr:NSMutableArray,count:NSInteger,model:WDUserModel,x:CGFloat)  {
        
        let button:UIButton = UIButton.init(frame: CGRect(x:x,y:20,width:kScreenWidth - 40,height:kScreenHeight - 40))
        button.setImage(UIImage.init(named: "map1.png"), for: .normal)
        button.tag = tag
        button.addTarget(self, action: #selector(selectMapName(sender:)), for: .touchUpInside)
        bgScrollView.addSubview(button)
        
        
        let imageV:UIImageView = UIImageView.init(frame: CGRect(x:button.frame.size.width / 2.0 - width / 2.0,y:button.frame.size.height / 2.0 - height / 2.0,width:width,height:height))
        //imageV.backgroundColor = UIColor.orange
        button.addSubview(imageV)
        
        
        if model.monsterCount >= count {
            
            button.isUserInteractionEnabled = true
            let images:NSArray = imageArr
            imageV.animationImages = images as? [UIImage]
            imageV.animationDuration = TimeInterval(CGFloat(images.count) * CGFloat(0.1))
            imageV.animationRepeatCount = 0
            imageV.startAnimating()
        }else{
            button.isUserInteractionEnabled = false
            imageV.image = UIImage.init(named: "lock")
        }
        
        
        WDTool.masksToSize(View: button, cornerRadius: 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("地图VC被销毁了！！！")
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
