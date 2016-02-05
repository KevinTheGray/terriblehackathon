//
//  KeyboardLayoutConstraint.swift
//  PosseKit
//
//  Created by Posse in NYC
//  http://goposse.com
//
//  Copyright (c) 2015 Posse Productions LLC.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//  * Neither the name of the Posse Productions LLC, Posse nor the
//    names of its contributors may be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL POSSE PRODUCTIONS LLC (POSSE) BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//


import Foundation
import UIKit


public class KeyboardLayoutConstraint : NSLayoutConstraint {
  
  private var keyboardHeight: CGFloat = 0.0
  
  
  // MARK: - Initialization
  public override init() {
    super.init()
    self.registerNotifications()
  }
  
  deinit {
    let notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.removeObserver(self)
  }

  
  public class func layoutFor(view view: UIView) -> KeyboardLayoutConstraint  {
    return layoutFor(view: view, bottomOffset: 0.0)
  }

  public class func layoutFor(view view: UIView, bottomOffset: CGFloat) -> KeyboardLayoutConstraint  {
    return KeyboardLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal,
      toItem: view.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: bottomOffset)
  }

  
  // MARK: - Notifications
  func registerNotifications() {
    let notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: "willShowKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
    notificationCenter.addObserver(self, selector: "willHideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func willShowKeyboard(sender: AnyObject?) {
    if let notification: NSNotification = sender as? NSNotification {
      if let userInfo = notification.userInfo {
        if let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
          let keyboardFrame: CGRect = keyboardFrameValue.CGRectValue()
          self.keyboardHeight = keyboardFrame.size.height
        }
        self.constant = -1.0 * keyboardHeight
        
        if let animDuration: NSNumber = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
          animCurve: NSNumber = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            let animOptions: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animCurve.unsignedLongValue)
            UIView.animateWithDuration(animDuration.doubleValue, delay: 0.0, options: animOptions,
              animations: { () -> Void in
                UIApplication.sharedApplication().keyWindow?.layoutIfNeeded()
              }, completion: nil)
        }
      }
    }
  }

  func willHideKeyboard(sender: AnyObject?) {
    if let notification: NSNotification = sender as? NSNotification {
      self.keyboardHeight = 0.0
      self.constant = 0.0
      if let userInfo = notification.userInfo {
        if let animDuration: NSNumber = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
          animCurve: NSNumber = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            let animOptions: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animCurve.unsignedLongValue)
            UIView.animateWithDuration(animDuration.doubleValue, delay: 0.0, options: animOptions,
              animations: { () -> Void in
                UIApplication.sharedApplication().keyWindow?.layoutIfNeeded()
              }, completion: nil)
        }
      }
    }
  }

}
