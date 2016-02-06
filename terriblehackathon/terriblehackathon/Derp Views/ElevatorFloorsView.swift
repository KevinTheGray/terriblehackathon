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
  
  // MARK: - Initializers (including deinit if needed)
  override init(frame: CGRect) {
    super.init(frame: frame)
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
  }
  
  public func configureConstraints() {
    
    
    
    
  }
  // MARK: - Any logic you need
  
  // MARK: - Actions
  
  // MARK: - Lazy initialization
  lazy var backgroundView: UIView = {
    var view: UIView = UIView()
    return view
  }()
  
  lazy var firstFloorIcon: UIView = {
    var view: UIView = UIView()
    return view
  }()
  
  lazy var secondFloorIcon: UIView = {
    var view: UIView = UIView()
    return view
  }()
  
  lazy var thirdFloorIcon: UIView = {
    var view: UIView = UIView()
    return view
  }()
  
  lazy var fourthFloorIcon: UIView = {
    var view: UIView = UIView()
    return view
  }()
  
  lazy var fifthFloorIcon: UIView = {
    var view: UIView = UIView()
    return view
  }()
  
}