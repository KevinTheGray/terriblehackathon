//
//  AppDelegate.swift
//  terriblehackathon
//
//  Created by Kevin Gray on 2/5/16.
//  Copyright © 2016 terriblehackathon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  internal var window: UIWindow?
  internal var rootViewController: UIViewController!
  
  private let screen: UIScreen = UIScreen.mainScreen()
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    rootViewController = ViewController()
    
    // configure the main window
    window = UIWindow(frame: screen.bounds)
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
    return true
  }
}
