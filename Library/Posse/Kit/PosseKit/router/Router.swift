//
//  Router.swift
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
import Haitch

public class Router: NSObject {

  public enum NavigationType {
    case Push
    case Modal
    case SystemModal
  }
  
  public var routeBaseUrl: String = ""
  private var registeredRoutes: [Route] = []
  
  
  // MARK: - Route registration
  public func registerRoute(route: Route) {
    registeredRoutes.append(route)
  }

  public func registerRoutes(routes: Route...) {
    registeredRoutes.appendContentsOf(routes)
  }

  
  // MARK: - Route retrieval
  /**
    Retrieves a registered route from the list of registered routes if one is found to have a pathFormat
    value that matches the provided path.
    
    Wildcard routes can be specified using the wildcard format '{key}'. For example: '/users/{id}'. Upon matching,
    any values found in the path for the wildcard index will be retained and returned in a Dictionary.
  
    NOTE: routes are matched in the order that they have been registered with the system. This is particularly 
    relevant when using wildcards. As a general rule, more specific routes should be added to the top of the list.
  
    Example(s):
    - if you have registered the route with the wildcard format '/users/{id}' before a route with the format 
      '/users/search' then the router will return the route matching '/users/{id}' over the direct match.
  
    
    - parameter path:  the path to match against all registered route pathFormat values
  
    - returns: a tuple containing the matched route along with any matched wildcard values (if found),
      or nil if no route was matched
  */
  public func routeForPath(path: String) -> (route: Route, wildcardValues: [String : String]?)? {
    for (_, route): (Int, Route) in self.registeredRoutes.enumerate() {
      if route.pathFormat == path {
        return (route: route, wildcardValues: nil)
      } else if route.hasWildcardFormat() {
        var wildcardValues: [String : String] = [:]
        if let pathComponents: [String] = path.urlPathComponents() {
        let routeComponents: [String] = route.pathFormat.urlPathComponents()!
          if pathComponents.count == routeComponents.count {
            var isMatch: Bool = true
            for (cidx, routeComponent): (Int, String) in routeComponents.enumerate() {
              let isWildcard: Bool = isWildcardPart(part: routeComponent)
              if !isWildcard && pathComponents[cidx] != routeComponent {
                isMatch = false
                break
              } else if isWildcard {
                let range: Range<String.Index> = Range<String.Index>(start: routeComponent.startIndex.advancedBy(1),
                  end: routeComponent.endIndex.advancedBy(-1))
                let wildcardKey: String = routeComponent.substringWithRange(range)
                wildcardValues[wildcardKey] = pathComponents[cidx]
              }
            }
            if isMatch {
              return (route: route, wildcardValues: wildcardValues)
            }
          }
        }
      }
    }
    // no route with a matching path format was found
    return nil
  }
  
  
  // MARK: - Navigation
  public func navigate(onto viewController: UIViewController, path: String, navigationType: NavigationType,
    userInfo: [String: AnyObject]?) {
      navigate(onto: viewController, url: urlForPath(path), navigationType: navigationType, userInfo: userInfo, animated: true)
  }
  
  public func navigate(path path: String, navigationType: NavigationType, userInfo: [String: AnyObject]?) {
    navigate(url: urlForPath(path), navigationType: navigationType, userInfo: userInfo, animated: true)
  }
  
  public func navigate(onto viewController: UIViewController, path: String, navigationType: NavigationType, userInfo: [String: AnyObject]?, animated: Bool) {
    navigate(onto: viewController, url: urlForPath(path), navigationType: navigationType, userInfo: userInfo, animated: true)
  }
  
  public func navigate(path path: String, navigationType: NavigationType, userInfo: [String: AnyObject]?, animated: Bool) {
    navigate(url: urlForPath(path), navigationType: navigationType, userInfo: userInfo, animated: animated)
  }
  
  public func navigate(url url: String, navigationType: NavigationType, userInfo: [String: AnyObject]?) {
    navigate(url: url, navigationType: navigationType, userInfo: userInfo, animated: true)
  }
  
  public func navigate(url url: String, navigationType: NavigationType, userInfo: [String: AnyObject]?, animated: Bool) {
    if let topViewController: UIViewController = getTopViewController() {
      navigate(onto: topViewController, url: url, navigationType: navigationType, userInfo: userInfo, animated: animated)
    } else {
      Logger.warning("Your application has no top ViewController or there is a problem with the ViewController hierarchy.")
    }
  }
  
  public func navigate(onto topViewController: UIViewController, url: String, navigationType: NavigationType, userInfo: [String: AnyObject]?, animated: Bool) {

    if let viewController: UIViewController = self.respondingController(url: url, userInfo: userInfo) {
      transitionToViewController(viewController, ontoViewController: topViewController,
        navigationType: navigationType, animated: animated)
    } else {
      Logger.error("Could not find a responding controller for '\(url)'.")
    }
    
  }
  
