//
//  GlobalHelpers.swift
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


// MARK: - Type aliases
public typealias dispatch_cancelable_closure = (cancel: Bool) -> Void


// MARK: - UI helper functions
public func keyWindow() -> UIWindow? {
  let window: UIWindow? = UIApplication.sharedApplication().keyWindow
  return window
}


// MARK: - Timing functions
public func dispatch_later(time: NSTimeInterval, clsr: () -> Void) {
  dispatch_after(
    dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))),
    dispatch_get_main_queue(), clsr)
}

public func delay(time: NSTimeInterval, closure: () -> Void) ->  dispatch_cancelable_closure? {
  
  var closure: dispatch_block_t? = closure
  var cancelableClosure: dispatch_cancelable_closure?
  
  let delayedClosure: dispatch_cancelable_closure = { cancel in
    if closure != nil {
      if (cancel == false) {
        dispatch_async(dispatch_get_main_queue(), closure!);
      }
    }
    closure = nil
    cancelableClosure = nil
  }
  
  cancelableClosure = delayedClosure
  
  dispatch_later(time, clsr: { () -> Void in
    if let delayedClosure = cancelableClosure {
      delayedClosure(cancel: false)
    }
  })
  
  return cancelableClosure;
}

public func cancel_delay(closure: dispatch_cancelable_closure?) {
  if closure != nil {
    closure!(cancel: true)
  }
}


/**
  Check to see if an object conforms to a protocol
*/
public func conforms_to<P>(object: AnyObject, objType: P.Type) -> Bool {
  var conformsTo: Bool = false
  if let _ = object as? P {
    conformsTo = true
  }
  return conformsTo
}
