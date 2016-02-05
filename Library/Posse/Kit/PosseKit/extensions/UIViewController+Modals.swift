//
//  UIViewController+Modals.swift
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


public extension UIViewController {
  public func presentModal(viewController: UIViewController) {
    ModalManager.manager.present(viewController, onto: self, style: .Custom, animated: true, callback: nil)
  }
  
  public func presentModal(viewController: UIViewController, style: ModalPresentationStyle) {
    ModalManager.manager.present(viewController, onto: self, style: style, animated: true, callback: nil)
  }
  
  public func presentModal(viewController: UIViewController, style: ModalPresentationStyle, animated: Bool) {
    ModalManager.manager.present(viewController, onto: self, style: style, animated: animated, callback: nil)
  }
  
  public func presentModal(viewController: UIViewController, style: ModalPresentationStyle, animated: Bool, callback: ModalCallback?) {
    ModalManager.manager.present(viewController, onto: self, style: style, animated: animated, callback: callback)
  }
  
  public func dismissModal() {
    ModalManager.manager.dismiss(to: self, animated: true)
  }
  
  public func dismissModal(animated animated: Bool) {
    dismissModal(animated: animated, callback: nil)
  }
  
  public func dismissModal(animated animated: Bool, callback: ModalCallback?) {
    ModalManager.manager.dismiss(to: self, animated: animated)
  }
  
  public func dismissAllModals() {
    ModalManager.manager.dismissAll(animated: true)
  }
}
