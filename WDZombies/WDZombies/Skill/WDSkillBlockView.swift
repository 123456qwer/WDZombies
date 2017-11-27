//
//  WDSkillBlockView.swift
//  WDZombies
//
//  Created by wudong on 2017/11/20.
//  Copyright © 2017年 吴冬. All rights reserved.
//

import UIKit

class WDSkillBlockView: UIView {

    let IMAGETAG = 100
    let DETAIL_LABEL_TAG = 400
    
    let BTN_1_TAG = 200
    let BTN_2_TAG = 300
    
    var skillType:personSkillType = .NoSelect
    var detailBtn:UIButton! = nil
    var initFrame:CGRect = CGRect()
    
    var detailStr:String = ""
    var gifName:String = "blink"
    
    var _model:WDSkillModel! = nil
    
  
    
    var skillLevel1 = 0
    var skillLevel2 = 0
    var skillLevel1Str:String = ""
    var skillLevel2Str:String = ""
    
    var label_1:UILabel! = nil
    var label_2:UILabel! = nil
    
    var skill_btn_1:UIButton! = nil
    var skill_btn_2:UIButton! = nil
    
    var initiative:UIButton!  = nil
    
    
//********************  data  ********************************//
    func model(name:String) -> WDSkillModel {
        let skillModel:WDSkillModel = WDSkillModel.init()
        skillModel.skillName = name
        
        if WDDataManager.shareInstance().openDB() {
            if skillModel.searchToDB(){
                print("查询成功")
            }else{
                print("查询失败")
            }
            
            WDDataManager.shareInstance().closeDB()
        }
        
        _model = skillModel
        return skillModel
    }
    
    func changeModel() {
        
        _model.skillLevel1 = skillLevel1
        _model.skillLevel2 = skillLevel2
        
        _model.skillDetailStr = detailStr
        _model.skillLevel1Str = skillLevel1Str
        _model.skillLevel2Str = skillLevel2Str
   
        
        if WDDataManager.shareInstance().openDB() {
            if _model.changeSkillToSqlite(){
                print("修改完毕")
            }else{
                print("修改出错")
            }
        }
        
        WDDataManager.shareInstance().closeDB()
    }
    
//***********************  界面  ******************************//
    func createLabelAndSmallBtn() {
        let page:CGFloat = 5
        let width = (self.frame.size.height - page * 3) / 2.0
        let x:CGFloat = self.frame.size.width - page - width
        
        skill_btn_1 = UIButton.init(frame: CGRect(x:x,y:page ,width:width,height:width))
        skill_btn_1.backgroundColor = UIColor.blue
        self.addSubview(skill_btn_1)
        
        let label_x = WDTool.right(View: detailBtn)
        let labelWidth = self.frame.size.width - width - label_x - 5 * 3
        
        
        label_1 = UILabel.init(frame: CGRect(x:WDTool.right(View: detailBtn) + 5,y:5,width:labelWidth,height:width))
        label_1.textAlignment = .center
        label_1.numberOfLines = 0
        label_1.font = UIFont.systemFont(ofSize: 13)
        label_1.backgroundColor = UIColor.blue
        self.addSubview(label_1)
        
        
        skill_btn_2 = UIButton.init(frame: CGRect(x:x,y:WDTool.bottom(View: skill_btn_1) + page ,width:width,height:width))
        skill_btn_2.backgroundColor = UIColor.blue
        self.addSubview(skill_btn_2)
        
        
        label_2 = UILabel.init(frame: CGRect(x:WDTool.right(View: detailBtn) + 5,y:WDTool.bottom(View: label_1) + 5,width:labelWidth,height:width))
        label_2.textAlignment = .center
        label_2.numberOfLines = 0
        label_2.font = UIFont.systemFont(ofSize: 13)
        label_2.backgroundColor = UIColor.blue
        self.addSubview(label_2)
        
        WDTool.masksToCircle(View: skill_btn_1)
        WDTool.masksToCircle(View: skill_btn_2)
        
        skill_btn_1.tag = BTN_1_TAG
        skill_btn_2.tag = BTN_2_TAG
    }
    
