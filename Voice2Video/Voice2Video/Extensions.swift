//
//  Extensions.swift
//  Voice2Video
//
//  Created by Janeta Paul Vincent Paul on 4/2/22.
//

import Foundation
import SwiftUI


//extension for Date class
extension Date {
    func toString(dateFormat format: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }// func toString
}//extension Date

//to find the current view controller as the presenter for the alert message
extension UIApplication {
    // redefine keyWindow since its depreceated since iOS 13.2
    var keyWindow: UIWindow? {
            // Get connected scenes
            return UIApplication.shared.connectedScenes
                // Keep only active scenes, onscreen and visible to the user
                .filter { $0.activationState == .foregroundActive }
                // Keep only the first `UIWindowScene`
                .first(where: { $0 is UIWindowScene })
                // Get its associated windows
                .flatMap({ $0 as? UIWindowScene })?.windows
                // Finally, keep only the key window
                .first(where: \.isKeyWindow)
        }// var keyWindow
    
    // returns the current view controller
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let tabController = controller as? UITabBarController {
          return topViewController(controller: tabController.selectedViewController)
        }
        if let navController = controller as? UINavigationController {
          return topViewController(controller: navController.visibleViewController)
        }
        if let presented = controller?.presentedViewController {
          return topViewController(controller: presented)
        }
        return controller
      }
}// extension UIApplication
