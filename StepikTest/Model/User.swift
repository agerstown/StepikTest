//
//  User.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/10/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import Foundation

class User {
    
    var firstName: String
    var secondName: String
    var avatarLink: String
    var bio: String?
    
    init(firstName: String, secondName: String, avatarLink: String) {
        self.firstName = firstName
        self.secondName = secondName
        self.avatarLink = avatarLink
    }
    
}
