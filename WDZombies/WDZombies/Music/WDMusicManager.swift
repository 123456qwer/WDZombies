//
//  WDMusicManager.swift
//  WDZombies
//
//  Created by wudong on 2018/3/5.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import SpriteKit
//引入多媒体框架
import AVFoundation

class WDMusicManager: SKNode {
    //申明一个播放器
    var bgMusicPlayer = AVAudioPlayer()
    //播放点击的动作音效
    let hitAct = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    //播放背景音乐的音效
    func playBackGround(){
        print("开始播放背景音乐!")
        //获取bg.mp3文件地址
        let bgMusicURL =  Bundle.main.url(forResource: "bg", withExtension: "mp3")!
        //根据背景音乐地址生成播放器
        try! bgMusicPlayer = AVAudioPlayer (contentsOf: bgMusicURL)
        //设置为循环播放(
        bgMusicPlayer.numberOfLoops = -1
        //准备播放音乐
        bgMusicPlayer.prepareToPlay()
        //播放音乐
        bgMusicPlayer.play()
    }
    
    //播放点击音效动作的方法
    func playHit(){
        print("播放音效!")
        self.run(hitAct)
    }
}
