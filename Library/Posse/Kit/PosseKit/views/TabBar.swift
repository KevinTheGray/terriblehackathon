//
//  TabBar.swift
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

// enums
public enum TabItemType : Int {
  case Tab
  case Button
}

public enum TabIndicatorPosition : Int {
  case Top
  case Bottom
  case BelowText
}

public enum TabIndicatorAnimationStyle : Int {
  case Move
  case Fade
}


// delegate
public protocol TabBarDelegate: class {
  func tappedButton(tabBar: TabBar, atIndex index: Int)
  func movedToTab(tabBar: TabBar, atIndex index: Int)
};


// class definitions
public class TabItem: Button {
  public var type: TabItemType = .Tab
  public var isStyled: Bool = false
}

public class TabBar: UIView {
  
  // default values
  public struct Defaults {
    static let TextColor: UIColor = UIColor(hex: 0xAAAAAA)
    static let TextSelectedColor: UIColor = UIColor(hex: 0x111111)
    static let TextHighlightColor: UIColor = UIColor(hex: 0xFFFFFF)
    static let IndicatorColor: UIColor = UIColor(hex: 0x555555)
    static let BackgroundColor: UIColor = UIColor.whiteColor()
    static let BackgroundHighlightedColor: UIColor = UIColor(hex: 0xAAAAAA)
    static let BackgroundSelectedColor: UIColor = UIColor(hex: 0xEEEEEE)
  }
  
  public weak var delegate: TabBarDelegate?
  
  private var tabButtons: [TabItem] = []
  private var indicatorView: UIView = {
    var view: UIView = UIView()
    return view
  }()
  
  
  // tab colors
  public var tabFont: UIFont = UIFont.systemFontOfSize(11.0)
  public var tabColor: UIColor? = Defaults.BackgroundColor
  public var tabHighlightedColor: UIColor? = Defaults.BackgroundHighlightedColor
  public var tabSelectedColor: UIColor? = Defaults.BackgroundSelectedColor
  public var tabTextColor: UIColor? = Defaults.TextColor
  public var tabTextSelectedColor: UIColor? = Defaults.TextSelectedColor
  public var tabTextHighlightedColor: UIColor? = Defaults.TextHighlightColor

  // tab icon styling
  public var tabIconSize: CGSize = CGSize(width: 20.0, height: 20.0)
  public var tabIconInsets: UIEdgeInsets = UIEdgeInsetsZero
  
  // tab indicator styling
  public var indicatorColor: UIColor? = Defaults.IndicatorColor
  public var indicatorSizedToText: Bool = false
  public var indicatorPosition: TabIndicatorPosition = .Bottom
  public var indicatorHeight: Float = 3.0 {
    didSet {
      self.setNeedsLayout()
    }
  }
  public var indicatorMargins: UIEdgeInsets = UIEdgeInsetsZero
  public var animateIndicatorPosition: Bool = true

  // general styling
  public var animationStyle: TabIndicatorAnimationStyle = .Move

  // state
  public var selectedIndex: Int = -1 {
    willSet {
      moveToTabItemAtIndex(index: newValue)
    }
  }
  
  
  // MARK : - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.indicatorView)
    self.clipsToBounds = true
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  // MARK : - Tab Management - Convenience methods
  public func addTabItem(type type: TabItemType, image: UIImage?, selectedImage: UIImage?) -> TabItem {
    return addTabItem(type: type, text: nil, image: image, selectedImage: selectedImage, index: Int.max)
  }
  public func addTabItem(type type: TabItemType, text: String?) -> TabItem {
    return addTabItem(type: type, text: text, image: nil, selectedImage: nil, index: Int.max)
  }
  public func addTabItem(type type: TabItemType, text: String?, image: UIImage?, selectedImage: UIImage?) -> TabItem {
    return addTabItem(type: type, text: text, image: image, selectedImage: selectedImage, index: Int.max)
  }
  public func addTabItem(tabItem tabItem: TabItem) -> TabItem {
    return addTabItem(tabItem: tabItem, index: Int.max)
  }
  public func addTabItem(tabItem tabItem: TabItem, index: Int) -> TabItem {
    var tabIndex: Int = index
    if (tabIndex == Int.max) {
      tabIndex = self.tabButtons.count
    }
    if (self.tabButtons.count == 0) {
      tabItem.selected = true
      selectedIndex = 0
    }
    tabItem.addTarget(self, action: "tappedTabButton:", forControlEvents: .TouchUpInside)
    self.tabButtons.append(tabItem)
    
    self.addSubview(tabItem)
    reindexTabs()
    layoutTabButtons()
    
    return tabItem
  }
  
