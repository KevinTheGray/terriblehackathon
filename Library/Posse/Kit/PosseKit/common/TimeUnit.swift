//
//  TimeUnit.swift
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

public enum Interval {
  
  case Millisecond
  case Second
  case Minute
  case Hour
  case Day
  case MonthsOfYear     // day * 12/365
  case Year             // 365 days
  case LeapYear         // 366 days
  case AverageYear      // 365.25 days
  
  private static let factorTable: [Interval : Double] = [
    .Millisecond : 1000.0,
    .Second : 1.0,
    .Minute : (1.0 / 60.0),
    .Hour : (1.0 / 60.0 / 60.0),
    .Day : (1.0 / 60.0 / 60.0 / 24.0),
    .MonthsOfYear : ((1.0 / 60.0 / 60.0 / 24.0) * (12.0 / 365.0)),
    .Year : (1.0 / 60.0 / 60.0 / 24.0 / 365.0),
    .LeapYear : (1.0 / 60.0 / 60.0 / 24.0 / 366.0),
    .AverageYear: (1.0 / 60.0 / 60.0 / 24.0 / 365.25),
  ]
  
  public func multiplicationFactor() -> Double {
    if let factor: Double = Interval.factorTable[self] {
      return factor
    } else {
      return 0.0
    }
  }
  
}

public class TimeUnit {
  
  private var seconds: Double = 0.0
  
  
  // MARK: - Initialization
  public init() {
  }
  
  public init(seconds: NSTimeInterval) {
    self.seconds = seconds
  }
  
  public init(interval: Interval, value: Double) {
    self.seconds = value / interval.multiplicationFactor()
  }

  
  // MARK: - Relative date matching
  public func ago() -> NSDate {
    return NSDate(timeIntervalSinceNow:(-1.0 * self.seconds))
  }
  
  public func fromNow() -> NSDate {
    return NSDate(timeIntervalSinceNow:(1.0 * self.seconds))
  }
  
  
  // MARK: - Conversion
  public func to(interval: Interval) -> Double {
    return self.seconds * interval.multiplicationFactor()
  }
  
  
  // MARK: - String conversions
  
  
}