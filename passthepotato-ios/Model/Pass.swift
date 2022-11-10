//
//  Pass.swift
//  passthepotato-ios
//
//  Created by Adam Novak on 2022/11/08.
//

import Foundation

struct Pass: Codable {
    let id: String
    let passableId: String
    let passerId: String
    let receiverId: String?
    let receiverPhoneNumber: String?
    let timestamp: Date
}
