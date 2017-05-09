//
//  CourseOverviewTableViewDelegate.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/9/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

class CourseOverviewTableViewDelegate: NSObject, UITableViewDelegate {
    
    var course: Course
    
    init(course: Course) {
        self.course = course
        super.init()
    }
    
    let widthContraint: CGFloat = 16
    let heightConstraint: CGFloat = 16
    let spaceBetweenTitleAndText: CGFloat = 8
    let titleLabelHeight: CGFloat = 21
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return computeCellHeight(title: course.title, text: course.summary)
        case 1:
            return 160
        default: return 0
        }
    }
    
    func computeCellHeight(title: String, text: String) -> CGFloat {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - widthContraint - 12, height: CGFloat.greatestFiniteMagnitude))
        
        label.text = text
        
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.sizeToFit()
        
        return label.bounds.height + titleLabelHeight + spaceBetweenTitleAndText + heightConstraint * 2
        
    }

}
