//
//  WDSkillViewController.swift
//  WDZombies
//
//  Created by wudong on 2017/11/20.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

class WDSkillViewController: UIViewController {

    var skillCount = 0
    var bgScrollView:UIScrollView! = nil
    var skillViewArr:NSMutableArray! = nil
    
    func createSkill1() {
        let bgImage1:UIImageView = UIImageView.init(frame: self.view.frame)
        bgImage1.image = UIImage.init(named: "sun.jpg")
        bgImage1.isUserInteractionEnabled = true
        bgScrollView.addSubview(bgImage1)
        
        self.view.backgroundColor = UIColor.orange
        skillCount = 5
        
        let page:CGFloat = 10
        let height = (kScreenHeight  - page * 3.0) / 2.0
        let width  = (kScreenWidth  -  page * 3.0) / 2.0
        
        
        let skillView1 = WDSkillBlockView.init(frame: CGRect(x:page,y:page,width:width,height:height))
        skillView1.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        WDTool.masksToSize(View: skillView1, cornerRadius: 10)
        bgImage1.addSubview(skillView1)
        
        let skillView3 = WDSkillBlockView.init(frame: CGRect(x:page,y:WDTool.bottom(View: skillView1) + page,width:width,height:height))
        skillView3.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        WDTool.masksToSize(View: skillView3, cornerRadius: 10)
        bgImage1.addSubview(skillView3)
        
        let skillView4 = WDSkillBlockView.init(frame: CGRect(x:WDTool.right(View: skillView1) + page,y:WDTool.bottom(View: skillView1) + page,width:width,height:height))
        skillView4.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
        WDTool.masksToSize(View: skillView4, cornerRadius: 10)
        bgImage1.addSubview(skillView4)
        
        
        skillView1.createSkillWithType(type: .BLINK)
        skillView3.createSkillWithType(type: .SPEED)
        skillView4.createSkillWithType(type: .BOOM)
 
        let confirmBtn:UIButton = UIButton.init(frame: CGRect(x:WDTool.right(View: skillView1) + page ,y:page,width:width,height:height))
        confirmBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        confirmBtn.layer.masksToBounds = true
        confirmBtn.layer.cornerRadius = 50 / 2.0
        confirmBtn.setTitle("Confirm", for: .normal)
        confirmBtn.setTitleColor(UIColor.black, for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        bgImage1.addSubview(confirmBtn)
        
        skillViewArr.add(skillView1)
        skillViewArr.add(confirmBtn)
        skillViewArr.add(skillView3)
        skillViewArr.add(skillView4)
  
    }
    
    
    @objc func confirmAction(sender:UIButton)  {
        self.dismiss(animated: true) {}
    }
    
    @objc func notificationAction(notification:NSNotification)  {
        
        let dic:NSDictionary = notification.userInfo! as NSDictionary
        
        let bool:Int = dic.object(forKey: "select") as! Int
        let view:WDSkillBlockView = dic.object(forKey: "view") as! WDSkillBlockView
        
        for index:NSInteger in 0...skillViewArr.count - 1 {
            let V:UIView = skillViewArr.object(at: index) as! UIView
            if bool == 1 {
                if V != view{
                    V.alpha = 0
                }
            }else{
                V.alpha = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let bgImage1:UIImageView = UIImageView.init(frame: self.view.frame)
        bgImage1.image = UIImage.init(named: "sun.jpg")
        self.view.addSubview(bgImage1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(notification:)), name: NSNotification.Name(rawValue: CHANGE_SKILLVIEW_FRAME_NOTIFICATION), object: nil)
        skillViewArr = NSMutableArray.init()
        
        
        bgScrollView = UIScrollView.init(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight))
        bgScrollView.isPagingEnabled = true
        self.view.addSubview(bgScrollView)
        bgScrollView.contentSize = CGSize(width:kScreenWidth * 5,height:0)
        
       
        let model:WDUserModel = WDUserModel.init()
        if WDDataManager.shareInstance().openDB(){
            if model.searchToDB(){
                WDDataManager.shareInstance().canUseSkillPoint = model.skillCount
            }
        }
        
        
        WDDataManager.shareInstance().closeDB()
        self.createSkill1()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: CHANGE_SKILLVIEW_FRAME_NOTIFICATION), object: nil)
    }
    


}
