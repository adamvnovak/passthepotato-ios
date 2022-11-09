//
//  AlertManager.swift
//  passthepotato-ios
//
//  Created by Adam Novak on 2022/11/09.
//

import Foundation
import UIKit

class AlertManager {
    
    static func showSettingsAlertController(title: String, message: String, on controller: UIViewController, closure: @escaping (_ approved: Bool) -> Void = { approved in } ) {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

      let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { _ in
          closure(false)
      })
      let settingsAction = UIAlertAction(title: NSLocalizedString("settings", comment: ""), style: .default) { (UIAlertAction) in
          closure(true)
          UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
      }

      alertController.addAction(cancelAction)
      alertController.addAction(settingsAction)
      controller.present(alertController, animated: true, completion: nil)
   }
    
}
