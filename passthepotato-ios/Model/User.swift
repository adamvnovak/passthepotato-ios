//
//  User.swift
//  passthepotato-ios
//
//  Created by Adam Novak on 2022/11/08.
//

import Foundation

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let username: String
    let phoneNumber: String
    
    static let NilUser: User = User(id: "", firstName: "", lastName: "", username: "", phoneNumber: "11111111111")
}