    func setContent(model:WDSkillModel)  {
       
        gifName = model.skillName
        skillLevel1 = model.skillLevel1
        skillLevel2 = model.skillLevel2
        
        detailStr = model.skillDetailStr
        skillLevel1Str = model.skillLevel1Str
        skillLevel2Str = model.skillLevel2Str
        
        label_1.text = skillLevel1Str as String
        label_2.text = skillLevel2Str as String
        
        self.isCanUse()
    }
    
    func isCanUse() {
        if _model.haveLearn == 0{
            skill_btn_1.isUserInteractionEnabled = false
            skill_btn_2.isUserInteractionEnabled = false
            skill_btn_1.alpha = 0.2
            skill_btn_2.alpha = 0.2
            initiative.alpha  = 0.2
        }else{
            skill_btn_1.isUserInteractionEnabled = true
            skill_btn_2.isUserInteractionEnabled = true
            skill_btn_1.alpha = 1
            skill_btn_2.alpha = 1
            initiative.alpha  = 1
        }
    }
  
    
    func boomAction() {
        
        self.createLabelAndSmallBtn()
        self.setContent(model:self.model(name: BOOM))
        
        skill_btn_1.addTarget(self, action: #selector(boomAction(sender:)), for: .touchUpInside)
        skill_btn_2.addTarget(self, action: #selector(boomAction(sender:)), for: .touchUpInside)
    }
    
    func speedAction() {
        
        self.createLabelAndSmallBtn()
        self.setContent(model:self.model(name: SPEED))

        skill_btn_1.addTarget(self, action: #selector(speedAction(sender:)), for: .touchUpInside)
        skill_btn_2.addTarget(self, action: #selector(speedAction(sender:)), for: .touchUpInside)
    }
    
    
    func blinkAction() {
  
        self.createLabelAndSmallBtn()
        self.setContent(model:self.model(name: BLINK))
        
        skill_btn_1.addTarget(self, action: #selector(blinkAction(sender:)), for: .touchUpInside)
        skill_btn_2.addTarget(self, action: #selector(blinkAction(sender:)), for: .touchUpInside)
    }
    
    
    
    func createDetailLabel(sender:UIButton)  {
        
        let height = self.frame.size.height - WDTool.bottom(View: sender) - 20
        let detailLabel = UILabel.init(frame: CGRect(x:WDTool.left(View: sender),y:WDTool.bottom(View: sender) + 10,width:self.frame.size.width - 20,height:height))
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.systemFont(ofSize: 25)
        detailLabel.text = detailStr as String?
        detailLabel.backgroundColor = UIColor.blue
        detailLabel.tag = self.DETAIL_LABEL_TAG
        self.addSubview(detailLabel)
    }
    
    
    func createDetailImageView(sender:UIButton)  {
        
        let width = self.frame.size.width / 2.0 - 20
        let imageView = UIImageView.init(frame: CGRect(x:self.frame.size.width / 2.0 + 10,y:CGFloat(10),width:width,height:self.frame.size.height / 2.0 - 10 - 10 - 5))
        imageView.backgroundColor = UIColor.darkGray
        imageView.tag = self.IMAGETAG
        self.addSubview(imageView)
        
        //gif文件路径
        let path = Bundle.main.path(forResource: gifName as String, ofType: "gif")
        //数据
        let source = CGImageSourceCreateWithURL(URL.init(fileURLWithPath: path!) as CFURL, nil)
        //3获取图片个数
        let count = CGImageSourceGetCount(source!)
        //time
        //let allTime = 0
        //所有图片
        let imageArray = NSMutableArray.init()
        //每针播放时间
        //let timeArray  = NSMutableArray.init()
        
        for i:size_t in 0...count - 1{
            let image = CGImageSourceCreateImageAtIndex(source!, i, nil)
            let imageA = UIImage.init(cgImage: image!)
            imageArray.add(imageA)
        }
        
        imageView.animationImages = imageArray as? [UIImage]
        imageView.animationDuration = 5
        imageView.startAnimating()
        
    }
    
    
//*****************  根据类型创建界面  ************************//
    func createSkillWithType(type:personSkillType)  {
        
        initFrame = self.frame
        skillType = type
        detailStr = "123"
        
        let page:CGFloat = 30
        
        let width = (self.frame.size.height - page * 2)
        
    
        initiative = UIButton.init(frame:CGRect(x:10,y:5,width:width,height:width))
        initiative.setBackgroundImage(WDTool.skillImage(skillType: skillType), for: .normal)
        initiative.addTarget(self, action: #selector(initiativeAction(sender:)), for: .touchUpInside)
        initiative.alpha = 0.2
        self.addSubview(initiative)
        
        WDTool.masksToCircle(View: initiative)
        
        
        detailBtn = UIButton.init(frame: CGRect(x:10,y:WDTool.bottom(View: initiative) + 5,width:width,height:40))
        detailBtn.backgroundColor = UIColor.blue
        detailBtn.setTitle("Detail", for: .normal)
        detailBtn.setTitle("Close", for: .selected)
        detailBtn.addTarget(self, action: #selector(detailAction(sender:)), for: .touchUpInside)
        self.addSubview(detailBtn)
        
        
        switch skillType {
        case .Attack:
            break
        case .BLINK:
            self.blinkAction()
            break
        case .SPEED:
            self.speedAction()
            break
        case .BOOM:
            self.boomAction()
            break
        case .Attack_distance:
            break
        case .NoSelect:
            break
        case .Fire:
            break
        }
    }
    
    
    
//******************* 选择技能的方法  ***********************//
   
    func changeLabel()  {
        
        label_1.text = skillLevel1Str as String
        label_2.text = skillLevel2Str as String
        
        if self.viewWithTag(DETAIL_LABEL_TAG) != nil{
            let detailLabel = self.viewWithTag(DETAIL_LABEL_TAG) as! UILabel
            detailLabel.text = detailStr as String
        }

        self.changeModel()

    }
    
    
    /// 炸弹技能
    ///
    /// - Parameter sender:
    @objc func boomAction(sender:UIButton)  {
        
        if sender.tag == BTN_1_TAG {
            
            
            skillLevel1 -= 5
            
            if skillLevel1 <= 25{
                skillLevel1 = 25
            }
            
            let dic:NSDictionary = ["50":"0/5\nReduce Waiting Time 5S","45":"1/5\nReduce Waiting Time 5S","40":"2/5\nReduce Waiting Time 5S","35":"3/5\nReduce Waiting Time 5S","30":"4/5\nReduce Waiting Time 5S","25":"5/5\nReduce Waiting Time 5S"]
            skillLevel1Str = dic.object(forKey: "\(skillLevel1)") as! String
            
            
        }else{
            
            
            skillLevel2 += 1
            if skillLevel2 >= 10 {
                skillLevel2 = 10
            }
            
            let dic:NSDictionary = ["5":"0/5\nIncrease Damage 1","6":"1/5\nIncrease Damage 1","7":"2/5\nIncrease Damage 1","8":"3/5\nIncrease Damage 1","9":"4/5\nIncrease Damage 1","10":"5/5\nIncrease Damage 1"]
            skillLevel2Str = dic.object(forKey: "\(skillLevel2)") as! String
            
        }
        
        detailStr = "Waiting Time: \(skillLevel1)S \n Increase Damage: \(skillLevel2)S" as String
        self.changeLabel()
    }
  
    
    /// 加速技能
    ///
    /// - Parameter sender:
    @objc func speedAction(sender:UIButton) {
        
        if sender.tag == BTN_1_TAG {
            
            
            skillLevel1 -= 5
            
            if skillLevel1 <= 25{
                skillLevel1 = 25
            }
            
            let dic:NSDictionary = ["50":"0/5\nReduce Waiting Time 5S","45":"1/5\nReduce Waiting Time 5S","40":"2/5\nReduce Waiting Time 5S","35":"3/5\nReduce Waiting Time 5S","30":"4/5\nReduce Waiting Time 5S","25":"5/5\nReduce Waiting Time 5S"]
            skillLevel1Str = dic.object(forKey: "\(skillLevel1)") as! String
            
            
        }else{
            
            
            skillLevel2 += 1
            if skillLevel2 >= 7 {
                skillLevel2 = 7
            }
            
            let dic:NSDictionary = ["2":"0/5\nIncrease Hold Time 1","3":"1/5\nIncrease Hold Time 1","4":"2/5\nIncrease Hold Time 1","5":"3/5\nIncrease Hold Time 1","6":"4/5\nIncrease Hold Time 1","7":"5/5\nIncrease Hold Time 1"]
            skillLevel2Str = dic.object(forKey: "\(skillLevel2)") as! String
            
        }
        
        detailStr = "Waiting Time: \(skillLevel1)S \n Hold Time: \(skillLevel2)S" as String
        self.changeLabel()
    }
    
    
    /// 闪烁技能
    ///
    /// - Parameter sender:
    @objc func blinkAction(sender:UIButton) {
  
        
        
        if sender.tag == BTN_1_TAG {
            
          
            
            skillLevel1 -= 5
            
            if skillLevel1 <= 5{
                skillLevel1 = 5
            }
            
            let dic:NSDictionary = ["30":"0/5\nReduce Waiting Time 5S","25":"1/5\nReduce Waiting Time 5S","20":"2/5\nReduce Waiting Time 5S","15":"3/5\nReduce Waiting Time 5S","10":"4/5\nReduce Waiting Time 5S","5":"5/5\nReduce Waiting Time 5S"]
            skillLevel1Str = dic.object(forKey: "\(skillLevel1)") as! String
            

        }else{
            
            
            skillLevel2 += 20
            if skillLevel2 >= 300 {
                skillLevel2 = 300
            }
            
            let dic:NSDictionary = ["200":"0/5\nIncrease Distance 20","220":"1/5\nIncrease Distance 20","240":"2/5\nIncrease Distance 20","260":"3/5\nIncrease Distance 20","280":"4/5\nIncrease Distance 20","300":"5/5\nIncrease Distance 20"]
            skillLevel2Str = dic.object(forKey: "\(skillLevel2)") as! String
     
        }
    
        detailStr = "Waiting Time:  \(skillLevel1)S \n Blink Distance: \(skillLevel2)" as String
        if self.viewWithTag(DETAIL_LABEL_TAG) != nil{
            let detailLabel = self.viewWithTag(DETAIL_LABEL_TAG) as! UILabel
            detailLabel.text = detailStr as String
        }
        
        self.changeLabel()
    }
    
    
    @objc func detailAction(sender:UIButton)  {
       
        sender.isSelected = !sender.isSelected
        self.superview?.bringSubview(toFront: self)
        
        if sender.isSelected == true{
            
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = CGRect(x:10,y:10,width:kScreenWidth - 20,height:kScreenHeight - 20)
            }, completion: { (true) in
                
              self.createDetailLabel(sender: sender)
              self.createDetailImageView(sender: sender)
                
            })
            
        }else{
            
            UIView.animate(withDuration: 0.3) {
                self.frame = self.initFrame
            }
            
            let detailLabel = self.viewWithTag(DETAIL_LABEL_TAG)
            detailLabel?.removeFromSuperview()
            let imageV = self.viewWithTag(IMAGETAG)
            imageV?.removeFromSuperview()
            
        }
    }
    
    
    
    
    @objc func initiativeAction(sender:UIButton)  {
        
        if _model.haveLearn == 1{
            return
        }
        
        _model.haveLearn = 1
        self.changeModel()
        self.isCanUse()
    
    }
    
}
