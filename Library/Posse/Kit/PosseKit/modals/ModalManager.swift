//
//  ModalManager.swift
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

import UIKit

// MARK: - Enums
public enum ModalPresentationStyle {
  case FromBottom
  case FromTop
  case Custom
}


// MARK: - Type aliases
public typealias ModalCallback = () -> Void
public typealias ModalPresentationOptions = (shouldPresent: Bool, animated: Bool)
public typealias ModalDismissalOptions = (shouldDismiss: Bool, animated: Bool)


public struct ModalConfig {
  public static let NoAlpha: (startAlpha: Double, endAlpha: Double) = (1.0, 1.0)
  public static let DefaultPresentationAnimated: ModalPresentationOptions = (shouldPresent: true, animated: true)
  public static let DefaultDismissalAnimated: ModalDismissalOptions = (shouldDismiss: true, animated: true)
}


// MARK: - Modal manager class
public class ModalManager : NSObject {
  
  private var notificationCenter: NSNotificationCenter!
  private var modalStack: [ModalInfo] = []

  
  // MARK: - Lazy initialization
  internal lazy var overlayView: UIView = {
    var view: UIView = UIView()
    view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
    view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    view.addGestureRecognizer(self.overlayTapRecognizer)
    return view
  }()
  
  internal lazy var overlayTapRecognizer: UITapGestureRecognizer = {
    var recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedOverlay:")
    return recognizer
  }()
  
  
  // MARK: - Initialization
  public override init() {
    notificationCenter = NSNotificationCenter.defaultCenter()
  }
  
