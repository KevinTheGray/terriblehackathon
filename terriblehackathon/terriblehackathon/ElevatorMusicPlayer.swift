//
//  ElevatorMusicPlayer.swift
//  terriblehackathon
//
//  Created by Louis Tur on 2/6/16.
//  Copyright © 2016 terriblehackathon. All rights reserved.
//

import Foundation
import PosseKit
import AVKit
import AVFoundation

public class ElevatorMusicPlayer {
  
  public static var player: ElevatorMusicPlayer = ElevatorMusicPlayer()
  private var player: AVAudioPlayer?
  
  private init() {
  }
  
  public func loadElevatorMusic() {
    if let trackFilePath: NSURL = NSBundle.mainBundle().URLForResource("Atomic Paths", withExtension: "mp3") {
      do {
        self.player = try AVAudioPlayer(contentsOfURL: trackFilePath)
        self.player!.numberOfLoops = -1
      }
      catch {
        print("Error: \(error)")
      }
    }
  }
  
  public func playElevatorMusic() {
    if player != nil {
      player!.play()
    }
  }
  
}