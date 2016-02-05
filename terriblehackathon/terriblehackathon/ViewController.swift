//
//  ViewController.swift
//  terriblehackathon
//
//  Created by Kevin Gray on 2/5/16.
//  Copyright © 2016 terriblehackathon. All rights reserved.
//

import UIKit
import Haitch
import PosseKit

public class ViewController: UIViewController {

  // MARK: - Variables
  public var gameLoopTimer: NSTimer?
  private var currentRed: CGFloat = 1.0
  private var currentGreen: CGFloat = 0.0
  private var currentBlue: CGFloat = 0.0
  private var loopValueChange: CGFloat = 0.015
  private var hackyFlag: Int = 0
  
  // MARK: - View lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.gameLoopTimer = NSTimer.scheduledTimerWithTimeInterval(0.016, target: self, selector: "gameLoop:", userInfo: nil, repeats: true)
  }
  
  public override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  deinit {
    print("GONE")
  }
  
  // MARK: - Actions
  public func gameLoop(sender: AnyObject?) {
    self.view.backgroundColor = UIColor(red: self.currentRed, green: self.currentGreen, blue: self.currentBlue, alpha: 1.0)
    print("R: \(currentRed) G: \(currentGreen) B: \(currentBlue)")
    if hackyFlag == 0 {
      //Move red to 0.0, move green to 1.0
      currentRed -= self.loopValueChange
      currentGreen += self.loopValueChange
      if currentRed <= 0.0 {
        currentRed = 0.0
        currentGreen = 1.0
        hackyFlag = 1
      }
    } else if hackyFlag == 1 {
      //Move green to 0.0, move blue to 1.0
      currentGreen -= self.loopValueChange
      currentBlue += self.loopValueChange
      if currentGreen <= 0.0 {
        currentGreen = 0.0
        currentBlue = 1.0
        hackyFlag = 2
      }
    } else if hackyFlag == 2 {
      //Move blue to 0.0, move red to 1.0
      currentBlue -= self.loopValueChange
      currentRed += self.loopValueChange
      if currentBlue <= 0.0 {
        currentBlue = 0.0
        currentRed = 1.0
        hackyFlag = 0
      }
    }
  }


}

