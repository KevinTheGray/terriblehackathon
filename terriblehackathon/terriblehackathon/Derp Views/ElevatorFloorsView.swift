//
//  ElevatorFloorsView.swift
//  terriblehackathon
//
//  Created by Louis Tur on 2/6/16.
//  Copyright © 2016 terriblehackathon. All rights reserved.
//

import Foundation
import PosseKit
import Cartography

public protocol ElevatorFloorViewDelegate {
  func didChangeFloor(floor: Int)
}

public class ElevatorFloorView : UIView {
  // MARK: - Variables
  var delegate: ElevatorFloorViewDelegate?
  private var currentFloor: Int = 0
  static let iconRect: CGRect = CGRectMake(0.0, 0.0, 60.0, 60.0)
  
  // MARK: - Initializers (including deinit if needed)
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.createViewHierarchy()
    self.configureConstraints()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: - View lifecycle (if required)
  
  // MARK: - Layout
  public func createViewHierarchy() {
    self.addSubview(backgroundView)
    self.backgroundView.addSubview(firstFloorIcon)
    self.backgroundView.addSubview(secondFloorIcon)
    self.backgroundView.addSubview(thirdFloorIcon)
    self.backgroundView.addSubview(fourthFloorIcon)
    self.backgroundView.addSubview(fifthFloorIcon)
    
    self.backgroundView.backgroundColor = UIColor.yellowColor()
  }
  
  public func configureConstraints() {
    
    constrain([backgroundView, firstFloorIcon, secondFloorIcon, thirdFloorIcon, fourthFloorIcon, fifthFloorIcon]){ (views) -> () in
      let background = views[0]
      let first = views[1]
      let second = views[2]
      let third = views[3]
      let fourth = views[4]
      let fifth = views[5]
      
      background.edges == background.superview!.edges
      align(centerY: first, second, third, fourth, fifth, background)
      
      first.width == 50.0
      first.height == first.width
      
      second.size == first.size
      third.size == first.size
      fourth.size == first.size
      fifth.size == first.size
      
      third.centerX == background.centerX
      second.right == third.left - 10.0
      first.right == second.left - 10.0
      
      fourth.left == third.right + 10.0
      fifth.left == fourth.right + 10.0
    }
  }
  // MARK: - Any logic you need
  public func highlightFloor(floor: Int) {
  
  
  }
  
  // MARK: - Actions
  
  // MARK: - Lazy initialization
  lazy var backgroundView: UIView = {
    var view: UIView = UIView()
    return view
  }()
  
  lazy var firstFloorIcon: UIImageView = {
    var view: UIImageView = UIImageView(frame: iconRect)
    view.contentMode = UIViewContentMode.ScaleAspectFit
    let image: UIImage? = UIImage(named: "floor_1")
    image?.tint(color: UIColor.redColor())
    view.image = image
    return view
  }()
  
  lazy var secondFloorIcon: UIImageView = {
    var view: UIImageView = UIImageView(frame: iconRect)
    view.contentMode = UIViewContentMode.ScaleAspectFit
    let image: UIImage? = UIImage(named: "floor_2")
    image?.tint(color: UIColor.redColor())
    view.image = image
    return view
  }()
  
  lazy var thirdFloorIcon: UIImageView = {
    var view: UIImageView = UIImageView(frame: iconRect)
    view.contentMode = UIViewContentMode.ScaleAspectFit
    let image: UIImage? = UIImage(named: "floor_3")
    image?.tint(color: UIColor.redColor())
    view.image = image
    return view
  }()
  
  lazy var fourthFloorIcon: UIImageView = {
    var view: UIImageView = UIImageView(frame: iconRect)
    view.contentMode = UIViewContentMode.ScaleAspectFit
    let image: UIImage? = UIImage(named: "floor_4")
    image?.tint(color: UIColor.redColor())
    view.image = image
    return view
  }()
  
  lazy var fifthFloorIcon: UIImageView = {
    var view: UIImageView = UIImageView(frame: iconRect)
    view.contentMode = UIViewContentMode.ScaleAspectFit
    let image: UIImage? = UIImage(named: "floor_5")
    image?.tint(color: UIColor.redColor())
    view.image = image
    return view
  }()
  
}