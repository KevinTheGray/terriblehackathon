//
//  Animator.swift
//  spoke
//
//  Created by Luke Freeman on 10/4/15.
//  Copyright © 2015 Posse Productions LLC. All rights reserved.
//

import Foundation
import UIKit


public class AnimationDelegate {
  
  private let completion: () -> Void
  
  init(completion: () -> Void) {
    self.completion = completion
  }
  
  dynamic func animationDidStop(_: CAAnimation, finished: Bool) {
    completion()
  }
}


public protocol Animator {
  func animate(view view: UIView)
}