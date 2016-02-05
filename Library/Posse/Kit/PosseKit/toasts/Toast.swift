//
//  Toast.swift
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

public class Toast : UIView {
  
  private(set) public var configuration: ToastConfiguration?
  private(set) public var configurationKey: String?
  private(set) public var toastMode: ToastMode?
  private(set) public var text: String?
  private(set) public var attributedText: NSAttributedString?
  private(set) public var icon: UIImage?
  private(set) public var userInfo: [String : AnyObject]?
  
  private(set) internal var toastClass: Toast.Type!
  private(set) internal var toastManager: ToastManager!
  
  
  // MARK: - Initialization
  required public init(builder: Toast.Builder) {
    super.init(frame: CGRectZero)
    
    self.toastClass = builder.toastClass
    self.toastManager = builder.toastManager

    self.configuration = builder.configuration
    self.configurationKey = builder.configurationKey
    self.toastMode = builder.toastMode
    
    self.text = builder.text
    self.attributedText = builder.attributedText
    self.icon = builder.icon
    self.userInfo = builder.userInfo
    
    self.addSubview(self.contentView)
  }
  
  public func newBuilder() -> Toast.Builder {
    return Toast.Builder(toastClass: self.toastClass, toastManager: self.toastManager)
      .configuration(self.configuration)
      .configurationKey(self.configurationKey)
      .text(self.text)
      .attributedText(self.attributedText)
      .icon(self.icon)
      .userInfo(self.userInfo)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  
  // MARK: - Lazy Init
  private(set) public lazy var contentView: UIView = {
    let view = UIView()
    view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    return view
  }()
  
  private(set) public lazy var actionContentView: UIView = {
    let view = UIView()
    view.autoresizingMask = .FlexibleWidth
    return view
  }()
  
  
  // MARK: - Methods to Override in Subclass
  public func preferredHiddenRect(parentFrame parentFrame: CGRect, position: ToastPosition) -> CGRect {
    return CGRectZero
  }
  
  public func preferredVisibleRect(parentFrame parentFrame: CGRect, position: ToastPosition) -> CGRect {
    return CGRectZero
  }
  
  public func configureToastStyle(configuration configuration: ToastConfiguration) {
  }
  
  public class func defaultConfiguration() -> ToastConfiguration {
    var configuration: ToastConfiguration = ToastConfiguration()
    configuration.position = .Bottom
    configuration.maxLines = 3
    configuration.animationParams.startAlpha = 0.0
    configuration.animationParams.endAlpha = 1.0
    configuration.mode = .Temporary
    configuration.animationParams.showDelay = 0
    configuration.animationParams.hideDelay = 3.0
    configuration.animationParams.duration = 0.5
    configuration.imageSize = CGSize(width: 30.0, height: 30.0)
    configuration.font = UIFont.systemFontOfSize(11.0)
    return configuration
  }
  
  
  // MARK: - Toast Builder Object
  public class Builder {
    
    private var toastClass: Toast.Type!
    private var toastManager: ToastManager!
    private var toastMode: ToastMode?
    private var configuration: ToastConfiguration?
    private var configurationKey: String?
    private var text: String?
    private var attributedText: NSAttributedString?
    private var icon: UIImage?
    private var userInfo: [String : AnyObject]?
    
    
    // MARK: - Initialization
    public init(toastClass: Toast.Type, toastManager: ToastManager) {
      self.toastClass = toastClass
      self.toastManager = toastManager
    }
    
    // MARK: - Builder Methods
    public func configuration(configuration: ToastConfiguration?) -> Toast.Builder {
      self.configuration = configuration
      return self
    }
    
    public func configurationKey(configurationKey: String?) -> Toast.Builder {
      self.configurationKey = configurationKey
      return self
    }
    
    public func mode(toastMode: ToastMode?) -> Toast.Builder {
      self.toastMode = toastMode
      return self
    }
    
    public func text(text: String?) -> Toast.Builder {
      self.text = text
      return self
    }

    public func attributedText(attributedText: NSAttributedString?) -> Toast.Builder {
      self.attributedText = attributedText
      return self
    }
    
    public func icon(icon: UIImage?) -> Toast.Builder {
      self.icon = icon
      return self
    }
    
    public func userInfo(userInfo: [String : AnyObject]?) -> Toast.Builder {
      self.userInfo(userInfo)
      return self
    }
    
    public func build() -> Toast {
      return self.toastClass.init(builder: self)
    }
  }
}
