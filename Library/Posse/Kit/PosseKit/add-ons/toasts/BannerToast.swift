//
//  BannerToast.swift
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

public class BannerToast : Toast {
  
  internal let TOAST_SPACING_OUTER_H: Double = 15.0
  internal let TOAST_SPACING_OUTER_V: Double = 10.0
  internal let TOAST_SPACING_INNER: Double = 5.0
  internal let TOAST_DISMISS_BUTTON_W: Double = 50.0
  internal let TOAST_DEFAULT_MAX_H: Double = 46.0
  internal let TOAST_STATUS_ADJUST_H: Double = 20.0
  
  // MARK: - Properties
  private (set) public lazy var textLabel: UILabel = {
    var view: UILabel = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.userInteractionEnabled = false
    return view
  }()

  private (set) public lazy var imageView: UIImageView = {
    var view: UIImageView = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.userInteractionEnabled = false
    view.clipsToBounds = true
    view.contentMode = .Center
    return view
  }()

  
  
  // MARK: - Initialization
  public required init(builder: Toast.Builder) {
    super.init(builder: builder)
    self.contentView.addSubview(self.textLabel)
    self.contentView.addSubview(self.imageView)
    self.userInteractionEnabled = true
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  internal func configureConstraints() {

    let hasIcon: Bool = (self.icon != nil)
    let toastConfiguration: ToastConfiguration = self.toastManager.validConfiguration(forToast: self)
    
    let views: [String : AnyObject] = [
      "imageView" : imageView,
      "textLabel" : textLabel,
    ]
  
    var statusAdjustment: Double = TOAST_STATUS_ADJUST_H
    if toastConfiguration.adjustRectForStatusBar == false {
      statusAdjustment = 0.0
    }
    
    let metrics: [String : AnyObject] = [
      "imageWidth" : ceil(toastConfiguration.imageSize.width),
      "imageHeight" : ceil(toastConfiguration.imageSize.height),
      "outerSpacingH" : TOAST_SPACING_OUTER_H,
      "outerSpacingV" : TOAST_SPACING_OUTER_V,
      "innerSpacing" : TOAST_SPACING_INNER,
      "topSpacing" : TOAST_SPACING_OUTER_V + statusAdjustment,
    ]
    
    var hConstraintsVFL: String = "H:|-outerSpacingH-[imageView(==imageWidth)]-innerSpacing-[textLabel]-outerSpacingH-|"
    if (!hasIcon) {
      hConstraintsVFL = "H:|-outerSpacingH-[textLabel]-outerSpacingH-|"
    }
    
    // text constraints
    let hConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat(
      hConstraintsVFL, options: NSLayoutFormatOptions(), metrics: metrics, views: views)
    let textVConstraint: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-topSpacing-[textLabel]-outerSpacingV-|", options: NSLayoutFormatOptions(), metrics: metrics, views: views)

    self.addConstraints(hConstraints)
    self.addConstraints(textVConstraint)
    
    if hasIcon {
      // image constraints
      let imageHeightConstraint: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[imageView(==imageHeight)]", options: NSLayoutFormatOptions(),
        metrics: metrics, views: views)
      let imageVConstraint: NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterY,
        relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.CenterY,
        multiplier: 1.0, constant: CGFloat(statusAdjustment / 2.0))

      self.addConstraints(imageHeightConstraint)
      self.addConstraints([imageVConstraint])
    }
  }
  
  
  // MARK: - Toast overrides
  public override func configureToastStyle(configuration configuration: ToastConfiguration) {
    super.configureToastStyle(configuration: configuration)
    
    self.configureConstraints()
    
    self.imageView.image = self.icon
    
    self.backgroundColor = configuration.backgroundColor
    self.textLabel.font = configuration.font
    self.textLabel.textColor = configuration.foregroundColor
    self.textLabel.textAlignment = configuration.textAlignment
    self.textLabel.numberOfLines = configuration.maxLines
    self.textLabel.text = self.text
  }
  
  public override class func defaultConfiguration() -> ToastConfiguration {
    var configuration: ToastConfiguration = ToastConfiguration()
    configuration.position = .Top
    configuration.maxLines = 3
    configuration.animationParams.startAlpha = 0.0
    configuration.animationParams.endAlpha = 1.0
    configuration.mode = .Temporary
    configuration.animationParams.showDelay = 0
    configuration.animationParams.hideDelay = 3.0
    configuration.animationParams.duration = 0.5
    configuration.imageSize = CGSize(width: 32.0, height: 30.0)
    configuration.font = UIFont.systemFontOfSize(11.0)
    configuration.adjustRectForStatusBar = true
    return configuration
  }
  
  
  // MARK: - Sizing
  internal func optimalSize(parentFrame parentFrame: CGRect) -> CGSize {
    var optimalSize: CGSize = self.optimalSize(parentFrame: parentFrame, maxWidth: Double(parentFrame.width),
      includeButton: true)
    optimalSize.width = parentFrame.width
    return optimalSize
  }
  
  internal func optimalSize(parentFrame parentFrame: CGRect, maxWidth: Double, includeButton: Bool) -> CGSize {
    let toastConfiguration: ToastConfiguration = self.toastManager.validConfiguration(forToast: self)
    let hasIcon: Bool = (self.icon != nil)
    var minToastHeight: Double = TOAST_DEFAULT_MAX_H
    let maxToastWidth: Double = ceil(maxWidth)
    var toastExtraWidth: Double = (2 * TOAST_SPACING_OUTER_H)
    if hasIcon {
      toastExtraWidth += ceil(TOAST_SPACING_INNER + Double(toastConfiguration.imageSize.width))
      minToastHeight = ceil(Double(toastConfiguration.imageSize.height) + (2 * TOAST_SPACING_OUTER_V))
    }
    if includeButton {
      toastExtraWidth += (TOAST_DISMISS_BUTTON_W + TOAST_SPACING_INNER)
    }
    
    let maxLabelWidth: Double = ceil(maxWidth - toastExtraWidth)
    var height: Double = minToastHeight, width: Double = maxToastWidth
    if let toastText: String = self.text {
      let textSize: CGSize = self.textLabel.font.sizeOfString(toastText,
        constrainedToWidth: maxLabelWidth, lineCount: toastConfiguration.maxLines)
      width = ceil(Double(textSize.width) + toastExtraWidth)
      height = ceil(max(Double(textSize.height) + (2 * TOAST_SPACING_OUTER_V), minToastHeight))
    }
    
    if toastConfiguration.adjustRectForStatusBar {
      height += TOAST_STATUS_ADJUST_H
    }
    return CGSize(width: width, height: height)
  }
  
  public override func preferredHiddenRect(parentFrame parentFrame: CGRect, position: ToastPosition) -> CGRect {
    let optimalSize: CGSize = self.optimalSize(parentFrame: parentFrame)
    let h: Double = Double(optimalSize.height)
    
    // NOTE: center visibility is not supported
    var y: Double = -h
    if position == .Bottom {
      y = Double(parentFrame.height)
    }
    return CGRect(x: 0.0, y: y, width: Double(optimalSize.width), height: h)
  }
  
  public override func preferredVisibleRect(parentFrame parentFrame: CGRect, position: ToastPosition) -> CGRect {
    var visibleRect: CGRect = self.preferredHiddenRect(parentFrame: parentFrame, position: position)

    // NOTE: center visibility is not supported
    var y: CGFloat = 0.0
    if position == .Bottom {
      y = parentFrame.height - visibleRect.height
    }
    
    visibleRect.origin.y = y
    return visibleRect
  }
  
}