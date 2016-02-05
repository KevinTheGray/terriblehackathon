//
//  RevealAnimator.swift
//  spoke
//
//  Created by Luke Freeman on 10/4/15.
//  Copyright © 2015 Posse Productions LLC. All rights reserved.
//

import Foundation
import UIKit

public class RevealAnimator : Animator {
  
  
  // MARK: - Internal
  private let animation: CABasicAnimation
  private let maskLayer: CAShapeLayer
  private var view: UIView? = nil
  
  // MARK: - Properties
  public var center: CGPoint = CGPointZero
  
  
  // MARK: - Initialization
  public init() {
    self.animation = CABasicAnimation(keyPath: "path")
    self.maskLayer = CAShapeLayer()
    setupAnimation()
  }
  

  // MARK: - Setup
  public func setupAnimation() {
    self.animation.duration = 0.2
    self.animation.delegate = AnimationDelegate {
      if let view: UIView = self.view {
        view.layer.mask = nil
        self.animation.delegate = nil
      }
    }
  }
  
  
  private func insetRectAtPoint(center center: CGPoint, radius: CGFloat) -> CGRect {
    assert(radius >= 0, "radius must be a positive number")
    return CGRectInset(CGRect(origin: center, size: CGSizeZero), -radius, -radius)
  }

  
  public func animate(view view: UIView) {
    
    self.view = view
    
    let startPath = CGPathCreateWithEllipseInRect(
        self.insetRectAtPoint(center: view.center, radius: 0.0), nil
    )
    let endPath = CGPathCreateWithEllipseInRect(
        self.insetRectAtPoint(center: view.center,
        radius: max(view.bounds.width, view.bounds.height) / 1.75), nil
    )
    
    // animation setup
    self.maskLayer.path = endPath

    self.animation.fromValue = startPath
    self.animation.toValue = endPath
    self.animation.removedOnCompletion = false

    view.layer.mask = self.maskLayer
    self.maskLayer.addAnimation(self.animation, forKey: "show")
    self.maskLayer.frame = view.bounds
  }
}