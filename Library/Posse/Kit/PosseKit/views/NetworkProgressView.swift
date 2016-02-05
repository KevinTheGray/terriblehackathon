//
//  NetworkProgressView.swift
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

public class NetworkProgressView : UIView {
  
  private (set) public var isAnimating: Bool = false
  
  public var lineWidth: CGFloat = 1.0 {
    didSet {
      self.configureShapeLayer()
    }
  }
  
  public var progressColor: UIColor = UIColor(hex: 0x666666) {
    didSet {
      self.configureShapeLayer()
    }
  }
  
  public var trackColor: UIColor = UIColor(white: 1.0, alpha: 0.15) {
    didSet {
      self.configureShapeLayer()
    }
  }
  
  public var progress: CGFloat = 1.0 {
    didSet {
      self.configureShapeLayer()
    }
  }
  
  
  // MARK: - Initialization
  public convenience init(frame: CGRect, lineWidth: CGFloat, progressColor: UIColor?) {
    self.init(frame: frame)
    self.lineWidth = lineWidth
    if progressColor != nil {
      self.progressColor = progressColor!
    }
  }
  
  public convenience required init?(coder aDecoder: NSCoder) {
    self.init(frame: CGRectZero, lineWidth: 0.0, progressColor: nil)
  }  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.addSublayer(self.shapeLayer)
    self.backgroundColor = UIColor.clearColor()
  }
  
  
  // MARK: - Lazy initialization
  private lazy var shapeLayer: CAShapeLayer = {
    return CAShapeLayer()
  }()
  
  
  // MARK: - Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.configureShapeLayer()
  }
  
  
  // MARK: - Progress layer configuration
  internal func configureShapeLayer() {
    if let layer: CAShapeLayer = self.shapeLayer {
      layer.path = pathForProgressAmount(self.progress).CGPath
      layer.frame = self.bounds
      layer.fillColor = UIColor.clearColor().CGColor
      layer.lineWidth = self.lineWidth
      layer.strokeColor = self.progressColor.CGColor
      layer.backgroundColor = UIColor.clearColor().CGColor
    }
  }
  
  internal func pathForProgressAmount(progress: CGFloat) -> UIBezierPath {
    let center: CGPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
    let startAngle: CGFloat = -CGFloat(M_PI) * 2.0 / 4.0
    let endAngle: CGFloat = CGFloat(M_PI) * 2.0 * 0.5
    let radius: CGFloat = fmin(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.0 - (self.lineWidth / 2.0);
    return UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
  }
  
  //MARK: Animation
  private func attachRotationAnimation() {
    let animation: CABasicAnimation = self.animationWithKeyPath("transform.rotation.z")
    animation.toValue = 0.0
    animation.byValue = 2 * M_PI
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.duration = 0.85
    animation.repeatCount = Float.infinity
    animation.removedOnCompletion = false
    self.shapeLayer.addAnimation(animation, forKey: animation.keyPath)
  }
  
  private func animationWithKeyPath(keyPath: String) -> CABasicAnimation {
    let animation: CABasicAnimation = CABasicAnimation(keyPath:keyPath)
    animation.autoreverses = false
    return animation
  }
  
  public func startAnimating(restart restart: Bool) {
    if restart {
      self.progress = 0.0
    }    
    self.isAnimating = true
    self.attachRotationAnimation()
    self.setNeedsDisplay()
  }
  
  public func stopAnimating() {
    self.isAnimating = false
    self.layer.removeAllAnimations()
    self.progress = 0.0
  }
  
  
  // MARK: - Custom drawing
  public override func drawRect(rect: CGRect) {
    let context: CGContext? = UIGraphicsGetCurrentContext()
    CGContextBeginPath(context)
    CGContextMoveToPoint(context, CGRectGetMidX(bounds), bounds.origin.y)
    
    let startAngle: CGFloat = -(CGFloat(M_PI)) * 2.0 / 4.0
    let endAngle: CGFloat = CGFloat(M_PI) * 2.0 * (1.0 - 0.25)
    let radius: CGFloat = (fmin(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.0) - (self.lineWidth / 2.0);
    CGContextAddArc(context, CGRectGetMidX(bounds), CGRectGetMidY(bounds), radius, startAngle, endAngle, 0)
    
    CGContextSetLineWidth(context, self.lineWidth)
    CGContextSetStrokeColorWithColor(context, self.trackColor.CGColor)
    CGContextStrokePath(context)
  }
}