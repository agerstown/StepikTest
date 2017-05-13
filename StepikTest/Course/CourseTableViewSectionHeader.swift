//
//  CourseTableViewSectionHeader.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/9/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

protocol CourseHeaderDelegate: class {
    func tabSelected(tab: Int)
}

class CourseTableViewSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonOverview: UIButton!
    @IBOutlet weak var buttonDetailed: UIButton!
    @IBOutlet weak var buttonSyllabus: UIButton!
    
    weak var courseHeaderDelegate: CourseHeaderDelegate?
    
    // MARK: - Actions
    @IBAction func buttonOverviewTapped(_ sender: UIButton) {
        courseHeaderDelegate?.tabSelected(tab: 0)
    }
    
    @IBAction func buttonDetailedTapped(_ sender: UIButton) {
        courseHeaderDelegate?.tabSelected(tab: 1)
    }
    
    @IBAction func buttonSyllabusTapped(_ sender: UIButton) {
        courseHeaderDelegate?.tabSelected(tab: 2)
    }
    
}
