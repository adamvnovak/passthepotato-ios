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
    let passer: User
    let receiver: User
    let timestamp: Date
}
