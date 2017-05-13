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
    
    let defaultCell = UINib(nibName: "DefaultCourseInfoItemCell", bundle: nil)
    
    init(tableView: UITableView, course: Course) {
        self.course = course
        tableView.register(defaultCell, forCellReuseIdentifier: "DefaultCourseInfoItemCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCourseInfoItemCell") as! DefaultCourseInfoItemCell
        cell.labelTitle.text = course.sections.filter { $0.index == indexPath.row }.first?.title
        //cell.labelText.text = courseInfoItems[indexPath.row].text
        return cell
    }
    
}