  public func respondingController(url url: String, userInfo: [String: AnyObject]?) -> UIViewController? {

    var path: String = url
    var isValidUrl: Bool = false
    if let testUrl: NSURL = NSURL(string: url) {
      if testUrl.path != nil {
        path = testUrl.path!
        isValidUrl = (testUrl.host != nil)
      }
    }
    
    var mergedUserInfo: [String : AnyObject] = [:]
    
    if let routeDetails: (route: Route, wildcardValues: [String : String]?) = routeForPath(path) {
      let route: Route = routeDetails.route
      
      if userInfo != nil {
        mergedUserInfo = userInfo!
      }
      if routeDetails.wildcardValues != nil {
        mergedUserInfo = mergedUserInfo.union(routeDetails.wildcardValues!)
      }
      
      if route.controllerClass is NetworkedViewController.Type {
        
        if !isValidUrl {
          Logger.warning("'\(url)' is not a valid URL. Did you mean to call navigate with path?")
          return nil
        }
        
        // join all the params into one dictionary
        // NOTE: the query string parameters ALWAYS supercede the default parameters
        var mergedParams: [String : String] = route.defaultParameters
        let queryParams: [String : String] = url.queryParametersDictionary()
        if queryParams.count > 0 {
          mergedParams = mergedParams.union(queryParams)
        }
        
        // strip the query string component from the url as we'll be adding them back in
        var strippedUrl: String = url
        if let urlComponents: NSURLComponents = NSURLComponents(string: url) {
          urlComponents.query = nil
          if urlComponents.string != nil {
            strippedUrl = urlComponents.string!
          }
        }
        
        mergedUserInfo = mergedUserInfo.union(mergedParams)
        
        // the router only supports GET requests on navigate
        let requestParams: RequestParams = RequestParams(dictionary: mergedParams)
        let request: Request = Request.Builder()
          .url(url: strippedUrl, params: requestParams)
          .method(Method.GET)
          .build()
        
        let networkControllerClass: NetworkedViewController.Type = routeDetails.route.controllerClass as! NetworkedViewController.Type
        let networkedController: NetworkedViewController = networkControllerClass.init(request: request)
        networkedController.executingRoute = route
        networkedController.userInfo = mergedUserInfo
        
        return networkedController
        
      } else if route.controllerClass is RoutableViewController.Type {
        let routableViewController: RoutableViewController = route.controllerClass.init() as! RoutableViewController

        routableViewController.userInfo = mergedUserInfo
        routableViewController.executingRoute = route

        return routableViewController
      
      } else {
        
        let viewController: UIViewController = route.controllerClass.init()
        if let navigationController: UINavigationController = viewController as? UINavigationController {
          if let routeableViewController: RoutableViewController = navigationController.topViewController as? RoutableViewController {
            routeableViewController.userInfo = mergedUserInfo
            routeableViewController.executingRoute = route

            return routeableViewController
          }
        }

        return viewController
      }
    } else {
      Logger.warning("No matching route for path '\(path)' was found.")
    }
    return nil
  }

  
  
  // MARK: - Transition methods
  private func transitionToViewController(viewcontroller: UIViewController, ontoViewController: UIViewController,
    navigationType: NavigationType? = .Push, animated: Bool) {
      if navigationType == .Push {
        if let navigationController: UINavigationController = ontoViewController.navigationController {
          navigationController.pushViewController(viewcontroller, animated: animated)
        }
      } else if navigationType == .Modal || navigationType == .SystemModal {
        if navigationType == .SystemModal {
          viewcontroller.setNeedsStatusBarAppearanceUpdate()
          ontoViewController.presentViewController(viewcontroller, animated: true, completion: nil)
        } else {
          viewcontroller.setNeedsStatusBarAppearanceUpdate()
          ontoViewController.presentModal(viewcontroller, style: .Custom)
        }
      }
  }
  
  private func getTopViewController() -> UIViewController? {
    let sharedApplication: UIApplication = UIApplication.sharedApplication()
    if let rootViewController: UIViewController = sharedApplication.keyWindow?.rootViewController {
      if let navigationController: UINavigationController = rootViewController as? UINavigationController {
        return navigationController.visibleViewController
      } else {
        return rootViewController
      }
    }
    return nil
  }
  
  
  // MARK: - Helpers
  func isWildcardPart(part part: String) -> Bool {
    return part.hasPrefix("{") && part.hasSuffix("}")
  }
  
  func urlForPath(path: String) -> String {
    var baseUrl = self.routeBaseUrl
    if baseUrl.hasSuffix("/") {
      baseUrl = baseUrl.chop()
    }
    return "\(baseUrl)\(path)"
  }
  
}
