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
    
    var coverUrl: String?
    var cover: UIImage?
    
    var beginDate: Date?
    var endDate: Date?
    
    let dateFormatter = DateFormatter()
    
    var stringDate: String {
        if let beginDate = beginDate, let endDate = endDate {
            return dateFormatter.string(from: beginDate) + " " + dateFormatter.string(from: endDate)
        } else if let beginDate = beginDate {
            return "from " + dateFormatter.string(from: beginDate)
        } else if let endDate = endDate {
            return "until " + dateFormatter.string(from: endDate)
        } else {
            return ""
        }
    }
    
    var instructorsIDs: [Int] = []
    var instructors: [User] = []
    
    var sectionsIDs: [Int] = []
    var sections: [Section] = []
    
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
        dateFormatter.dateStyle = .short
    }
}