  public func updateTabItem(index index: Int, text: String?) {
    updateTabItem(atIndex: index, text: text, image: nil, selectedImage: nil)
  }
  public func updateTabItem(index index: Int, image: UIImage?, selectedImage: UIImage?) {
    updateTabItem(atIndex: index, text: nil, image: image, selectedImage: selectedImage)
  }
  
  // MARK : - Tab Management
  public func addTabItem(type type: TabItemType, text: String?, image: UIImage?, selectedImage: UIImage?, index: Int) -> TabItem {
    let tabItem: TabItem = TabItem()
    tabItem.type = type
    
    self.setTabItemValues(tabItem, text: text, image: image, selectedImage: selectedImage)

    return addTabItem(tabItem: tabItem)
  }
  
  public func updateTabItem(atIndex index: Int, text: String?, image: UIImage?, selectedImage: UIImage?) {
    if (index < self.tabButtons.count) {
      let tabItem: TabItem = self.tabButtons[index]
      setTabItemValues(tabItem, text: text, image: image, selectedImage: selectedImage)
    }
  }
  
  public func updateTabItemTypeAtIndex(atIndex index: Int, type: TabItemType) {
    let tabItem: TabItem = self.tabButtons[index]
    tabItem.type = type
  }
  
  public func removeTabItem(atIndex index: Int) {
    if (index < self.tabButtons.count) {
      let tabItem: TabItem = self.tabButtons[index]
      tabItem.removeFromSuperview()
      self.tabButtons.removeAtIndex(index)
      reindexTabs()
      layoutTabButtons()
    }
  }
  
  public func setTabItemValues(tabItem: TabItem, text: String?, image: UIImage?, selectedImage: UIImage?) {
    tabItem.imageSize = self.tabIconSize
    if let title: String = text {
      tabItem.setTitle(title: title, forState: .Normal)
    }
    tabItem.setImage(image: image, forState: .Normal)
    tabItem.setImage(image: selectedImage, forState: .Selected)
    tabItem.imageSpacing = 6.0
  }
  
  private func updateTabProperties(tabItem: TabItem) {
    if tabItem.isStyled == false {
      tabItem.imageAdjustmentInsets = self.tabIconInsets
      tabItem.titleLabel.font = self.tabFont
      tabItem.setBackgroundColor(color: self.tabColor, forState: .Normal)
      tabItem.setBackgroundColor(color: self.tabHighlightedColor, forState: .Highlighted)
      tabItem.setBackgroundColor(color: self.tabSelectedColor, forState: .Selected)
      tabItem.setBackgroundColor(color: self.tabHighlightedColor,
          forState: [ .Selected, .Highlighted ])
      
      tabItem.setTitleColor(color: self.tabTextColor, forState: .Normal)
      tabItem.setTitleColor(color: self.tabTextHighlightedColor, forState: .Highlighted)
      tabItem.setTitleColor(color: self.tabTextSelectedColor, forState: .Selected)
      tabItem.setTitleColor(color: self.tabTextHighlightedColor,
          forState: [ .Selected, .Highlighted ])
    }
  }
  
  // MARK : - Layout
  private func layoutTabButtons() {
    var w: CGFloat = self.bounds.width / CGFloat(self.tabButtons.count),
        h: CGFloat = self.bounds.height + CGFloat(2 * self.indicatorHeight),
        x: CGFloat = 0.0, y: CGFloat = CGFloat(-self.indicatorHeight)
    
    for (_, tabItem) in self.tabButtons.enumerate() {
      tabItem.frame = CGRect(x: x, y: y, width: w, height: h);
      x += w
      updateTabProperties(tabItem)
    }
  }
  
  private func reindexTabs() {
    for (idx, tabItem) in self.tabButtons.enumerate() {
      tabItem.tag = idx
    }
  }
  
