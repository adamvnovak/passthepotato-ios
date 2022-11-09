//
//  PassService.swift
//  passthepotato-ios
//
//  Created by Adam Novak on 2022/11/08.
//

import Foundation

class PassService: NSObject {
    
    static var singleton = PassService()
    
    var userPasses: [Pass] = []
    var newPasses: [Pass] = []
    
    static func loadUserPasses() {
        
    }
    
    static func loadNewPasses() {
        
    }
    
}
