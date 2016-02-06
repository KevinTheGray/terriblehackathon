//
//  ConvoHelper.swift
//  terriblehackathon
//
//  Created by Kevin Gray on 2/6/16.
//  Copyright © 2016 terriblehackathon. All rights reserved.
//

import UIKit
import Haitch
import PosseKit

import UIKit
import PosseKit

public class DerpViewController : UIViewController, UITextViewDelegate {
  
  var textEntries: [UILabel] = []
  // MARK: - Initializers
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  // MARK: - View lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBarHidden = false
    self.view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(self.scrollView)
    self.view.addSubview(self.textView)
    self.view.addSubview(self.elevatorFloorView)
    // Bring them to front, or else the tap is NOT registered on the button
    
    var x, y, w, h: CGFloat
    x = 20.0; y = self.view.bounds.maxY - 50.0
    w = self.view.bounds.width - 40.0; h = 50.0
    self.textView.frame = CGRectMake(x, y, w, h)
  }
  
  public override func viewWillAppear(animated: Bool) {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  public override func viewDidDisappear(animated: Bool) {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  public override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let topLayoutLength: CGFloat = self.topLayoutGuide.length
    let viewWidth: CGFloat = self.view.bounds.width
    let viewHeight: CGFloat = self.view.bounds.height
    var x, y, w, h: CGFloat
    
    x = 0.0; y = topLayoutLength; w = viewWidth; h = viewHeight - topLayoutLength - 50.0
    self.scrollView.frame = CGRectMake(x, y, w, h)
  }
  
  public override func viewDidLayoutSubviews() {
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.width, self.contentHeight())
  }
  
  // MARK: - Lazy init
  public lazy var scrollView: UIScrollView = {
    let scrollView: UIScrollView = UIScrollView()
    return scrollView
  }()
  
  private lazy var textView: UITextView = {
    let textView: UITextView = UITextView()
    textView.bounces = false
    textView.font = UIFont.systemFontOfSize(15.0)
    textView.layer.borderColor = UIColor.lightGrayColor().CGColor
    textView.layer.borderWidth = 2.0
    textView.layer.cornerRadius = 4.0
    textView.delegate = self
    return textView
  }()
  
  private lazy var elevatorFloorView: ElevatorFloorView = {
    let floorView: ElevatorFloorView = ElevatorFloorView(frame: CGRectMake(0.0, 0.0, 300.0, 100.0))
    return floorView
  }()
  
  // MARK: - Helper functions
  public func contentHeight() -> CGFloat {
    return 1000.0
  }
  
  // MARK: - TextViewDelegates
  public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if(text == "\n") {
      textView.text = ""
      self.addText(text: "")
      return false
    }
    return true
  }
  
  // HELPER
  public func addText(text text: String) {
    self.view.addSubview(UILabel())
  }
  
  // MARK: - Actions
  public func keyboardWillShow(notification: NSNotification) {
    if let userInfo: NSDictionary = notification.userInfo {
      let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
      let keyboardRectangle = keyboardFrame.CGRectValue()
      let keyboardHeight = keyboardRectangle.height
      let contentInsets = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
      
      var x, y, w, h: CGFloat
      x = 20.0; y = self.view.bounds.maxY - 50.0 - keyboardHeight
      w = self.view.bounds.width - 40.0; h = 50.0
      self.textView.frame = CGRectMake(x, y, w, h)
    }
  }
  
  public func keyboardWillHide(notification: NSNotification) {
    scrollView.contentInset = UIEdgeInsetsZero
    scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    
    var x, y, w, h: CGFloat
    x = 20.0; y = self.view.bounds.maxY - 50.0
    w = self.view.bounds.width - 40.0; h = 50.0
    self.textView.frame = CGRectMake(x, y, w, h)
  }
}