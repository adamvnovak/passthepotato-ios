//
//  NavigationController+Prev.swift
//  mist-ios
//
//  Created by Adam Novak on 2022/10/14.
//

import Foundation
import UIKit

extension UINavigationController {
    var previousViewController: UIViewController? {
       viewControllers.count > 1 ? viewControllers[viewControllers.count - 2] : nil
    }
}
