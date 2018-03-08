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

class WDMusicManager {
    
    static let shareInstance = WDMusicManager.init()
    private init() {
        self.moveMusic()
    
    }
   
    //人物相关音乐
    let levelUp = "level_up"
    
    //游戏关卡相关
    let game_over = "game_over"
    let game_next = "game_next"
    let btn_music = "btn"
    let btn_fire_music = "fire"
    
    
    //怪物相关音乐
    /*普通僵尸*/
    
    /*骷髅僵尸*/
    let kulou_attack = "kulou_attack"
    let kulou_died   = "kulou_died"
    
    
    /*公牛*/
    let ox_flash_attack = "ox_flash"
    

    
    var gamePlayer:AVAudioPlayer!   //游戏关卡相关
    var btn1Player:AVAudioPlayer!   //按钮1
    var btn2Player:AVAudioPlayer!   //按钮2
    var btn3Player:AVAudioPlayer!   //按钮3
    var btn4Player:AVAudioPlayer!   //按钮4
    var firePlayer:AVAudioPlayer!   //攻击按钮
    
    
    var movePlayer:AVAudioPlayer!    //人物移动
    
    var musicPlayer:AVAudioPlayer!   //人物
    var zomPlayer:AVAudioPlayer!     //普通僵尸
    var redZomPlayer:AVAudioPlayer!  //红头僵尸
    var kulouPlayer:AVAudioPlayer!   //骷髅僵尸
    var greenZomPlayer:AVAudioPlayer! //绿色僵尸
    var smokeKnightPlayer:AVAudioPlayer! //雾骑士
    var squidPlayer:AVAudioPlayer!    //鱿鱼
    var kulouKnightPlayer:AVAudioPlayer! //骷髅骑士
    var oxPlayer:AVAudioPlayer!      //牛
    var sealPlayer:AVAudioPlayer!    //海狮
    var dogPlayer:AVAudioPlayer!     //狗
    
    
    //声音限定次数，否则会卡顿，crash
    /*骷髅相关*/
    var kulouAttackNumber:Int = 0
    var kulouDiedNumber:Int   = 0
    var kulouAttackMax:Int    = 2
    var kulouDiedMax:Int      = 2
    
    /*普通僵尸相关*/
    var normalZomAttackNumber:Int = 0
    var normalZomDiedNumber:Int   = 0
    var normalZomAttackMax:Int    = 2
    var normalZomDiedMax:Int      = 2
    
    /*牛*/
    var flashAttackNumber:Int = 0
    var flashAttackMax:Int    = 2
    
    
    //人物相关
    func moveMusic()  {
//      let music_name =  Bundle.main.url(forResource: "move", withExtension: "mp3")!
//      try! movePlayer = AVAudioPlayer (contentsOf: music_name)
//      movePlayer.volume = 0
//      movePlayer.numberOfLoops = -1
//      movePlayer.prepareToPlay()
    
    }
    
    func stopMove() {
        //movePlayer.pause()
    }
    
    func continueMove(){
        //movePlayer.play()
    }
    
    /// 根据类型创建player
    func playerIndexAndMusicName(type:zomType,musicName:String,numberOfLoops:Int,volume:Float) {
        //获取bg.mp3文件地址
        let music_name =  Bundle.main.url(forResource: musicName, withExtension: "mp3")!
        var player:AVAudioPlayer!
        
        
        if type == .Normal{

            try! zomPlayer = AVAudioPlayer (contentsOf: music_name)
            player = zomPlayer
            
        }else if type == .Red{
           
            try! redZomPlayer = AVAudioPlayer (contentsOf: music_name)
            player = redZomPlayer
            
        }else if type == .kulou{
           
            try! kulouPlayer = AVAudioPlayer (contentsOf: music_name)
            player = kulouPlayer

        }else if type == .GreenZom{
          
            try! greenZomPlayer = AVAudioPlayer (contentsOf: music_name)
            player = greenZomPlayer

        }else if type == .kNight{
            
            try! smokeKnightPlayer = AVAudioPlayer (contentsOf: music_name)
            player = smokeKnightPlayer

            
        }else if type == .Squid{
          
            try! squidPlayer = AVAudioPlayer (contentsOf: music_name)
            player = squidPlayer
            
        }else if type == .ox{
       
            try! oxPlayer = AVAudioPlayer (contentsOf: music_name)
            player = oxPlayer
            
        }else if type == .kulouKnight{
            
            try! kulouKnightPlayer = AVAudioPlayer (contentsOf: music_name)
            player = kulouKnightPlayer
            
        }else if type == .seal{
         
            try! sealPlayer = AVAudioPlayer (contentsOf: music_name)
            player = sealPlayer
            
        }else if type == .dog{
        
            try! dogPlayer = AVAudioPlayer (contentsOf: music_name)
            player = dogPlayer
        }else if type == .player{
            
            try! musicPlayer = AVAudioPlayer (contentsOf: music_name)
            player = musicPlayer
            
        }else if type == .game{
            
            try! gamePlayer = AVAudioPlayer (contentsOf: music_name)
            player = gamePlayer
            
        }else if type == .btn1{
            try! btn1Player = AVAudioPlayer (contentsOf: music_name)
            player = btn1Player
        }else if type == .btn2{
            try! btn2Player = AVAudioPlayer (contentsOf: music_name)
            player = btn2Player
        }else if type == .btn3{
            try! btn3Player = AVAudioPlayer (contentsOf: music_name)
            player = btn3Player
        }else if type == .btn4{
            try! btn4Player = AVAudioPlayer (contentsOf: music_name)
            player = btn4Player
        }else if type == .btn0{
            try! firePlayer = AVAudioPlayer (contentsOf: music_name)
            player = firePlayer
        }
        
        self.playWithPlayer(player: player,numberOfLoops: numberOfLoops,volume: volume)
    }
    
    
    
    
    func playWithPlayer(player:AVAudioPlayer,numberOfLoops:Int,volume:Float){
        
        //声音大小
        player.volume = volume
        //循环次数
        player.numberOfLoops = numberOfLoops
        //准备播放音乐
        player.prepareToPlay()
        //播放音乐
        player.play()
    }
    
  
}
