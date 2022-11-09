//
//  AuthContext.swift
//  mist-ios
//
//  Created by Adam Novak on 2022/05/25.
//

import Foundation

struct AuthContext {
    static let APPLE_PHONE_NUMBER: String = "13103103101"
    static let APPLE_CODE: String = "123456"
    
    static var phoneNumber: String = ""
    static var verificationID: String = ""
    static var verificationCode: String = ""
    
    static func reset() {
        phoneNumber = ""
        verificationID = ""
        verificationCode = ""
    }
}
