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
        
        for index:Int in 0...1 {
            let x:CGFloat = CGFloat(index) * page + page + CGFloat(index) * width
            let y:CGFloat = page
            
            let view:WDMonsterView = WDMonsterView.init(frame: CGRect(x:x,y:y,width:width,height:height))
            view.backgroundColor = UIColor.gray
            imageView1.addSubview(view)
            
            view.createWithType(type: arr.object(at: index) as! zomType)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
