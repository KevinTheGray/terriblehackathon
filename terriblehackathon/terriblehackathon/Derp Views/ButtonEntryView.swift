//
//  ButtonEntryView.swift
//  terriblehackathon
//
//  Created by Kevin Gray on 2/6/16.
//  Copyright © 2016 terriblehackathon. All rights reserved.
//

import Foundation
import PosseKit
import UIKit
import Cartography

public protocol ButtonEntryViewDelegate {
  func didSelectButton(atIndex atIndex: Int)
}

public class ButtonEntryView : UIView {
  // MARK: - Variables
  var delegate: ButtonEntryViewDelegate?
  private let buttonCount: Int = 4
  private let buttonMargins: CGFloat = 5.0
  private let layoutType: Int = 0 // 0 == 1xcount, 1 == 2xCount
  private var buttons: [Button] = []
  
  // MARK: - Initializers (including deinit if needed)
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.createViewHierarchy()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: - View lifecycle (if required)
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.containerView.frame = self.bounds
    let buttonWidth: CGFloat = floor((self.bounds.width - (self.buttonMargins * 3.0))/2.0)
    let buttonHeight: CGFloat = floor((self.bounds.height - (self.buttonMargins * 3.0))/2.0)
    
    self.buttons[0].frame = CGRectMake(self.buttonMargins, self.buttonMargins, buttonWidth, buttonHeight)
    self.buttons[1].frame = CGRectMake(self.buttons[0].frame.maxX + self.buttonMargins, self.buttonMargins, buttonWidth, buttonHeight)
    self.buttons[2].frame = CGRectMake(self.buttonMargins, self.buttons[0].frame.maxY + self.buttonMargins, buttonWidth, buttonHeight)
    self.buttons[3].frame = CGRectMake(self.buttons[0].frame.maxX + self.buttonMargins, self.buttons[0].frame.maxY + self.buttonMargins, buttonWidth, buttonHeight)
  }
  
  // MARK: - Layout
  public func createViewHierarchy() {
    self.addSubview(containerView)
    self.containerView.backgroundColor = UIColor.yellowColor()
    for index in 0...self.buttonCount - 1 {
      // add a button
      let button: Button = Button()
      self.addSubview(button)
      button.setBackgroundColor(color: UIColor.redColor(), forState: .Normal)
      button.setBackgroundColor(color: UIColor.greenColor(), forState: .Highlighted)
      button.addTarget(self, action: "pressedButton:", forControlEvents: .TouchUpInside)
      button.cornerRadius = 4.0
      button.tag = index
      button.titleLabel.font = UIFont.systemFontOfSize(20.0)
      button.setTitle(title: "Cool", forState: .Normal)
      self.buttons.append(button)
    }
  }
  
  public func configureConstraints() {
  }
  
  // MARK: - Actions
  public func pressedButton(sender: AnyObject?) {
    if let button: Button = sender as? Button {
      print(button.tag)
      self.delegate?.didSelectButton(atIndex: button.tag)
    }
  }
  
  // MARK: - Lazy initialization
  lazy var containerView: UIView = {
    var view: UIView = UIView()
    return view
  }()
}