  deinit {
    unregisterNotifications()
  }
  
  
  // MARK: - Singleton
  public static let manager: ModalManager = {
    var modalManager: ModalManager = ModalManager()
    return modalManager
  }()
  
  
  // MARK: - Notification registration
  private func registerNotifications() {
    notificationCenter.addObserver(self, selector: "willShowKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
    notificationCenter.addObserver(self, selector: "willHideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func unregisterNotifications() {
    notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  
  // MARK: - Modal check functions
  public func isShowingModal() -> Bool {
    return self.modalStack.count > 0
  }
  
  
  // MARK: - Show/hide animation functions
  private func push(modal: ModalInfo, animated: Bool, callback: ModalCallback?) {
      
    unregisterNotifications()
    registerNotifications()
    
    let parentViewController: UIViewController = modal.presentingViewController!

    let viewController: UIViewController = modal.viewController
    
    parentViewController.viewWillDisappear(animated)
    
    var showOverlay: Bool = false
    var animateOverlay: Bool = true
    var duration: NSTimeInterval = 0.28
    var alphaStart: Double = 1.0
    var alphaEnd: Double = 1.0
    let overlayAlphaStart: Double = -1.0
    let overlayAlphaEnd: Double = -1.0
    
    if modal.conformsToModal {
      let modal: Modal = (viewController as! Modal)
      duration = modal.animationDurations().startDuration
      alphaStart = modal.transitionAlphas().startAlpha
      alphaEnd = modal.transitionAlphas().endAlpha
      let overlayPresentationOptions: ModalPresentationOptions = modal.showModalOverlay()
      showOverlay = overlayPresentationOptions.shouldPresent
      animateOverlay = overlayPresentationOptions.animated
    }
    
    if showOverlay {
      self.showOverlay(animated: animateOverlay, alphaStart: overlayAlphaStart, alphaEnd: overlayAlphaEnd)
    }

    keyWindow()!.addSubview(viewController.view)
    viewController.view.frame = self.startingRect(viewController: viewController,
      style: modal.presentedMode)
    
    viewController.view.alpha = CGFloat(alphaStart)
    
    viewController.viewWillAppear(animated)
    
    if !animated {
      duration = 0.0
    }
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      viewController.setNeedsStatusBarAppearanceUpdate()
      viewController.view.alpha = CGFloat(alphaEnd)
      viewController.view.frame = self.endingRect(viewController: viewController,
        style: modal.presentedMode)
    }) { (completed: Bool) -> Void in
      parentViewController.viewDidDisappear(animated)
      viewController.viewDidAppear(animated)
      if callback != nil {
        callback!()
      }
    }
  }

  private func pop(to position: Int, animated: Bool, callback: ModalCallback?) {

    let hideModal: ModalInfo? = self.modalStack.last
    if hideModal == nil {
      return    // cant find modal to dismiss so we're out
    }

    var superViewController: UIViewController!
    
    if position != self.modalStack.count - 1 {
      for idx: Int in position...self.modalStack.count - 2 {
        let removeModal: ModalInfo = self.modalStack[idx]
        let removeViewController: UIViewController = removeModal.viewController
        if idx == position {
          superViewController = removeModal.presentingViewController
        }
        removeViewController.view.removeFromSuperview()
      }
    }
    
    let viewController: UIViewController = hideModal!.viewController

    var duration: NSTimeInterval = 0.28
    var alphaEnd: Double = 1.0
    if hideModal!.conformsToModal {
      let modal: Modal = (viewController as! Modal)
      duration = modal.animationDurations().endDuration
      alphaEnd = modal.transitionAlphas().startAlpha
    }
    
    if superViewController == nil {
      superViewController = hideModal!.presentingViewController!
    }
    
    viewController.viewWillDisappear(animated)

    self.modalStack.removeDownTo(index: position)
    
    var movingToSuperView: Bool = false
    
    if self.modalStack.count == 0 {
      self.unregisterNotifications()
      if self.overlayView.superview != nil {
        self.hideOverlay(animated: animated)
      }
      movingToSuperView = true
    } else {
      let nextModalInfo: ModalInfo = self.modalStack.last!
      movingToSuperView = (nextModalInfo.viewController == hideModal!.presentingViewController)
      if nextModalInfo.conformsToModal {
        let modal: Modal = (nextModalInfo.viewController as! Modal)
        let overlayPresentationOptions: ModalPresentationOptions = modal.showModalOverlay()
        let animateOverlay: Bool = overlayPresentationOptions.animated
        if overlayPresentationOptions.shouldPresent {
          if self.overlayView.superview == nil {
            self.showOverlay(animated: animateOverlay, alphaStart: 0.0, alphaEnd: 1.0)
            nextModalInfo.viewController.view.superview?
              .insertSubview(self.overlayView, belowSubview: nextModalInfo.viewController.view)
          } else {
            self.overlayView.removeFromSuperview()
            nextModalInfo.viewController.view.superview?
              .insertSubview(self.overlayView, belowSubview: nextModalInfo.viewController.view)
          }
        } else {
          self.hideOverlay(animated: animated)
        }
      } else {
        self.hideOverlay(animated: animated)
      }
    }
    
    if movingToSuperView {
      superViewController.viewWillAppear(animated)
      superViewController.setNeedsStatusBarAppearanceUpdate()
    }
    
    if !animated {
      duration = 0.0
    }
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      viewController.view.alpha = CGFloat(alphaEnd)
      viewController.view.frame = self.startingRect(viewController: viewController, style: hideModal!.presentedMode)
    }) { (completed: Bool) -> Void in
      viewController.view.removeFromSuperview()
      viewController.viewDidDisappear(animated)
      if movingToSuperView {
        superViewController.viewDidAppear(animated)
      }
      if callback != nil {
        callback!()
      }
    }
  }

  
  // MARK: - Overlay state management
  private func showOverlay(animated animated: Bool, alphaStart: Double, alphaEnd: Double) {
    self.overlayView.alpha = CGFloat(max(alphaStart, 0.3))
    if self.overlayView.superview == nil {
      keyWindow()!.addSubview(self.overlayView)
    }
    self.overlayView.superview?.bringSubviewToFront(self.overlayView)
    self.overlayView.frame = keyWindow()!.bounds

    var duration: NSTimeInterval = 0.0
    if animated {
      duration = 0.18
    }

    var outAlpha: Double = alphaEnd
    if outAlpha == -1.0 {
      outAlpha = 1.0
    }
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      self.overlayView.alpha = CGFloat(outAlpha)
    })
  }
  
  private func hideOverlay(animated animated: Bool) {

    var duration: NSTimeInterval = 0.0
    if animated {
      duration = 0.1
    }
    UIView.animateWithDuration(duration, animations: { () -> Void in
      self.overlayView.alpha = 0.0
    }) { (completed: Bool) -> Void in
      self.overlayView.removeFromSuperview()
    }
  }
  
  
  // MARK: - Present/dismiss methods
  public func present(viewController: UIViewController) {
    present(viewController, style: .Custom, animated: true, callback: nil)
  }
  
  public func present(viewController: UIViewController, animated: Bool, callback: ModalCallback?) {
    present(viewController, style: .Custom, animated: animated, callback: callback)
  }
  
  public func present(viewController: UIViewController, style: ModalPresentationStyle, animated: Bool,
    callback: ModalCallback?) {
      
      var parentViewController: UIViewController = keyWindow()!.rootViewController!
      if self.modalStack.count > 0 {
        parentViewController = self.modalStack.last!.viewController
      }
      if let navigationController: UINavigationController = parentViewController as? UINavigationController {
        if navigationController.visibleViewController != nil {
          parentViewController = navigationController.visibleViewController!
        }
      }
      present(viewController, onto: parentViewController, style: style, animated: animated, callback: callback)
  }

  public func present(viewController: UIViewController, onto parentViewController: UIViewController, style: ModalPresentationStyle, animated: Bool,
    callback: ModalCallback?) {
      let modal: ModalInfo = ModalInfo(viewController: viewController, presentedMode: style)
      modal.presentingViewController = parentViewController
      modalStack.append(modal)
      push(modal, animated: animated, callback: callback)
  }
  
  public func dismiss() {
    dismiss(animated: true)
  }

  public func dismiss(animated animated: Bool) {
    if modalStack.count > 0 {
      let modalInfo: ModalInfo = modalStack.last!
      dismiss(to: modalInfo.viewController, animated: animated)
    }
  }

  public func dismiss(to viewController: UIViewController, animated: Bool) {
    dismiss(to: viewController, animated: animated, callback: nil)
  }
  
  public func dismiss(to viewController: UIViewController, animated: Bool, callback: ModalCallback?) {
    let modalInfo: (modal: ModalInfo, position: Int)? = findModalInfo(viewController: viewController)
    if modalInfo != nil {
      pop(to: modalInfo!.position, animated: animated, callback: callback)
    }
  }
  
  public func dismissAll(animated animated: Bool) {
    pop(to: 0, animated: animated, callback: nil)
  }
  
  
  // MARK: - Modal info management
  private func findModalInfo(viewController viewController: UIViewController) -> (modal: ModalInfo, position: Int)? {
    for (idx, modal): (Int, ModalInfo) in self.modalStack.enumerate() {
      if modal.viewController == viewController {
        return (modal: modal, position: idx)
      } else if viewController.navigationController != nil {
        if modal.viewController == viewController.navigationController! {
          return (modal: modal, position: idx)
        }
      }
    }
    return nil
  }
  
  
  
  // MARK: - Keyboard notifications
  public func willShowKeyboard(sender: AnyObject?) {
    let modal: ModalInfo = modalStack.last!
    if modal.conformsToModal {
      let adjustForFrame: Bool = (modal.viewController as! Modal).adjustsFrameForKeyboard()
      if adjustForFrame {
        // TODO: Adjust for frame
      }
    }
  }

  public func willHideKeyboard(sender: AnyObject?) {
    let modal: ModalInfo = modalStack.last!
    if modal.conformsToModal {
      let adjustForFrame: Bool = (modal.viewController as! Modal).adjustsFrameForKeyboard()
      if adjustForFrame {
        // TODO: Adjust for frame
      }
    }
  }
  
  
  // MARK: - Sizing
  private func startingRect(viewController viewController: UIViewController, style: ModalPresentationStyle) -> CGRect {

      var rect: CGRect = CGRectNull
      if style == .Custom {
        if let modalViewController: Modal = viewController as? Modal {
          rect = modalViewController.startingRect(parentRect: keyWindow()!.bounds)
        }
      }
      
      // if not using custom option, or if custom failed to find a Modal compliant ViewController as the passed
      // ViewController then fallback to .FromBottom or use the requested starting position
      if CGRectEqualToRect(rect, CGRectNull) {
        rect = keyWindow()!.bounds
        if style == .FromTop {
          rect.origin.y = -rect.height
        } else {
          rect.origin.y = rect.height
        }
      }
      
      return rect
  }
  
  private func endingRect(viewController viewController: UIViewController, style: ModalPresentationStyle) -> CGRect {
      
      var rect: CGRect = CGRectNull
      if style == .Custom {
        if let modalViewController: Modal = viewController as? Modal {
          rect = modalViewController.endingRect(parentRect: keyWindow()!.bounds)
        }
      }
      
      // if not using custom option, or if custom failed to find a Modal compliant ViewController as the passed
      // ViewController then fallback to .FromBottom or use the requested starting position
      if CGRectEqualToRect(rect, CGRectNull) {
        rect = keyWindow()!.bounds
      }
      
      return rect
  }
  
  
  // MARK: - Actions
  public func tappedOverlay(sender: AnyObject!) {
    let modal: ModalInfo = modalStack.last!
    if modal.conformsToModal {
      let modalViewController: Modal = (modal.viewController as! Modal)
      let dismissalOptions: ModalDismissalOptions = modalViewController.overlayTapShouldDismiss()
      if dismissalOptions.shouldDismiss {
        dismiss(animated: dismissalOptions.animated)
      }
    }
  }

}