  private func indicatorRect(tabIndex: Int) -> CGRect {

    if tabIndex <= self.tabButtons.count && self.tabButtons.count > 0 {

      let tabItem: TabItem = self.tabButtons[tabIndex]
      
      let hasImage: Bool = (tabItem.image(forState: .Normal) != nil)
      let hasTitle: Bool = (tabItem.title(forState: .Normal) != nil)
      
      let titleSize: CGSize = tabItem.titleLabel.sizeThatFits(CGSizeMake(tabItem.bounds.width,
          tabItem.bounds.size.height))
      
      // default to .Bottom measurements
      var w: CGFloat = tabItem.bounds.width, h: CGFloat = CGFloat(self.indicatorHeight),
          x: CGFloat = 0.0, y: CGFloat = tabItem.bounds.height - h

      if self.indicatorPosition == .Top {
        y = 0.0
      } else if self.indicatorPosition == .BelowText {
        // has both image & title
        if hasImage && hasTitle {
          w = titleSize.width
          var ih: CGFloat = titleSize.height + self.tabIconSize.height
          if tabItem.imagePosition == .Top {
            ih += self.indicatorMargins.top
          }
          y = ((tabItem.bounds.size.height - ih) / 2.0) + ih
        
        // has ONLY title
        } else if hasTitle {
          w = titleSize.width
          y = ((tabItem.bounds.size.height - titleSize.height) / 2.0) + (titleSize.height)
          
        // has ONLY image
        } else if hasImage {
          w = self.tabIconSize.width
          y = CGRectGetMaxY(tabItem.imageView.frame)

        // has no image or title = no indicator
        } else {
          return CGRectZero
        }
        x = (tabItem.frame.origin.x + (tabItem.bounds.size.width - w) / 2.0)
        y = min(y, CGRectGetHeight(tabItem.bounds) - CGFloat(self.indicatorHeight))
      }
      
      x += self.indicatorMargins.left
      w -= (self.indicatorMargins.left + self.indicatorMargins.right)
      
      return CGRect(x: x, y: y, width: w, height: h)
    }
    return CGRectZero
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    layoutTabButtons()
    self.indicatorView.backgroundColor = self.indicatorColor
    self.bringSubviewToFront(self.indicatorView)
    self.indicatorView.frame = indicatorRect(self.selectedIndex)
  }
  
  private func moveToTabItemAtIndex(index index: Int) {
    if ((index < 0 || index >= self.tabButtons.count) || index == self.selectedIndex) {
      return
    }
    let tabItem: TabItem = self.tabButtons[index]
    animateToTabItem(tabItem: tabItem, atIndex: index)
  }
  
  private func animateToTabItem(tabItem tabItem: TabItem, atIndex index: Int) {
    if (self.selectedIndex >= 0) {
      let selectedItem: TabItem = self.tabButtons[self.selectedIndex]
      selectedItem.selected = false
      selectedItem.setNeedsLayout()
    }
    
    tabItem.selected = true
    tabItem.setNeedsLayout()
    
    if (animationStyle == .Fade) {
      self.indicatorView.alpha = 0.0
      self.indicatorView.frame = self.indicatorRect(index)
    }
    let duration: NSTimeInterval = (self.animateIndicatorPosition ? 0.08 : 0.0)
    let fadeDuration: NSTimeInterval = (self.animateIndicatorPosition ? 0.18 : 0.0)
    UIView.animateWithDuration(duration, animations: { () -> Void in
      self.indicatorView.frame = self.indicatorRect(index)
    })
    if (animationStyle == .Fade) {
      UIView.animateWithDuration(fadeDuration, animations: { () -> Void in
        self.indicatorView.alpha = 1.0
      })
    }
  }
  
  public func tappedTabButton(sender: AnyObject?) {
    if (sender != nil) {
      let tabItem: TabItem = sender! as! TabItem
      if (tabItem.type == .Tab) {   // button is acting as a tab
        if (self.selectedIndex == tabItem.tag) {
          return
        }
        animateToTabItem(tabItem: tabItem, atIndex: tabItem.tag)
        self.selectedIndex = tabItem.tag
        
        if (delegate != nil) {
          delegate?.movedToTab(self, atIndex: tabItem.tag)
        }
      } else if (tabItem.type == .Button) {
        if (delegate != nil) {
          delegate?.tappedButton(self, atIndex: tabItem.tag)
        }
      }
    }
  }
  
}


