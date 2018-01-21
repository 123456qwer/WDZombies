//
//  WDExperienceView.swift
//  WDZombies
//
//  Created by wudong on 2018/1/19.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit

class WDExperienceView: UIView {

    var _radius:CGFloat = 0
    var _arcCenter:CGPoint = CGPoint(x:0,y:0)
    var _startAngle:CGFloat = 0
    var _endAngle:CGFloat = 0
    var _lineWidth:CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path:UIBezierPath = UIBezierPath.init(arcCenter: _arcCenter, radius: _radius, startAngle: _startAngle, endAngle: _endAngle, clockwise: true)

        let color = UIColor.yellow
        color.set()

        path.lineWidth = _lineWidth
        path.lineJoinStyle = .round
        path.lineCapStyle  = .round

        path.stroke()
        
        
    }
    
    func setParameters(radius:CGFloat,arcCenter:CGPoint,startAngle:CGFloat,endAngle:CGFloat,lineWidth:CGFloat)
    {
        _radius = radius
        _arcCenter = arcCenter
        _startAngle = startAngle
        _endAngle = endAngle
        _lineWidth = lineWidth
    }
}
