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
  func didSelectFloor(floor: Int)
}

public class ElevatorFloorView : UIView {
  // MARK: - Variables
  var delegate: ElevatorFloorViewDelegate?
  private var currentFloor: Int = 0
  static let iconRect: CGRect = CGRectMake(0.0, 0.0, 60.0, 60.0)
  static let highlightedColor: UIColor = UIColor.yellowColor()
  var buttons: [Button] = []
  
  // MARK: - Initializers (including deinit if needed)
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.currentFloor = 1
    
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
    self.backgroundView.addSubview(firstFloorButton)
    self.buttons.append(firstFloorButton)
    self.backgroundView.addSubview(secondFloorButton)
    self.buttons.append(secondFloorButton)
    self.backgroundView.addSubview(thirdFloorButton)
    self.buttons.append(thirdFloorButton)
    self.backgroundView.addSubview(fourthFloorButton)
    self.buttons.append(fourthFloorButton)
    self.backgroundView.addSubview(fifthFloorButton)
    self.buttons.append(fifthFloorButton)

    self.backgroundView.backgroundColor = UIColor.lightGrayColor()
  }
  
  public func configureConstraints() {
    
    constrain([backgroundView, firstFloorButton, secondFloorButton, thirdFloorButton, fourthFloorButton, fifthFloorButton]){ (views) -> () in
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
  
  // MARK: - Actions
  
  // MARK: - Lazy initialization
  lazy var backgroundView: UIView = {
    var view: UIView = UIView()
    return view
  }()
  
  lazy var firstFloorButton: Button = {
    var view: Button = Button(frame: iconRect)
    view.contentMode = UIViewContentMode.ScaleAspectFit
    let image: UIImage? = UIImage(named: "floor_1")
    let imageHighlighted: UIImage? = UIImage(named: "floor_1")?.tint(color: highlightedColor)
    view.setImage(image: image!, forState: .Normal)
    view.setImage(image: imageHighlighted!, forState: .Highlighted)
    view.setImage(image: imageHighlighted!, forState: .Selected)
    view.addTarget(self, action: "pressedButton:", forControlEvents: .TouchUpInside)
    view.tag = 0
    view.selected = true
    return view
  }()
  
  lazy var secondFloorButton: Button = {
    var view: Button = Button(frame: iconRect)
    view.contentMode = UIViewContentMode.ScaleAspectFit
    let image: UIImage? = UIImage(named: "floor_2")
    let imageHighlighted: UIImage? = UIImage(named: "floor_2")?.tint(color: highlightedColor)
    view.setImage(image: image!, forState: .Normal)
    view.setImage(image: imageHighlighted!, forState: .Highlighted)
    view.setImage(image: imageHighlighted!, forState: .Selected)
    view.addTarget(self, action: "pressedButton:", forControlEvents: .TouchUpInside)
    view.tag = 1
    return view
  }()
  
  lazy var thirdFloorButton: Button = {
    var view: Button = Button(frame: iconRect)
    view.contentMode = UIViewContentMode.ScaleAspectFit
    let image: UIImage? = UIImage(named: "floor_3")
    let imageHighlighted: UIImage? = UIImage(named: "floor_3")?.tint(color: highlightedColor)
    view.setImage(image: image!, forState: .Normal)
    view.setImage(image: imageHighlighted!, forState: .Highlighted)
    view.setImage(image: imageHighlighted!, forState: .Selected)
    view.addTarget(self, action: "pressedButton:", forControlEvents: .TouchUpInside)
    view.tag = 2
    return view
  }()
  
  lazy var fourthFloorButton: Button = {
    var view: Button = Button(frame: iconRect)
    view.contentMode = UIViewContentMode.ScaleAspectFit
    let image: UIImage? = UIImage(named: "floor_4")
    let imageHighlighted: UIImage? = UIImage(named: "floor_4")?.tint(color: highlightedColor)
    view.setImage(image: image!, forState: .Normal)
    view.setImage(image: imageHighlighted!, forState: .Highlighted)
    view.setImage(image: imageHighlighted!, forState: .Selected)
    view.addTarget(self, action: "pressedButton:", forControlEvents: .TouchUpInside)
    view.tag = 3
    return view
  }()
  
  lazy var fifthFloorButton: Button = {
    var view: Button = Button(frame: iconRect)
    view.contentMode = UIViewContentMode.ScaleAspectFit
    let image: UIImage? = UIImage(named: "floor_5")
    let imageHighlighted: UIImage? = UIImage(named: "floor_5")?.tint(color: highlightedColor)
    view.setImage(image: image!, forState: .Normal)
    view.setImage(image: imageHighlighted!, forState: .Highlighted)
    view.setImage(image: imageHighlighted!, forState: .Selected)
    view.addTarget(self, action: "pressedButton:", forControlEvents: .TouchUpInside)
    view.tag = 4
    return view
  }()
  
  lazy var highlightedView: UIView = {
    let view: UIView = UIView(frame: CGRectMake(0.0, 0.0, 40.0, 40.0))
    view.backgroundColor = UIColor.redColor()
    return view
  }()
  
  public func pressedButton(sender: AnyObject?) {
    if let passedInButton: Button = sender as? Button {
      for button in buttons {
        button.selected = (button == passedInButton)
      }
      self.delegate?.didSelectFloor(passedInButton.tag + 1)
    }
  }
  
}