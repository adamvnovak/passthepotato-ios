////
////  CustomSwiftMessages.swift
////  mist-ios
////
////  Created by Adam Novak on 2022/05/29.
////
//
//import Foundation
//import SwiftMessages
//import MapKit
//
////MARK: Errors
//
//struct CustomSwiftMessages {
//    
//    static func displayError(_ errorDescription: String, _ recoveryDescription: String) {
//        print(errorDescription)
//        createAndShowError(title: errorDescription, body: recoveryDescription, emoji: "😔")
//    }
//
//    static func displayError(_ error: Error) {
//        if let apiError = error as? APIError {
//            print(apiError)
//            createAndShowError(title: apiError.errorDescription!, body: apiError.recoverySuggestion!, emoji: "😔")
//        } else if let mkError = error as? MKError {
//            if mkError.errorCode == 4 {
//                createAndShowError(title: "something went wrong", body: "try again later", emoji: "😔")
//            } else {
//                print(error.localizedDescription)
//            }
//        } else {
//            print(error.localizedDescription)
//            createAndShowError(title: "something went wrong", body: "try again later", emoji: "😔")
//        }
//    }
//
//    private static func createAndShowError(title: String, body: String, emoji: String) {
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//            let errorMessageView: CustomCardView = try! SwiftMessages.viewFromNib()
//            errorMessageView.configureTheme(.error)
//            errorMessageView.applyMediumShadow()
//            errorMessageView.configureContent(title: title,
//                                         body: body,
//                                         iconText: emoji)
//            errorMessageView.button?.isHidden = true
////            errorMessageView.dismissButton.tintColor = .white
////            errorMessageView.dismissAction = {
////                SwiftMessages.hide()
////            }
//
//            var messageConfig = SwiftMessages.Config()
//            messageConfig.presentationContext = .window(windowLevel: .normal)
//            messageConfig.presentationStyle = .top
//            messageConfig.duration = .seconds(seconds: 3)
//
//            SwiftMessages.hideAll()
//            SwiftMessages.show(config: messageConfig, view: errorMessageView)
//        }
//    }
//}
//
////MARK: - Info
//
//extension CustomSwiftMessages {
//
//
//    static func showUpdateAvailableCard() {
//        let url = Constants.downloadLink
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//            let messageView: CustomCenteredView = try! SwiftMessages.viewFromNib()
//            messageView.configureContent(title: "a new update is available 👀", body: "", iconText: "")
//            messageView.customConfig(approveText: "download", dismissText: "")
//            messageView.approveAction = {
//                UIApplication.shared.open(url as URL)
//            }
//            messageView.configureBackgroundView(width: 250)
//            messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
//            messageView.backgroundView.layer.cornerRadius = 10
//            SwiftMessages.show(config: middlePresentationConfig(), view: messageView)
//        }
//    }
//
//    static func showInfoCard(_ title: String, _ body: String, emoji: String) {
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//            let messageView: CustomCardView = try! SwiftMessages.viewFromNib()
//            messageView.configureTheme(backgroundColor: .white, foregroundColor: Constants.Color.mistBlack)
//            messageView.applyMediumShadow()
//            messageView.button?.isHidden = true
//            messageView.configureContent(title: title,
//                                         body: body,
//                                         iconText: emoji)
////            messageView.dismissButton.tintColor = Constants.Color.mistBlack
////            messageView.dismissAction = {
////                SwiftMessages.hide()
////                onDismiss()
////            }
//
//            var messageConfig = SwiftMessages.Config()
//            messageConfig.presentationContext = .window(windowLevel: .normal)
//            messageConfig.presentationStyle = .top
//            messageConfig.duration = .seconds(seconds: 3)
//
//            SwiftMessages.show(config: messageConfig, view: messageView)
//        }
//    }
//
//    static func showInfoCentered(_ title: String, _ body: String, emoji: String, dismissButtonTitle: String = "ok", onDismiss: @escaping () -> Void = { }) {
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//            let messageView: CustomCenteredView = try! SwiftMessages.viewFromNib()
//            messageView.configureContent(title: title, body: body, iconText: emoji)
//            messageView.customConfig(approveText: dismissButtonTitle, dismissText: "")
//            messageView.approveAction = {
//                SwiftMessages.hide()
//                onDismiss()
//            }
//            messageView.configureBackgroundView(width: 300)
//            messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
//            messageView.backgroundView.layer.cornerRadius = 10
//            SwiftMessages.show(config: middlePresentationConfig(), view: messageView)
//        }
//    }
//}
//
////MARK: - Success
//
//extension CustomSwiftMessages {
//
//    static func showSuccess(_ title: String, _ body: String) {
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//            let messageView: CustomCenteredView = try! SwiftMessages.viewFromNib()
//            messageView.applyMediumShadow()
//            messageView.button?.isHidden = true
//            messageView.configureContent(title: title,
//                                         body: body,
//                                         iconText: "😇")
//            messageView.dismissButton.tintColor = .white
//            messageView.dismissAction = {
//                SwiftMessages.hide()
//            }
//
//            var messageConfig = SwiftMessages.Config()
//            messageConfig.presentationContext = .window(windowLevel: .normal)
//            messageConfig.presentationStyle = .top
//            messageConfig.duration = .seconds(seconds:2)
//
//            SwiftMessages.show(config: messageConfig, view: messageView)
//        }
//    }
//}
//
////MARK: - IDK
//
//extension CustomSwiftMessages {
//
//    static func showPermissionRequest(permissionType: PermissionType, onResponse: @escaping (Bool) -> Void) {
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//
//            let messageView: CustomCenteredView = try! SwiftMessages.viewFromNib()
//
//            var title, body, emoji: String
//            switch permissionType {
//            case .userLocation:
//                title = "share your current location"
//                body = "this makes finding and posting mists even easier"
//                emoji = "📍"
//                messageView.customConfig(approveText: "sure", dismissText: "no thanks")
//            case .contacts:
//                title = "tag friends even if they aren't on mist"
//                body = "find a mist about your friend? share your contacts so you can tag friends who don't have mist yet"
//                emoji = "＠"
//                messageView.customConfig(approveText: "sure", dismissText: "nah")
//            case .dmNotificationsAfterDm:
//                title = "enable notifications"
//                body = "find out when they\nget back with you"
//                emoji = "💬"
//                messageView.customConfig(approveText: "sure", dismissText: "nah")
//            case .dmNotificationsAfterNewPost:
//                title = "enable notifications"
//                body = "find out if someone\nreplies to or\ncomments on your mist"
//                emoji = "👀"
//                messageView.customConfig(approveText: "sure", dismissText: "i'd rather mist out")
//            case .mistboxNotifications:
//                title = "enable notifications"
//                body = "find out when someone drops a mist with one of your keywords"
//                emoji = "💌"
//                messageView.customConfig(approveText: "sure", dismissText: "i'd rather mist out")
//            case .newpostUserLocation:
//                title = "mists require a location"
//                body = "share your current location or drop a pin on the map"
//                emoji = "📍"
//                messageView.customConfig(approveText: "share location", dismissText: "drop a pin")
//            case .feedNotifications:
//                title = "enable notifications"
//                body = "find out if your friend\ntags you in a mist"
//                emoji = "👀"
//                messageView.customConfig(approveText: "sure", dismissText: "i'd rather mist out")
//            }
//
//            messageView.configureContent(title: title, body: body, iconText: emoji)
//            messageView.approveAction = {
//                SwiftMessages.hide()
//                onResponse(true)
//            }
//            messageView.dismissAction = {
//                SwiftMessages.hide()
//                onResponse(false)
//            }
//
//            messageView.configureBackgroundView(width: 300)
//            messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
//            messageView.backgroundView.layer.cornerRadius = 10
//            SwiftMessages.show(config: middlePresentationConfig(), view: messageView)
//        }
//    }
//
//    static func showBlockPrompt(completion: @escaping (Bool) -> Void) {
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//            let messageView: CustomCenteredView = try! SwiftMessages.viewFromNib()
//            let title = "are you sure you want to block this user?"
//            let body = "you won't be able to see their profile or your conversation again"
//            messageView.configureContent(title: title, body: body, iconText: "✋")
//            messageView.customConfig(approveText: "i'm sure", dismissText: "nevermind")
//            messageView.approveAction = {
//                SwiftMessages.hide()
//                completion(true)
//            }
//            messageView.dismissAction = {
//                SwiftMessages.hide()
//                completion(false)
//            }
//
//            messageView.configureBackgroundView(width: 300)
//            messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
//            messageView.backgroundView.layer.cornerRadius = 10
//            SwiftMessages.show(config: middlePresentationConfig(), view: messageView)
//        }
//    }
//
//    static func showAlreadyBlockedMessage() {
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//            let messageView: CustomCenteredView = try! SwiftMessages.viewFromNib()
//            let title = "you can't chat with this user"
//            let body = "either you or the author have blocked each other"
//            messageView.configureContent(title: title, body: body, iconText: "😕")
//            messageView.customConfig(approveText: "", dismissText: "ok")
//            messageView.approveAction = {
//                SwiftMessages.hide()
//            }
//            messageView.dismissAction = {
//                SwiftMessages.hide()
//            }
//
//            messageView.configureBackgroundView(width: 300)
//            messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
//            messageView.backgroundView.layer.cornerRadius = 10
//            SwiftMessages.show(config: middlePresentationConfig(), view: messageView)
//        }
//    }
//
//    static func showAlreadyDmdMessage() {
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//            let messageView: CustomCenteredView = try! SwiftMessages.viewFromNib()
//            let title = "you already responded to this mist"
//            let body = "check your dms to keep chatting"
//            messageView.configureContent(title: title, body: body, iconText: "😉")
//            messageView.customConfig(approveText: "", dismissText: "ok")
//            messageView.approveAction = {
//                SwiftMessages.hide()
//            }
//            messageView.dismissAction = {
//                SwiftMessages.hide()
//            }
//
//            messageView.configureBackgroundView(width: 300)
//            messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
//            messageView.backgroundView.layer.cornerRadius = 10
//            SwiftMessages.show(config: middlePresentationConfig(), view: messageView)
//        }
//    }
//
//    static func showNoMoreOpensMessage() {
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//            let messageView: CustomCenteredView = try! SwiftMessages.viewFromNib()
//            let title = "you're out of opens!"
//            let body = "your 5 opens refresh daily at 10am"
//            messageView.configureContent(title: title, body: body, iconText: "🤷‍♀️")
//            messageView.customConfig(approveText: "", dismissText: "ok")
//            messageView.approveAction = {
//                SwiftMessages.hide()
//            }
//            messageView.dismissAction = {
//                SwiftMessages.hide()
//            }
//
//            messageView.configureBackgroundView(width: 300)
//            messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
//            messageView.backgroundView.layer.cornerRadius = 10
//            SwiftMessages.show(config: middlePresentationConfig(), view: messageView)
//        }
//    }
//
//    static func showAlert(title: String, body: String, emoji: String, dismissText: String, approveText: String, onDismiss: @escaping () -> Void, onApprove: @escaping () -> Void) {
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//            let messageView: CustomCenteredView = try! SwiftMessages.viewFromNib()
//            messageView.configureContent(title: title, body: body, iconText: emoji)
//
//            let approveString = CustomAttributedString.createFor(text: approveText, fontName: Constants.Font.Heavy, size: 20)
//            let dismissString = CustomAttributedString.createFor(text: dismissText, fontName: Constants.Font.Medium, size: 19)
//            messageView.approveButton.setAttributedTitle(approveString, for: .normal)
//            messageView.dismissButton.setAttributedTitle(dismissString, for: .normal)
//            messageView.approveAction = {
//                SwiftMessages.hide()
//                onApprove()
//            }
//            messageView.dismissAction = {
//                SwiftMessages.hide()
//                onDismiss()
//            }
//
//            messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
//            messageView.backgroundView.layer.cornerRadius = 10
//            messageView.configureBackgroundView(width: 300)
//            SwiftMessages.show(config: middlePresentationConfig(), view: messageView)
//        }
//    }
//
//    static func showSettingsAlertController(title: String, message: String, on controller: UIViewController) {
//
//      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//      let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
//      let settingsAction = UIAlertAction(title: NSLocalizedString("settings", comment: ""), style: .default) { (UIAlertAction) in
//          UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
//      }
//
//      alertController.addAction(cancelAction)
//      alertController.addAction(settingsAction)
//      controller.present(alertController, animated: true, completion: nil)
//   }
//
//    //MARK: - Helpers
//
//    static func middlePresentationConfig() -> SwiftMessages.Config {
//        var config = SwiftMessages.defaultConfig
//        config.presentationStyle = .center
//        config.duration = .forever
//        config.dimMode = .blur(style: .dark, alpha: 0.5, interactive: false)
//        config.interactiveHide = false
//        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
//        return config
//    }
//
//    static func badgeConfig() -> SwiftMessages.Config {
//        var config = SwiftMessages.defaultConfig
//        config.presentationStyle = .center
//        config.duration = .forever
//        config.dimMode = .blur(style: .dark, alpha: 0.5, interactive: false)
//        config.interactiveHide = true
//        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
//        return config
//    }
//
//    //MARK: - Badges
//
//    static func displayBadgePopup(name: String, badge: String) {
//        DispatchQueue.main.async { //ensures that these ui actions occur on the main thread
//            let messageView: SwiftMessagesBadgeView = try! SwiftMessages.viewFromNib()
//            var title = ""
//            var body = ""
//            if badge == "💌" {
//                title = "love, mist"
//                body = name + " participated in the on-campus event \"love, mist\" by entering a special access code"
//            }
//            if badge == "🥳" {
//                title = ""
//                body = "this mist turned into a connection!"
//            }
//            messageView.configureContent(title: title, body: body, iconText: badge)
//            messageView.badgeConfig()
//            messageView.dismissAction = {
//                SwiftMessages.hide()
//            }
//
//            messageView.configureBackgroundView(width: 250)
//            messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
//            messageView.backgroundView.layer.cornerRadius = 10
//            SwiftMessages.show(config: badgeConfig(), view: messageView)
//        }
//    }
//
//}
