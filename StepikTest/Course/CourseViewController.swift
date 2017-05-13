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
    @IBOutlet weak var imageViewVideoThumbnail: UIImageView!
    @IBOutlet weak var tableViewCourseInfo: UITableView!
    
    var course: Course?
    
    let overviewTableView = UITableView()
    let detailedTableView = UITableView()
    let syllabusTableView = UITableView()
    
    var overviewTableViewDataSource: CourseOverviewTableViewDataSource?
    var detailedTableViewDataSource: CourseDetailedTableViewDataSource?
    var syllabusTableViewDataSource: CourseSyllabusTableViewDataSource?
    
    var overviewTableViewDelegate: CourseInfoTableViewDelegate?
    var detailedTableViewDelegate: CourseInfoTableViewDelegate?
    var syllabusTableViewDelegate: CourseInfoTableViewDelegate?
    
    var tableViewHeader: CourseTableViewSectionHeader?
    
    let headerHeight: CGFloat = 100
    let navBarHeight: CGFloat = 44
    
    var currentPage = 0
    
    var tabs: [UIButton]?
    var courseInfoTableViews: [UITableView] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewCourseInfo.dataSource = self
        tableViewCourseInfo.delegate = self
        
        courseInfoTableViews.append(contentsOf: [overviewTableView, detailedTableView, syllabusTableView])
        
        tableViewCourseInfo.registerHeaderFooterNib(CourseTableViewSectionHeader.self)
        tableViewCourseInfo.registerNib(CourseInfoCell.self)
        
        getVideoThumbnail()
        getInstructors()
        getSections()
    }
    
    // MARK: - Getting data from server
    func getVideoThumbnail() {
        if let introVideoThumbnailLink = course?.introVideoThumbnailLink {
            videoView.isHidden = false
            ApiManager.shared.getCourseVideoThumbnail(url: introVideoThumbnailLink, imageView: imageViewVideoThumbnail)
        } else {
            videoView.frame = CGRect(x: videoView.bounds.origin.x,
                                     y: videoView.bounds.origin.y,
                                     width: videoView.bounds.size.width,
                                     height: 0)
            videoView.isHidden = true
        }
    }
    
    func getInstructors() {
        ApiManager.shared.getInstructors(IDs: course!.instructorsIDs) { instructors in
            self.course?.instructors = instructors
            self.overviewTableView.reloadData()
        }
    }
    
    func getSections() {
        ApiManager.shared.getSections(IDs: course!.sectionsIDs) { sections in
            self.course?.sections = sections
            self.syllabusTableView.reloadData()
        }
    }
    
}

// MARK: - UITableViewDataSource
extension CourseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewCourseInfo.dequeue(CourseInfoCell.self)
        cell.scrollView.delegate = self
        
        cell.scrollView.bounds.size.height -= (headerHeight + navBarHeight + UIApplication.shared.statusBarFrame.height)
        cell.scrollView.contentSize = CGSize(width: self.view.bounds.width * 3, height: cell.scrollView.bounds.size.height)
        
        overviewTableViewDataSource = CourseOverviewTableViewDataSource(tableView: overviewTableView, course: course!)
        overviewTableViewDelegate = CourseInfoTableViewDelegate(tableView: overviewTableView)
        
        initCourseInfoTableView(overviewTableView, cell: cell, dataSource: overviewTableViewDataSource!, delegate: overviewTableViewDelegate!)
        
        detailedTableViewDataSource = CourseDetailedTableViewDataSource(tableView: detailedTableView, course: course!)
        detailedTableViewDelegate = CourseInfoTableViewDelegate(tableView: detailedTableView)

        initCourseInfoTableView(detailedTableView, cell: cell, dataSource: detailedTableViewDataSource!, delegate: detailedTableViewDelegate!)
        
        syllabusTableViewDataSource = CourseSyllabusTableViewDataSource(tableView: syllabusTableView, course: course!)
        syllabusTableViewDelegate = CourseInfoTableViewDelegate(tableView: syllabusTableView)
        
        initCourseInfoTableView(syllabusTableView, cell: cell, dataSource: syllabusTableViewDataSource!, delegate: syllabusTableViewDelegate!)
        
        cell.scrollView.addSubview(overviewTableView)
        cell.scrollView.addSubview(detailedTableView)
        cell.scrollView.addSubview(syllabusTableView)
        
        return cell
    }

    func initCourseInfoTableView(_ tableView: UITableView, cell: CourseInfoCell, dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        
        let bounds = cell.scrollView.bounds
        
        if let index = courseInfoTableViews.index(of: tableView) {
            tableView.frame = CGRect(x: bounds.width * CGFloat(index),
                                     y: bounds.origin.y,
                                     width: bounds.width,
                                     height: bounds.height)
        }
        
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = false
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}

// MARK: - UITableViewDelegate
extension CourseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.size.height - headerHeight - navBarHeight - UIApplication.shared.statusBarFrame.height

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableViewCourseInfo.dequeueHeaderFooter(CourseTableViewSectionHeader.self)
        header.courseTitle.text = course?.title
        header.buttonOverview.setTitleColor(UIColor.stepikBlueColor, for: .normal)
        header.courseHeaderDelegate = self
        tabs = [header.buttonOverview, header.buttonDetailed, header.buttonSyllabus]
        tableViewHeader = header
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
}

// MARK: - UIScrollViewDelegate
extension CourseViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x > 0 {
            
            if let header = tableViewHeader {
                header.indicatorLeadingConstraint.constant = (header.bounds.origin.x + scrollView.contentOffset.x) / 3
            }
            
            let pageWidth = scrollView.bounds.width
            let page = Int(scrollView.contentOffset.x / pageWidth + 1 / 2)
            
            if currentPage != page {
                
                if let header = tableViewHeader {
                    header.indicatorLeadingConstraint.constant = CGFloat(page) * header.bounds.size.width / 3
                    
                    tabs?[currentPage].setTitleColor(.darkGray, for: .normal)
                    tabs?[page].setTitleColor(UIColor.stepikBlueColor, for: .normal)
                }
                currentPage = page
            }
        }
        if scrollView.contentOffset.y > headerHeight + navBarHeight {
            
            for tableView in courseInfoTableViews {
                tableView.isUserInteractionEnabled = true
            }
            
        } else {
            for tableView in courseInfoTableViews {
                tableView.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.3, animations: {
                    tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: 0)
                })
            }
        }
    }

}

// MARK: - CourseHeaderDelegate
extension CourseViewController: CourseHeaderDelegate {
    func tabSelected(tab: Int) {
        if let cell = tableViewCourseInfo.cellForRow(at: IndexPath(row: 0, section: 0)) as? CourseInfoCell {
            cell.scrollView.setContentOffset(CGPoint(x: CGFloat(tab) * cell.bounds.size.width, y: 0), animated: true)
        }
    }
}

