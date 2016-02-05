//
//  CenteredTitleView.swift
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


public class CenteredTitleView : UIView {
  

  // MARK: - Initialization
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    //self.layer.borderColor = UIColor.yellowColor().CGColor
    //self.layer.borderWidth = 1.0
    
    self.addSubview(self.titleLabel)
    //self.titleLabel.layer.borderColor = UIColor.redColor().CGColor
    //self.titleLabel.layer.borderWidth = 1.0
    self.clipsToBounds = true

  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Lazy initialization
  public lazy var titleLabel: UILabel = {
    var view: UILabel = UILabel()
    view.textAlignment = .Center
    return view
  }()
  
  
  // MARK: - Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
    let mainScreen: UIScreen = UIScreen.mainScreen()
    var fullWidth: CGFloat = mainScreen.bounds.width
    if self.superview != nil {
      fullWidth = self.superview!.bounds.width
    }
    let h: CGFloat = self.bounds.height
    let centerX: CGFloat = fullWidth / 2.0
    let xDiff: CGFloat = (centerX - (self.bounds.width / 2.0) - self.frame.origin.x)
    let y: CGFloat = (self.bounds.height - h) / 2.0
    let w: CGFloat = self.bounds.width - (2.0 * abs(xDiff))
    let x: CGFloat = xDiff <= 0.0 ? 0.0 : xDiff * 2.0
    self.titleLabel.frame = CGRect(x: x, y: y, width: w, height: h)
  }
  
}
