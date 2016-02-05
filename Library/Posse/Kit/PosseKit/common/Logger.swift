//
//  Logger.swift
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


// SETUP/INSTRUCTIONS/NOTES:
//
//   * If you're not seeing any debug logs, please check that you have added the
//     value "-DDEBUG" to "Other Swift Flags" in your Target/Project build settings
//   * You can conditionally disable log levels by setting the minimum log level
//     yourself
//

import Foundation

public enum LogLevel : Int {
  case debug   = 100
  case info    = 200
  case warning = 300
  case error   = 400
  case wtf     = 500
  
  public func simpleDescription() -> String {
    switch self {
    case .debug:
      return "debug"
    case .info:
      return "info"
    case .warning:
      return "warning"
    case .error:
      return "error"
    case .wtf:
      return "wtf"
    }
  }
  
  public func label() -> String {
    switch self {
    case .debug:
      return "[DEBUG]"
    case .info:
      return " [INFO]"
    case .warning:
      return " [WARN]"
    case .error:
      return "[ERROR]"
    case .wtf:
      return "  [WTF]"
    }
  }
}

public class Logger {
  
  private var minimumLevel: LogLevel = .debug
  private var printMethodName: Bool = true
  
  
  // MARK: - Static instance
  public class var logger: Logger {
    struct Singleton {
      static let instance = Logger()
    }
    return Singleton.instance;
  }
  
  
  // MARK: - Configuration
  public func setMinimumLevel(logLevel: LogLevel) {
    self.minimumLevel = logLevel
  }
  
  public func printMethodName(printFlag: Bool) {
    self.printMethodName = printFlag
  }
  
  
  // MARK: - Instance methods
  public func log<T>(logLevel: LogLevel, @autoclosure message: () -> T, _
    filename: String? = __FILE__, line: Int? = __LINE__,  function: String? = __FUNCTION__) {
      if (logLevel.rawValue >= self.minimumLevel.rawValue) {
        var logCurrentFile: String = "UNKNOWN"
        if filename != nil {
          let url: NSURL = NSURL(fileURLWithPath: filename!)
          if url.lastPathComponent != nil {
            logCurrentFile = url.lastPathComponent!
          }
        }
        var logMessage = ""
        logMessage += "\(logLevel.label()) "
        logMessage += "[\(logCurrentFile):\(line!)"
        if (self.printMethodName) {
          logMessage += "|\(function!)"
        }
        logMessage += "] "
        logMessage += "\(message())"
        
        Swift.print(logMessage)
      }
  }
  
  public func debug<T>(@autoclosure message: () -> T, _
    filename: String? = __FILE__, line: Int? = __LINE__,  function: String? = __FUNCTION__) {
      #if DEBUG
      self.log(.debug, message: message, filename, line: line, function: function)
      #endif
  }

  public func info<T>(@autoclosure message: () -> T, _
    filename: String? = __FILE__, line: Int? = __LINE__,  function: String? = __FUNCTION__) {
      self.log(.info, message: message, filename, line: line, function: function)
  }

  public func warning<T>(@autoclosure message: () -> T, _
    filename: String? = __FILE__, line: Int? = __LINE__,  function: String? = __FUNCTION__) {
      self.log(.warning, message: message, filename, line: line, function: function)
  }
  
  public func error<T>(@autoclosure message: () -> T, _
    filename: String? = __FILE__, line: Int? = __LINE__,  function: String? = __FUNCTION__) {
      self.log(.error, message: message, filename, line: line, function: function)
  }

  public func wtf<T>(@autoclosure message: () -> T, _
    filename: String? = __FILE__, line: Int? = __LINE__,  function: String? = __FUNCTION__) {
      self.log(.wtf, message: message, filename, line: line, function: function)
  }
  
  public func print<T>(@autoclosure message: () -> T) {
    Swift.print(message())
  }
  
  
  // MARK: - Class methods
  public class func debug<T>(@autoclosure message: () -> T, _
    filename: String? = __FILE__, line: Int? = __LINE__,  function: String? = __FUNCTION__) {
      #if DEBUG
      Logger.logger.log(.debug, message: message, filename, line: line, function: function)
      #endif
  }

  public class func info<T>(@autoclosure message: () -> T, _
    filename: String? = __FILE__, line: Int? = __LINE__,  function: String? = __FUNCTION__) {
      Logger.logger.log(.info, message: message, filename, line: line, function: function)
  }
  
  public class func warning<T>(@autoclosure message: () -> T, _
    filename: String? = __FILE__, line: Int? = __LINE__,  function: String? = __FUNCTION__) {
      Logger.logger.log(.warning, message: message, filename, line: line, function: function)
  }
  
  public class func error<T>(@autoclosure message: () -> T, _
    filename: String? = __FILE__, line: Int? = __LINE__,  function: String? = __FUNCTION__) {
      Logger.logger.log(.error, message: message, filename, line: line, function: function)
  }
  
  public class func wtf<T>(@autoclosure message: () -> T, _
    filename: String? = __FILE__, line: Int? = __LINE__,  function: String? = __FUNCTION__) {
      Logger.logger.log(.wtf, message: message, filename, line: line, function: function)
  }
  
  public class func print<T>(@autoclosure message: () -> T) {
    Logger.logger.print(message)
  }
  
  
  // MARK: - Informational
  public class func appInfo() {
    Swift.print(" Build Information:")
    Swift.print("  • Project Configuration = \(AppInfo.currentBuildConfiguration())")
    Swift.print("  • App Version = \(AppInfo.infoValue(forKey: InfoKeys.VersionString)!)")
    Swift.print("  • Build # = \(AppInfo.infoValue(forKey: InfoKeys.BuildNumberString)!)")
    Swift.print("\n")
  }

  
  // MARK: - Fun Times
  public class func posse() {
    return posse("NYC")
  }
  public class func posse(city: String) {
    var out: String = "\n" +
      " ████ ████ ████ ████ █████\n" +
      " █  █ █  █ █    █    █    \n" +
      " ████ █  █  ██   ██  ███  \n" +
      " █    █  █    █    █ █    \n" +
      " █    ████ ████ ████ █████\n\n"
    out += " The following is a Posse production\n http://goposse.com | \(city.uppercaseString)\n ----\n"
    Swift.print(out)
  }  
}
