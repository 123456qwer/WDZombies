//
//  WDAudioPlayer.swift
//  WDZombies
//
//  Created by wudong on 2018/3/7.
//  Copyright © 2018年 吴冬. All rights reserved.
//

import UIKit
import AVFoundation

class WDSkillMusicPlayer {

    var player:AVAudioPlayer!
    
    //技能名称
    let blink = "ox_flash"
    let speed = "fire_skill"
    let dun   = "dun_skill"
    let boom  = "boom_skill"
    
    //普通僵尸
    let normalZomAppear = "zom_apper_music"
    let normalZomAttack = "zom_attack"
    let normalZomDied      = "zom_died"
    let redZomAttack = "red_zom_attack"
    
    
    /// 只执行一次，声音固定为1
    func playWithName(musicName:String){
        
        let music_name =  Bundle.main.url(forResource: musicName, withExtension: "mp3")!
        try! player = AVAudioPlayer (contentsOf: music_name)
        player.volume = 1
        player.numberOfLoops = 0
        player.prepareToPlay()
        player.play()
    }
    
    
    /// 自定义时间，声音大小
    func playWithName(musicName:String,volume:Float,numberOfLoops:Int){
        
        let music_name =  Bundle.main.url(forResource: musicName, withExtension: "mp3")!
        try! player = AVAudioPlayer (contentsOf: music_name)
        player.volume = volume
        player.numberOfLoops = numberOfLoops
        player.prepareToPlay()
        player.play()
    }
    
    deinit {
        //WDLog(item: "音乐技能被销毁了！")
    }
}
