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
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let bgImage:UIImageView = UIImageView.init(frame: self.view.frame)
        bgImage.image = UIImage.init(named: "sun.jpg")
        self.view.addSubview(bgImage)
        
        self.view.backgroundColor = UIColor.orange
        skillCount = 5
        
        let page:CGFloat = 10
        let height = (kScreenHeight  - page * 3.0) / 2.0
        let width  = (kScreenWidth  -  page * 3.0) / 2.0
        
        
        let skillView1 = WDSkillBlockView.init(frame: CGRect(x:page,y:page,width:width,height:height))
        skillView1.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        WDTool.masksToSize(View: skillView1, cornerRadius: 10)
        self.view.addSubview(skillView1)
        
        
//        let skillView2 = WDSkillBlockView.init(frame: CGRect(x:WDTool.right(View: skillView1) + page ,y:page,width:width,height:height))
//        skillView2.backgroundColor = UIColor.yellow
//        self.view.addSubview(skillView2)
        
        let skillView3 = WDSkillBlockView.init(frame: CGRect(x:page,y:WDTool.bottom(View: skillView1) + page,width:width,height:height))
        skillView3.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        WDTool.masksToSize(View: skillView3, cornerRadius: 10)
        self.view.addSubview(skillView3)
        
        let skillView4 = WDSkillBlockView.init(frame: CGRect(x:WDTool.right(View: skillView1) + page,y:WDTool.bottom(View: skillView1) + page,width:width,height:height))
        skillView4.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
        WDTool.masksToSize(View: skillView4, cornerRadius: 10)
        self.view.addSubview(skillView4)
        
        
        
        skillView1.createSkillWithType(type: .BLINK)
        //skillView2.createSkillWithType(type: .Attack)
        skillView3.createSkillWithType(type: .SPEED)
        skillView4.createSkillWithType(type: .BOOM)
        
        
       
        
        
        let confirmBtn:UIButton = UIButton.init(frame: CGRect(x:WDTool.right(View: skillView1) + page ,y:page,width:width,height:height))
        confirmBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        confirmBtn.layer.masksToBounds = true
        confirmBtn.layer.cornerRadius = 50 / 2.0
        confirmBtn.setTitle("Confirm", for: .normal)
        confirmBtn.setTitleColor(UIColor.black, for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        self.view.addSubview(confirmBtn)
        
        
        skillView1.changeFrameAction = {(Bool:Bool) ->Void in
            if Bool == true{
                skillView3.alpha = 0
                skillView4.alpha = 0
                confirmBtn.alpha = 0

            }else{
                skillView3.alpha = 1
                skillView4.alpha = 1
                confirmBtn.alpha = 1
            }
        }
        
        skillView3.changeFrameAction = {(Bool:Bool) ->Void in
            if Bool == true{
                skillView1.alpha = 0
                skillView4.alpha = 0
                confirmBtn.alpha = 0

            }else{
                skillView1.alpha = 1
                skillView4.alpha = 1
                confirmBtn.alpha = 1
            }
        }
        
        skillView4.changeFrameAction = {(Bool:Bool) ->Void in
            if Bool == true{
                skillView1.alpha = 0
                skillView3.alpha = 0
                confirmBtn.alpha = 0
            }else{
                skillView1.alpha = 1
                skillView3.alpha = 1
                confirmBtn.alpha = 1
            }
        }
    }

    
    @objc func confirmAction(sender:UIButton)  {
        self.dismiss(animated: true) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.dismiss(animated: true) {
//            
//        }
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
