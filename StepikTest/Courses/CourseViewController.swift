//
//  CourseViewController.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/8/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var tableViewCourseInfo: UITableView!
    
    var course: Course?
    
    var overviewTableViewDataSource: CourseOverviewTableViewDataSource?
    var overviewTableViewDelegate: CourseOverviewTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewCourseInfo.dataSource = self
        tableViewCourseInfo.delegate = self
        
        let sectionHeaderNib = UINib(nibName: "CourseTableViewSectionHeader", bundle: nil)
        tableViewCourseInfo.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: "CourseTableViewSectionHeader")
        
        let courseInfoCellNib = UINib(nibName: "CourseInfoCell", bundle: nil)
        tableViewCourseInfo.register(courseInfoCellNib, forCellReuseIdentifier: "CourseInfoCell")
    }
    
}

extension CourseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCourseInfo.dequeueReusableCell(withIdentifier: "CourseInfoCell") as! CourseInfoCell
        cell.scrollView.bounds.size.height = cell.scrollView.bounds.height - 185 - 100 - 44 - 20
        cell.scrollView.contentSize = CGSize(width: self.view.bounds.width * 3, height: cell.scrollView.bounds.height)
        
        let overviewTableView = UITableView(frame: CGRect(x: cell.scrollView.bounds.origin.x, y: cell.scrollView.bounds.origin.y, width: cell.scrollView.bounds.width, height: cell.scrollView.bounds.height))
        
        overviewTableViewDataSource = CourseOverviewTableViewDataSource(course: course!)
        overviewTableViewDelegate = CourseOverviewTableViewDelegate(course: course!)
        
        overviewTableView.dataSource = overviewTableViewDataSource
        overviewTableView.delegate = overviewTableViewDelegate
        
        cell.scrollView.addSubview(overviewTableView)
        
        return cell
    }

}

extension CourseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.size.height - videoView.bounds.size.height - self.navigationController!.navigationBar.bounds.height - UIApplication.shared.statusBarFrame.height - 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableViewCourseInfo.dequeueReusableHeaderFooterView(withIdentifier: "CourseTableViewSectionHeader") as! CourseTableViewSectionHeader
        header.courseTitle.text = course?.title
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}
