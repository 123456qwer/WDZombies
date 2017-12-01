//
//  WDMapViewController.swift
//  WDZombies
//
//  Created by wudong on 2017/11/30.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

class WDMapViewController: UIViewController {

    typealias dismissAction = (_ mapName:String) -> Void
    
    let MAP_1 = 10
    var disMiss:dismissAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImage:UIImageView = UIImageView.init(frame: self.view.frame)
        bgImage.image = UIImage.init(named: "sun.jpg")
        self.view.addSubview(bgImage)
        
        let bgScrollView:UIScrollView = UIScrollView.init(frame: CGRect(x:0,y:0,width:kScreenWidth,height:kScreenHeight))
        bgScrollView.isPagingEnabled = true
        bgScrollView.contentSize = CGSize(width:kScreenWidth * 2.0,height:kScreenHeight)
        self.view.addSubview(bgScrollView)
        
        let button:UIButton = UIButton.init(frame: CGRect(x:20,y:20,width:kScreenWidth - 40,height:kScreenHeight - 40))
        button.setImage(UIImage.init(named: "map1.png"), for: .normal)
        button.tag = MAP_1
        button.addTarget(self, action: #selector(selectMapName(sender:)), for: .touchUpInside)
        bgScrollView.addSubview(button)
        
        let backBtn:UIButton = UIButton.init(frame: CGRect(x:kScreenWidth - 10 - 50,y:10,width:50,height:50))
        backBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage.init(named: "back"), for: .normal)
        self.view.addSubview(backBtn)
    }
    
    @objc func selectMapName(sender:UIButton)  {
        if sender.tag == MAP_1{
            self.dismiss(animated: false, completion: {
                self.disMiss("WDMap_1Scene")
            })
        }
    }
    
    
    @objc func backAction(sender:UIButton)  {
        self.dismiss(animated: true) {
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
