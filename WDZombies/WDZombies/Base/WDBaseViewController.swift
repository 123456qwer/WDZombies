//
//  WDBaseViewController.swift
//  WDZombies
//
//  Created by wudong on 2017/12/1.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

class WDBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        
        // Do any additional setup after loading the view.
    }

    func createBG()  {
        let bgImage:UIImageView = UIImageView.init(frame: self.view.frame)
        bgImage.image = UIImage.init(named: "sun.jpg")
        self.view.addSubview(bgImage)
    }
    
    func createBackBtn()  {
        let backBtn:UIButton = UIButton.init(frame: CGRect(x:kScreenWidth - 10 - 50,y:10,width:50,height:50))
        backBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage.init(named: "back"), for: .normal)
        self.view.addSubview(backBtn)
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
