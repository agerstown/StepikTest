//
//  Course.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/1/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

class Course {
    
    var title: String
    var summary: String
    
    var cover: UIImage?
    var beginDate: Date?
    var endDate: Date?
    var coverUrl: String?
    
    var instructorsIDs: [String] = []
    var instructors: [User] = []
    
    var description: String?
    var workload: String?
    var certificate: String?
    var audience: String?
    var format: String?
    var requirements: String?
    
    var introVideoThumbnailLink: String?
    
    init(title: String, summary: String) {
        self.title = title
        self.summary = summary
    }
}
