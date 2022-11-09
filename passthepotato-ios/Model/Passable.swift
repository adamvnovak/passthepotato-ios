//
//  Passable.swift
//  passthepotato-ios
//
//  Created by Adam Novak on 2022/11/08.
//

import Foundation

struct Passable: Codable {
    let id: String
    let emoji: String
    let passes: [Pass]
}
