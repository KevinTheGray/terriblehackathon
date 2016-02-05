//
//  AppInfo.swift
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

public enum BuildConfigurations {
  public static let Debug = "DEBUG"
  public static let Staging = "STAGING"
  public static let Release = "RELEASE"
}

public enum InfoKeys {
  public static let Configuration = "Configuration"
  public static let BundleIdentifier = "CFBundleIdentifier"
  public static let BundleName = "CFBundleName"
  public static let DeviceFamily = "UIDeviceFamily"
  public static let VersionString = "CFBundleShortVersionString"
  public static let BuildNumberString = "CFBundleVersion"
}

public class AppInfo {
  
  public class func currentBuildConfiguration() -> String {
    var config: String! = BuildConfigurations.Release
    if let infoValue: AnyObject = infoValue(forKey: InfoKeys.Configuration,
      defaultValue: BuildConfigurations.Release) {
        config = infoValue as! String
    }
    return config
  }
  
  public class func infoValue(forKey key: String) -> AnyObject? {
    return infoValue(forKey: key, defaultValue: nil)
  }
  
  public class func infoValue(forKey key: String, defaultValue: AnyObject?) -> AnyObject? {
    let mainBundle: NSBundle = NSBundle.mainBundle()
    var configValue: AnyObject? = defaultValue
    if let infoDictionary: [NSObject : AnyObject] = mainBundle.infoDictionary {
      configValue = infoDictionary[key]
    }
    return configValue
  }
}
