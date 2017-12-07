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
    var bgScrollView:UIScrollView!
    
    var disMiss:dismissAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImage:UIImageView = UIImageView.init(frame: self.view.frame)
        bgImage.image = UIImage.init(named: "sun.jpg")
        self.view.addSubview(bgImage)
        
        bgScrollView = UIScrollView.init(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight))
        bgScrollView.isPagingEnabled = true
        bgScrollView.contentSize = CGSize(width:kScreenWidth * 3.0,height:kScreenHeight)
        bgScrollView.bounces = false
        self.view.addSubview(bgScrollView)
        
        let model:WDUserModel = WDDataManager.shareInstance().createUserModel()
        
        self.setMap1(model: model)
        self.setMap2(model: model)
        self.setMap3(model: model)
        
        
        
        
        let backBtn:UIButton = UIButton.init(frame: CGRect(x:kScreenWidth - 10 - 50,y:10,width:50,height:50))
        backBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage.init(named: "back"), for: .normal)
        self.view.addSubview(backBtn)
    }
    
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
        }
    }

    
    @objc func backAction(sender:UIButton)  {
        self.dismiss(animated: true) {
        }
    }

    
    func setMap1(model:WDUserModel)  {
        //167 / 197
        let button:UIButton = UIButton.init(frame: CGRect(x:20,y:20,width:kScreenWidth - 40,height:kScreenHeight - 40))
        button.setImage(UIImage.init(named: "map1.png"), for: .normal)
        button.tag = MAP_1
        button.addTarget(self, action: #selector(selectMapName(sender:)), for: .touchUpInside)
        bgScrollView.addSubview(button)
        
        let width:CGFloat = 167 / 2.0
        let height:CGFloat = 197 / 2.0
        let imageV:UIImageView = UIImageView.init(frame: CGRect(x:button.frame.size.width / 2.0 - width / 2.0,y:button.frame.size.height / 2.0 - height / 2.0,width:width,height:height))
        //imageV.backgroundColor = UIColor.orange
        button.addSubview(imageV)
        
        
        let images:NSArray = [UIImage.init(named: "monster_1_move")!,UIImage.init(named: "monster_2_move")!]
        imageV.animationImages = images as? [UIImage]
        imageV.animationDuration = TimeInterval(CGFloat(images.count) * CGFloat(1 / 2.0))
        imageV.animationRepeatCount = 0
        imageV.startAnimating()
        
        WDTool.masksToSize(View: button, cornerRadius: 10)
    }
    
    func setMap2(model:WDUserModel)  {
        let button:UIButton = UIButton.init(frame: CGRect(x:20 + kScreenWidth,y:20,width:kScreenWidth - 40,height:kScreenHeight - 40))
        button.setImage(UIImage.init(named: "map1.png"), for: .normal)
        button.tag = MAP_2
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(selectMapName(sender:)), for: .touchUpInside)
        bgScrollView.addSubview(button)
        
        let width:CGFloat = 167 / 2.0
        let height:CGFloat = 197 / 2.0
        let imageV:UIImageView = UIImageView.init(frame: CGRect(x:button.frame.size.width / 2.0 - width / 2.0,y:button.frame.size.height / 2.0 - height / 2.0,width:width,height:height))
        //imageV.backgroundColor = UIColor.orange
        button.addSubview(imageV)
        
        if model.monsterCount >= 1 {
            button.isUserInteractionEnabled = true
            let images:NSArray = [UIImage.init(named: "monster_1_move_red")!,UIImage.init(named: "monster_2_move_red")!]
            imageV.animationImages = images as? [UIImage]
            imageV.animationDuration = TimeInterval(CGFloat(images.count) * CGFloat(1 / 2.0))
            imageV.animationRepeatCount = 0
            imageV.startAnimating()
        }else{
            button.isUserInteractionEnabled = false
            imageV.image = UIImage.init(named: "lock")
        }
        
        WDTool.masksToSize(View: button, cornerRadius: 10)

    }
    
    
    func setMap3(model:WDUserModel)  {
        //167 / 197
        let button:UIButton = UIButton.init(frame: CGRect(x:20 + kScreenWidth * 2,y:20,width:kScreenWidth - 40,height:kScreenHeight - 40))
        button.setImage(UIImage.init(named: "map1.png"), for: .normal)
        button.tag = MAP_3
        button.addTarget(self, action: #selector(selectMapName(sender:)), for: .touchUpInside)
        bgScrollView.addSubview(button)
        
        let width:CGFloat = 167 / 2.0
        let height:CGFloat = 197 / 2.0
        let imageV:UIImageView = UIImageView.init(frame: CGRect(x:button.frame.size.width / 2.0 - width / 2.0,y:button.frame.size.height / 2.0 - height / 2.0,width:width,height:height))
        //imageV.backgroundColor = UIColor.orange
        button.addSubview(imageV)
        
        let textures = SKTextureAtlas.init(named: "kulouPic")
        let moveArr:NSMutableArray = NSMutableArray.init()
        for index:NSInteger in 0...textures.textureNames.count - 1 {
            if index < 4{
                
                let name = "skull_move_\(index + 1)"
                let temp:UIImage = UIImage.init(named: name)!
                moveArr.add(temp)
            }
        }
        
        if model.monsterCount >= 2 {
            
            button.isUserInteractionEnabled = true
            let images:NSArray = moveArr
            imageV.animationImages = images as? [UIImage]
            imageV.animationDuration = TimeInterval(CGFloat(images.count) * CGFloat(1 / 2.0))
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
