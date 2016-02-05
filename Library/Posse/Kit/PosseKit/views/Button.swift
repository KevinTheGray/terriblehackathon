//
//  Button.swift
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

public enum ButtonStyle: Int {
  case Text
  case Primary
  case BorderedWhite
}

public enum ImagePosition: Int {
  case Left
  case Right
  case Top
}

public class Button : Tappable {
  
  private let INTERNAL_PADDING: Double = 3.0
  
  public struct BorderAttributes {
    var width: Double = 1.0
    var color: UIColor = UIColor.blackColor()
    
    public init(width: Double, color: UIColor) {
      self.width = width
      self.color = color
    }
  }
  
  internal struct Attributes {
    
    private (set) internal var hasImages: Bool = false
    private (set) internal var hasTitles: Bool = false
    
    internal var titleColor: [UInt : UIColor] = [:]
    internal var title: [UInt : String] = [:] {
      didSet {
        self.hasTitles = self.title.count > 0
      }
    }
    internal var attributedTitle: [UInt : NSAttributedString] = [:] {
      didSet {
        self.hasTitles = self.attributedTitle.count > 0
      }
    }
    internal var borderAttributes: [UInt : BorderAttributes] = [:]
    internal var image: [UInt : UIImage] = [:] {
      didSet {
        self.hasImages = self.image.count > 0
      }
    }
  }
  
  
  // MARK: - Variables
  internal var attributes: Attributes = Attributes()
  public var cornerRadius: Double = 0.0
  public var hasInitialized: Bool = false
  public var imagePosition: ImagePosition = .Top
  public var imageSize: CGSize = CGSizeZero
  public var imageSpacing: Double = 3.0
  
  public var titleAdjustmentInsets: UIEdgeInsets = UIEdgeInsetsZero
  public var imageAdjustmentInsets: UIEdgeInsets = UIEdgeInsetsZero
  
  
  
