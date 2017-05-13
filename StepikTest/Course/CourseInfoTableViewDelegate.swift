//
//  CourseInfoTableViewDelegate.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/13/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

class CourseInfoTableViewDelegate: NSObject, UITableViewDelegate {
    
    var tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            tableView.isUserInteractionEnabled = false
        }
    }
}
