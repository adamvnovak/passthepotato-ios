//
//  Constants.swift
//  mist-ios
//
//  Created by Adam Novak on 2022/03/12.
//

import Foundation
import UIKit

extension UIColor {
    static let accentColor = UIColor.init(named: "AccentColor")!
}

struct Constants {
    
    static let downloadLink = NSURL(string: "https://passthepotato.lol")!
    static let landingPageLink = NSURL(string: "https://passthepotato.lol")!
    
    // Note: all nib names should be the same ss their storyboard ID
    struct SBID {
        struct View {
            
        }
        struct SB {
            static let Main = "Main"
            static let Launch = "Launch"
            static let Auth = "Auth"
        }
        struct Cell {
            
        }
        struct VC {
            static let HomeNav = "HomeNavigationViewController"
            static let ConfirmCode = "ConfirmCodeViewController"
            static let ChooseFriend = "ChooseFriendViewController"
            static let AuthNavigation = "AuthNavigationViewController"
        }
        struct Segue {
            
        }
    }
}
