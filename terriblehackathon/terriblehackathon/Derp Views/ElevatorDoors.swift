//
//  ElevatorDoors.swift
//  terriblehackathon
//
//  Created by Louis Tur on 2/6/16.
//  Copyright © 2016 terriblehackathon. All rights reserved.
//

import Foundation
import UIKit
import Cartography

public class ElevatorDoors: UIView {
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    self.constructViewHierarchy()
    self.configureConstraints()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func constructViewHierarchy() {
    self.backgroundColor = UIColor.clearColor()
    self.addSubview(self.backgroundView)
    self.backgroundView.addSubview(self.leftDoorView)
    self.backgroundView.addSubview(self.rightDoorView)
  }
  
  private func configureConstraints() {
    constrain([leftDoorView, rightDoorView, backgroundView]) { (views) -> () in
      let leftDoor = views[0]
      let rightDoor = views[1]
      let background = views[2]
      
      background.edges == background.superview!.edges
      leftDoor.width == Constants.Screen.Width / 2.0
      leftDoor.height == background.height
      rightDoor.height == leftDoor.height
      rightDoor.width == leftDoor.width
      
      leftDoor.top == background.top
      rightDoor.top == background.top
      leftDoor.bottom == background.bottom
      rightDoor.bottom == background.bottom
      
      leftDoor.left == background.left
      rightDoor.left == leftDoor.right
      rightDoor.right == background.right
      
    }
  }
  
  public func openDoors(completionBlock: (Bool) -> Void) {
    let currentLeftDoorFrame: CGRect = self.leftDoorView.frame
    let currentRightDoorFrame: CGRect = self.rightDoorView.frame
//    UIView.animateWithDuration(0.75) { () -> Void in
//      self.leftDoorView.frame = CGRectMake(-currentLeftDoorFrame.size.width, 0.0, currentLeftDoorFrame.size.width, currentLeftDoorFrame.size.height)
//      self.rightDoorView.frame = CGRectMake(currentRightDoorFrame.size.width * 2, 0.0, currentRightDoorFrame.size.width, currentRightDoorFrame.size.height)
//    }
    
    UIView.animateWithDuration(0.75, animations: { () -> Void in
      self.leftDoorView.frame = CGRectMake(-currentLeftDoorFrame.size.width, 0.0, currentLeftDoorFrame.size.width, currentLeftDoorFrame.size.height)
      self.rightDoorView.frame = CGRectMake(currentRightDoorFrame.size.width * 2, 0.0, currentRightDoorFrame.size.width, currentRightDoorFrame.size.height)

      }, completion: completionBlock)
  }
  
  public func closeDoors() {
    let currentLeftDoorFrame: CGRect = self.leftDoorView.frame
    let currentRightDoorFrame: CGRect = self.rightDoorView.frame
    UIView.animateWithDuration(0.75) { () -> Void in
      self.leftDoorView.frame = CGRectMake(0.0, 0.0, currentLeftDoorFrame.size.width, currentLeftDoorFrame.size.height)
      self.rightDoorView.frame = CGRectMake(currentRightDoorFrame.size.width, 0.0, currentRightDoorFrame.size.width, currentRightDoorFrame.size.height)
    }
  }
  
  lazy var leftDoorView: UIView = {
    let view: UIView = UIView()
    view.backgroundColor = UIColor.blueColor()
    return view
  }()
  
  lazy var rightDoorView: UIView = {
    let view: UIView = UIView()
    view.backgroundColor = UIColor.blueColor()
    return view
  }()
  
  lazy var backgroundView: UIView = {
    let view: UIView = UIView()
    return view
  }()
  
}