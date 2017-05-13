//
//  CourseDetailedTableViewDataSource.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/10/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

class CourseDetailedTableViewDataSource: NSObject, UITableViewDataSource {

    let course: Course
    
    let defaultCell = UINib(nibName: "DefaultCourseInfoItemCell", bundle: nil)
    
    var courseInfoItems: [CourseInfoItem] = []
    
    init(tableView: UITableView, course: Course) {
        self.course = course
        
        tableView.register(defaultCell, forCellReuseIdentifier: "DefaultCourseInfoItemCell")
        
        if let description = course.description {
            let item = CourseInfoItem(title: "Description", text: description)
            courseInfoItems.append(item)
        }
        if let workload = course.workload {
            let item = CourseInfoItem(title: "Workload", text: workload)
            courseInfoItems.append(item)
        }
        if let certificate = course.certificate {
            let item = CourseInfoItem(title: "Certificate", text: certificate)
            courseInfoItems.append(item)
        }
        if let audience = course.audience {
            let item = CourseInfoItem(title: "Audience", text: audience)
            courseInfoItems.append(item)
        }
        if let format = course.format {
            let item = CourseInfoItem(title: "Format", text: format)
            courseInfoItems.append(item)
        }
        if let requirements = course.requirements {
            let item = CourseInfoItem(title: "Requirements", text: requirements)
            courseInfoItems.append(item)
        }
        
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseInfoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCourseInfoItemCell") as! DefaultCourseInfoItemCell
        cell.labelTitle.text = courseInfoItems[indexPath.row].title
        cell.labelText.text = courseInfoItems[indexPath.row].text
        return cell
    }
}
