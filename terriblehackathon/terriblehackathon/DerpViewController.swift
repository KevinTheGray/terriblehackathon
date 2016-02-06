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

public class DerpViewController : UIViewController, UITextViewDelegate, ButtonEntryViewDelegate, ElevatorFloorViewDelegate {
  
  
  private struct textEntryStruct  {
    static let USER: Int = 0
    static let NOT_USER: Int = 1
    static let STORY: Int = 2
  }
  
  private var textEntryMaxWidth: CGFloat = 200.0
  private var currentContentHeight: CGFloat = 10.0
  private var playerColor: UIColor = UIColor(hex: 0x00A6FF)
  private var notPlayerColor: UIColor = UIColor(hex: 0xDBDBDB)
  private var storyColor: UIColor = UIColor(hex: 0xEB7D42)
  private var buttonEntryViewHeight: CGFloat = 140.0
  public var elevatorTimer: NSTimer?
  public var currentFloor: Int = 1
  public var destinationFloor: Int = 1
  
  private var randomEncounter: RandomEncounter = RandomEncounter.createEncounter(EncounterType.NPCEntersElevator, event: EncounterEvent.AudibleFart, withNPC: EncounterNPC.cat())
  
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
    self.view.addSubview(self.buttonEntryView)
    self.view.addSubview(self.elevatorFloorView)
    // Bring them to front, or else the tap is NOT registered on the button
    self.addText(text: "You are in an elevator, you are on the first floor.", textAddedBy: textEntryStruct.STORY)
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
    
    x = 0.0; y = self.elevatorFloorView.frame.maxY + topLayoutLength; w = viewWidth;
    h = viewHeight - self.elevatorFloorView.bounds.height - topLayoutLength - 10.0 - self.buttonEntryViewHeight
    self.scrollView.frame = CGRectMake(x, y, w, h)
    x = 0.0; y = self.view.bounds.maxY - self.buttonEntryViewHeight
    w = self.view.bounds.width; h = self.buttonEntryViewHeight
    self.buttonEntryView.frame = CGRectMake(x, y, w, h)
  }
  
  public override func viewDidLayoutSubviews() {
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.width, self.contentHeight())
  }
  
  // MARK: - Lazy init
  public lazy var scrollView: UIScrollView = {
    let scrollView: UIScrollView = UIScrollView()
    return scrollView
  }()
  
  private lazy var buttonEntryView: ButtonEntryView = {
    let buttonEntryView: ButtonEntryView = ButtonEntryView()
    buttonEntryView.delegate = self
    return buttonEntryView
  }()
  
  private lazy var elevatorFloorView: ElevatorFloorView = {
    let floorView: ElevatorFloorView = ElevatorFloorView(frame: CGRectMake(0.0, 0.0, Constants.Screen.Width, 100.0))
    floorView.delegate = self
    return floorView
  }()
  
  // MARK: - Helper functions
  public func contentHeight() -> CGFloat {
    return currentContentHeight
  }
  
  public func didSelectButton(atIndex atIndex: Int) {
    addText(text: "BALKFJASLKFJALK", textAddedBy: self.textEntries.count % 3)
  }
  
  public func didSelectFloor(floor: Int) {
    addText(text: "You selected floor \(floor)", textAddedBy: textEntryStruct.USER)
    self.destinationFloor = floor
    if self.destinationFloor == self.currentFloor {
      self.addText(text: "You reached floor \(self.currentFloor).", textAddedBy: textEntryStruct.STORY)
    } else {
      self.elevatorTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "elevatorReachedFloor:", userInfo: nil, repeats: true)
    }
  }
  
  // HELPER
  public func addText(text text: String, textAddedBy: Int) {
    let label: UILabel = UILabel()
    label.font = UIFont.systemFontOfSize(18.0)
    label.layer.cornerRadius = 4.0
    label.layer.masksToBounds = true
    label.numberOfLines = 0
    self.textEntries.append(label)
    let labelSize: CGSize = label.font.sizeOfString(text, constrainedToWidth: Double(self.textEntryMaxWidth), lineCount: 0)
    
    if textAddedBy == textEntryStruct.USER {
      label.frame = CGRectMake(20.0, self.currentContentHeight, labelSize.width + 10.0, labelSize.height + 20.0)
      currentContentHeight += labelSize.height + 20.0 + 10.0
      label.backgroundColor = self.playerColor
      label.text = text
    } else if textAddedBy == textEntryStruct.NOT_USER  {
      label.textAlignment = .Right
      label.frame = CGRectMake(self.view.bounds.width - 20.0 - labelSize.width - 10.0, self.currentContentHeight, labelSize.width + 10.0, labelSize.height + 20.0)
      currentContentHeight += labelSize.height + 20.0 + 10.0
      label.backgroundColor = self.notPlayerColor
      label.text = text
    }
    else if textAddedBy == textEntryStruct.STORY  {
      label.textAlignment = .Center
      label.frame = CGRectMake(self.view.bounds.midX - labelSize.width/2.0 - 5.0, self.currentContentHeight, labelSize.width + 10.0, labelSize.height + 20.0)
      currentContentHeight += labelSize.height + 20.0 + 10.0
      label.backgroundColor = self.storyColor
      label.text = text
    }
    
    self.scrollView.addSubview(label)
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.width, self.contentHeight())
    self.scrollView.scrollRectToVisible(label.frame, animated: true)
  }
  
  public func elevatorReachedFloor(sender: AnyObject?) {
    if self.currentFloor > self.destinationFloor {
      self.currentFloor--
    } else if self.currentFloor < self.destinationFloor {
      self.currentFloor++
    }
    self.elevatorFloorView.setButtonSelected(atIndex: self.currentFloor - 1)
    if self.currentFloor == self.destinationFloor {
      self.addText(text: "You reached floor \(self.currentFloor).", textAddedBy: textEntryStruct.STORY)
      self.elevatorTimer?.invalidate()
      self.elevatorTimer = nil
    } else {
      self.addText(text: "You passed floor \(self.currentFloor).", textAddedBy: textEntryStruct.STORY)
    }
  }
}