//
//  UIImageView+Round.swift
//  passthepotato-ios
//
//  Created by Adam Novak on 2022/11/08.
//

import Foundation
import UIKit

extension UIImageView {
    func becomeRound() {
        frame.size.height = frame.size.width
        layer.cornerRadius = frame.size.height / 2
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }
}

extension UIButton {
    func becomeRound() {
        frame.size.height = frame.size.width
        layer.cornerRadius = frame.size.height / 2
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }
}
