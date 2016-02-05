//
//  UIColor+Ext.swift
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

public extension UIColor {
	public convenience init(hex: Int, alpha: Float = 1.0) {
		let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
    let blue = CGFloat((hex & 0xFF)) / 255.0
    self.init(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
	}
  
  // MARK: complementary color calculation
  public func complementaryColor() -> UIColor {
    let rgbaTuple = toRGBA()
    return UIColor(red: CGFloat(1.0 - rgbaTuple.red), green: CGFloat(1.0 - rgbaTuple.green),
      blue: CGFloat(1.0 - rgbaTuple.blue), alpha: CGFloat(rgbaTuple.alpha))
  }

  // See: http://www.w3.org/TR/AERT#color-contrast
  public func blackOrWhiteContrastColor() -> UIColor {
    let rgbaTuple = toRGBA()
    let value: Float = 1.0 - ((0.299 * rgbaTuple.red) + (0.587 * rgbaTuple.green) + (0.114 * rgbaTuple.blue));
    return value > 0.5 ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x000000)
  }
  
  // MARK: Adjustments
  public func adjustBrightness(amount: Float) -> UIColor {
    let hsbaTuple = toHSBA()
    let finalBrightness = fminf(1.0, fmaxf(0.0, (hsbaTuple.brightness + amount)))
    return UIColor(hue: CGFloat(hsbaTuple.hue), saturation: CGFloat(hsbaTuple.saturation),
      brightness: CGFloat(finalBrightness), alpha: CGFloat(hsbaTuple.alpha))
  }

  public func adjustAlpha(alpha: Float) -> UIColor {
    let hsbaTuple = toHSBA()
    let finalAlpha = fminf(1.0, fmaxf(0.0, alpha))
    return UIColor(hue: CGFloat(hsbaTuple.hue), saturation: CGFloat(hsbaTuple.saturation),
      brightness: CGFloat(hsbaTuple.brightness), alpha: CGFloat(finalAlpha))
  }

  
  // MARK: Tuple-based conversion
  public func toRGBA() -> (red : Float, green : Float, blue : Float, alpha: Float) {
    let components = CGColorGetComponents(self.CGColor)
    let r: Float = Float(components[0])
    let g: Float = Float(components[1])
    let b: Float = Float(components[2])
    let a: Float = Float(components[3])
    return (r, g, b, a)
  }
  
  public func toFullRGBA() -> (red : Int, green : Int, blue : Int, alpha: Float) {
    let rgbaTuple = toRGBA()
    let r: Int = Int(roundf(Float(rgbaTuple.red * 255.0)))
    let g: Int = Int(roundf(Float(rgbaTuple.green * 255.0)))
    let b: Int = Int(roundf(Float(rgbaTuple.blue * 255.0)))
    let a: Float = Float(rgbaTuple.alpha)
    return (r, g, b, a)
  }
  
  public func toHSBA() -> (hue : Float, saturation: Float, brightness: Float, alpha: Float) {
    var h: CGFloat = 0.0
    var s: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 0.0
    self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return (Float(h), Float(s), Float(b), Float(a))
  }
  
  public func toHEX() -> String {
    let rgbaTuple = toRGBA()
    let r: Int = Int(roundf(Float(rgbaTuple.red * 255.0)))
    let g: Int = Int(roundf(Float(rgbaTuple.green * 255.0)))
    let b: Int = Int(roundf(Float(rgbaTuple.blue * 255.0)))
    let hexString: String = String(format: "%02x%02x%02x", r, g, b)
    return hexString
  }
  
}
