//
//  CourseSyllabusTableViewDataSource.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/13/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

class CourseSyllabusTableViewDataSource: NSObject, UITableViewDataSource {
    
    let course: Course
    
    let cell = UINib(nibName: "SectionCell", bundle: nil)
    
    init(tableView: UITableView, course: Course) {
        self.course = course
        tableView.register(cell, forCellReuseIdentifier: "SectionCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
        if let section = course.sections.filter( { $0.index == indexPath.row + 1 } ).first {
            cell.labelSectionTitle.text = "\(indexPath.row + 1). " + section.title
        }
        return cell
    }
    
}