  // MARK: - Initialization
  override public init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    self.addSubview(self.contentView)
    self.contentView.addSubview(self.titleLabel)
    self.contentView.addSubview(self.imageView)
    self.setTitleColor(color: UIColor.blackColor(), forState: .Normal)
    self.setTitleColor(color: UIColor.grayColor(), forState: .Highlighted)
    updateButtonStyle(forState: self.state)
  }

  
  // MARK: - Layout
  override public func layoutSubviews() {
    self.layer.cornerRadius = CGFloat(self.cornerRadius)
    self.contentView.frame = self.contentRect()
    self.titleLabel.frame = self.titleRect()
    self.imageView.frame = self.imageRect()
    if !hasInitialized {
      updateButtonStyle(forState: self.state)
      hasInitialized = true
    }
  }

  
  // MARK: - Lazy Initialization
  private lazy var contentView: UIView = {
    var view: UIView = UIView()
    view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    view.userInteractionEnabled = false
    return view
  }()
  
  
  public lazy var titleLabel: UILabel = {
    var label: UILabel = UILabel()
    label.textAlignment = NSTextAlignment.Center
    label.userInteractionEnabled = false
    label.font = UIFont.systemFontOfSize(13.0)
    //label.layer.borderColor = UIColor.redColor().CGColor
    //label.layer.borderWidth = 1.0
    return label
  }()

  public lazy var imageView: UIImageView = {
    var view: UIImageView = UIImageView()
    view.contentMode = UIViewContentMode.ScaleAspectFit
    view.clipsToBounds = true
    return view
  }()
  
  
  // MARK: - Getters/Setters
  public func setTitle(title title: String, forState state: UIControlState) {
    if title.characters.count > 0 {
      self.attributes.title[state.rawValue] = title
    }
    if state == self.state {
      updateButtonStyle(forState: self.state)
    }
  }
  
  public func title(forState state: UIControlState) -> String? {
    var title: String? = nil
    if let stateValue: String = self.attributes.title[state.rawValue] {
      title = stateValue
    } else if let stateValue: String = self.attributes.title[UIControlState.Normal.rawValue] {
      title = stateValue
    }
    return title
  }

  
  public func setAttributedTitle(title title: NSAttributedString, forState state: UIControlState) {
    self.attributes.attributedTitle[state.rawValue] = title
    if state == self.state {
      updateButtonStyle(forState: self.state)
    }
  }
  
  public func attributedTitle(forState state: UIControlState) -> NSAttributedString? {
    var attributedTitle: NSAttributedString? = nil
    if let stateValue: NSAttributedString = self.attributes.attributedTitle[state.rawValue] {
      attributedTitle = stateValue
    } else if let stateValue: NSAttributedString = self.attributes.attributedTitle[UIControlState.Normal.rawValue] {
      attributedTitle = stateValue
    }
    return attributedTitle
  }

  
  public func setTitleColor(color color: UIColor?, forState state: UIControlState) {
    if color != nil {
      self.attributes.titleColor[state.rawValue] = color
    }
    if state == self.state {
      updateButtonStyle(forState: self.state)
    }
  }
  
  public func titleColor(forState state: UIControlState) -> UIColor? {
    var titleColor: UIColor? = nil
    if let stateValue: UIColor = self.attributes.titleColor[state.rawValue] {
      titleColor = stateValue
    } else if let stateValue: UIColor = self.attributes.titleColor[UIControlState.Normal.rawValue] {
      titleColor = stateValue
    }
    return titleColor
  }

  
  public override func setBackgroundColor(color color: UIColor?, forState state: UIControlState) {
    super.setBackgroundColor(color: color, forState: state)
    if state == self.state {
      updateButtonStyle(forState: self.state)
    }
  }
  
  public func setBorderAttributes(attributes attributes: BorderAttributes, forState state: UIControlState) {
    self.attributes.borderAttributes[state.rawValue] = attributes
    if state == self.state {
      updateButtonStyle(forState: self.state)
    }
  }
  
  public func borderAttributes(forState state: UIControlState) -> BorderAttributes? {
    var borderAttributes: BorderAttributes? = nil
    if let stateValue: BorderAttributes = self.attributes.borderAttributes[state.rawValue] {
      borderAttributes = stateValue
    } else if let stateValue: BorderAttributes = self.attributes.borderAttributes[UIControlState.Normal.rawValue] {
      borderAttributes = stateValue
    }
    return borderAttributes
  }
  
  public func setImage(image image: UIImage?, forState state: UIControlState) {
    if image != nil {
      self.attributes.image[state.rawValue] = image
    }
    if state == self.state {
      updateButtonStyle(forState: self.state)
      self.setNeedsLayout()
    }
  }
  
  public func image(forState state: UIControlState) -> UIImage? {
    var image: UIImage? = nil
    if let stateValue: UIImage = self.attributes.image[state.rawValue] {
      image = stateValue
    } else if let stateValue: UIImage = self.attributes.image[UIControlState.Normal.rawValue] {
      image = stateValue
    }
    return image
  }

  
  // MARK: - State Configuration
  private func updateButtonStyle(forState state: UIControlState) {
    self.imageView.image = self.image(forState: state)
    self.titleLabel.textColor = self.titleColor(forState: state)
    if let attTitle: NSAttributedString = self.attributedTitle(forState: state) {
      self.titleLabel.attributedText = attTitle
    } else {
      self.titleLabel.text = self.title(forState: state)
    }
    if let borderAttributes: BorderAttributes = self.borderAttributes(forState: state) {
      self.layer.borderWidth = CGFloat(borderAttributes.width)
      self.layer.borderColor = borderAttributes.color.CGColor
    } else {
      self.layer.borderWidth = 0
      self.layer.borderColor = UIColor.clearColor().CGColor
    }
  }
  
  public func resetAllAttributes() {
    self.attributes = Attributes()
  }
  
  override public var highlighted: Bool {
    didSet {
      self.updateButtonStyle(forState: self.state)
    }
  }
  
  override public var selected: Bool {
    didSet {
      self.updateButtonStyle(forState: self.state)
    }
  }
  
  override public var enabled: Bool {
    didSet {
      self.updateButtonStyle(forState: self.state)
    }
  }
  
  
  // MARK: - Content Rects
  private func imageRect() -> CGRect {
    
    var contentRect: CGRect = self.contentRect()
    contentRect.origin = CGPoint(x: 0.0, y: 0.0)
    
    var rect: CGRect = CGRectZero
    let hasImages: Bool = self.attributes.hasImages
    let hasTitles: Bool = self.attributes.hasTitles
    
    if hasImages {
      if hasTitles == false {
        if CGSizeEqualToSize(imageSize, CGSizeZero) {
          rect = contentRect
        } else {
          rect = CGRect()
          rect.size = self.imageSize
          rect.origin = CGPoint(
            x: (contentRect.width - imageSize.width) / 2.0,
            y: (contentRect.height - imageSize.height) / 2.0
          )
        }
      } else {
        
        var imageSize: CGSize = self.imageSize
        if CGSizeEqualToSize(imageSize, CGSizeZero) {
          let dim: CGFloat = min(contentRect.width, contentRect.height)
          imageSize = CGSize(width: dim, height: dim)
        }
        var maxTitleWidth: CGFloat = contentRect.width - (imageSize.width + CGFloat(self.imageSpacing))
        if self.imagePosition == .Top {
          maxTitleWidth = contentRect.width
        }
        let titleSize: CGSize = self.titleSize(maxSize: CGSize(width: maxTitleWidth, height: CGFloat(FLT_MAX)))
        
        rect.size = self.imageSize
        
        rect.origin.x = (contentRect.width - imageSize.width) / 2.0
        if hasTitles == true {
          if self.imagePosition == .Top {
            let totalHeight: CGFloat = imageSize.height + titleSize.height + CGFloat(self.imageSpacing)
            if totalHeight > contentRect.height {
              rect.origin.y = 0.0
            } else {
              rect.origin.y = (contentRect.height - totalHeight) / 2.0
            }
          } else {
            rect.origin.x = 0.0
            if self.imagePosition == .Right {
              rect.origin.x = contentRect.width - imageSize.width
            }
          }
        } else {
          rect.origin.y = (contentRect.height - imageSize.height) / 2.0
        }
      }
    }
    return rect.ceilRect()
  }
  
  private func titleRect() -> CGRect {

    var contentRect: CGRect = self.contentRect()
    contentRect.origin = CGPoint(x: 0.0, y: 0.0)
    
    let imageRect: CGRect = self.imageRect()
    
    var maxTitleWidth: CGFloat = contentRect.width - (self.imageSize.width + CGFloat(self.imageSpacing))
    if self.imagePosition == .Top {
      maxTitleWidth = contentRect.width
    }
    let titleSize: CGSize = self.titleSize(maxSize: CGSize(width: maxTitleWidth, height: CGFloat(FLT_MAX)))

    var rect: CGRect = contentRect
    rect.origin.y = 0.0
    if self.attributes.hasImages {
      if self.imagePosition != .Top {
        rect.size.width = contentRect.width - (imageRect.width + CGFloat(self.imageSpacing))
        rect.origin.x = 0.0
        if self.imagePosition == .Left {
          rect.origin.x = imageRect.maxX + CGFloat(self.imageSpacing)
        }
      } else {
        rect.size.height = min(titleSize.height, contentRect.height - (imageRect.height + CGFloat(self.imageSpacing)))
        rect.origin.y = imageRect.maxY + CGFloat(self.imageSpacing)
      }
    }
    return UIEdgeInsetsInsetRect(rect.ceilRect(), self.titleAdjustmentInsets)
  }
  
  private func contentRect() -> CGRect {
    return UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsWithEqualInsets(INTERNAL_PADDING)).ceilRect()
  }
  
  private func titleSize(maxSize maxSize: CGSize) -> CGSize {
    var boundingRect: CGRect = CGRectZero
    if self.attributes.hasTitles {
      var calcString: NSAttributedString?
      if let attributedTitle: NSAttributedString = self.attributedTitle(forState: self.state) {
        calcString = attributedTitle
      } else {
        if let title: String = self.title(forState: self.state) {
          var titleAtts: [String : AnyObject] = [:]
          titleAtts[NSFontAttributeName] = self.titleLabel.font
          calcString = NSAttributedString(string: title, attributes: titleAtts)
        }
      }
      if calcString != nil {
        boundingRect = calcString!.boundingRectWithSize(maxSize,
          options: [NSStringDrawingOptions.UsesFontLeading, NSStringDrawingOptions.UsesLineFragmentOrigin],
          context: nil)
      }
    }
    return boundingRect.size
  }

  
  // MARK: - Sizing
  public override func sizeThatFits(size: CGSize) -> CGSize {
    var adjustedSize: CGSize = size
    adjustedSize.width -= 20.0
    var titleSize: CGSize = self.titleLabel.sizeThatFits(adjustedSize)
    titleSize.width += 20.0
    return titleSize
  }
  
  public override func intrinsicContentSize() -> CGSize {
    return self.sizeThatFits(CGSize(width: DBL_MAX, height: DBL_MAX))
  }
  
  public override func systemLayoutSizeFittingSize(targetSize: CGSize) -> CGSize {
    return self.sizeThatFits(targetSize)
  }
  
  public override func systemLayoutSizeFittingSize(targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority) -> CGSize {
      return self.sizeThatFits(targetSize)
  }
  
}
