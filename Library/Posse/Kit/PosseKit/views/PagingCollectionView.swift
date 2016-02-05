//
//  PagingCollectionView.swift
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


public protocol PagingCollectionViewDelegate : class {
  func pagingCollectionViewDidHitThreshold(collectionView collectionView: PagingCollectionView)
}


public class PagingCollectionView : UICollectionView {
  
  private var KVO_CONTEXT_PAGING: String = "PagingCollectionViewContext"
  
  private let KEY_PATH_CONTENT_OFFSET: String = "contentOffset"
  private let KEY_PATH_CONTENT_SIZE: String = "contentSize"
  

  // MARK: - Internal
  private var hasRegisteredObservers: Bool = false
  
  
  
  // MARK: - Properties
  public var pagingThreshold: CGFloat = 0.7
  public var isDataPagingEnabled: Bool = true
  
  
  public weak var pagingDelegate: PagingCollectionViewDelegate? {
    willSet {
      if self.hasRegisteredObservers == true {
        self.removeObserver(self, forKeyPath: KEY_PATH_CONTENT_OFFSET)
        self.removeObserver(self, forKeyPath: KEY_PATH_CONTENT_SIZE)
      }
      if newValue != nil {
        self.addObserver(self, forKeyPath: KEY_PATH_CONTENT_OFFSET, options:[.New, .Old],
          context: &KVO_CONTEXT_PAGING)
        self.addObserver(self, forKeyPath: KEY_PATH_CONTENT_SIZE, options:[.New, .Old],
          context: &KVO_CONTEXT_PAGING)
        self.hasRegisteredObservers = true
      }
    }
  }
  
  deinit {
    if self.hasRegisteredObservers == true {
      self.removeObserver(self, forKeyPath: KEY_PATH_CONTENT_OFFSET)
      self.removeObserver(self, forKeyPath: KEY_PATH_CONTENT_SIZE)
    }
  }
  
  
  public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if context == &KVO_CONTEXT_PAGING {
      if self.isDataPagingEnabled && self.contentSize.height > 0.0 {
        if keyPath == KEY_PATH_CONTENT_OFFSET {
          if let changes: [String : AnyObject] = change {
            if let scrollPointValue: NSValue = changes[NSKeyValueChangeNewKey] as? NSValue {
              if let scrollPoint: CGPoint = scrollPointValue.CGPointValue() {
                if scrollPoint.y >= self.pagingThreshold * (self.contentSize.height - self.bounds.height) {
                  self.pagingDelegate?.pagingCollectionViewDidHitThreshold(collectionView: self)
                }
              }
            }
          }
        }
      }
    } else {
      super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
  }
  
}
