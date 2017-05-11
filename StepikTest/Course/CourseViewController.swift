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
    
    var overviewTableViewDataSource: CourseOverviewTableViewDataSource?
    var detailedTableViewDataSource: CourseDetailedTableViewDataSource?
    
    var tableViewHeader: CourseTableViewSectionHeader?
    let headerHeight: CGFloat = 100
    
    var currentPage = 0
    
    var tabs: [UIButton]?
    
    let overviewTableView = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewCourseInfo.dataSource = self
        tableViewCourseInfo.delegate = self
        
        let sectionHeaderNib = UINib(nibName: "CourseTableViewSectionHeader", bundle: nil)
        tableViewCourseInfo.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: "CourseTableViewSectionHeader")
        
        let courseInfoCellNib = UINib(nibName: "CourseInfoCell", bundle: nil)
        tableViewCourseInfo.register(courseInfoCellNib, forCellReuseIdentifier: "CourseInfoCell")
        
        getVideoThumbnail()
        
        ApiManager.shared.getInstructors(IDs: course!.instructorsIDs) { instructors in
            self.course?.instructors = instructors
            if let instructorsCell = self.overviewTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? InstructorsCell {
                instructorsCell.collectionViewInstructors.reloadData()
            }
        }
    }
    
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
        
    }
}

// MARK: - UITableViewDataSource
extension CourseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCourseInfo.dequeueReusableCell(withIdentifier: "CourseInfoCell") as! CourseInfoCell
        cell.scrollView.delegate = self
        
        cell.scrollView.bounds.size.height -= (videoView.bounds.size.height + headerHeight + self.navigationController!.navigationBar.bounds.height + UIApplication.shared.statusBarFrame.height)
        
        cell.scrollView.contentSize = CGSize(width: self.view.bounds.width * 3, height: cell.scrollView.bounds.size.height)
        
//        let overviewTableView = UITableView(frame: CGRect(x: cell.scrollView.bounds.origin.x, y: cell.scrollView.bounds.origin.y, width: cell.scrollView.bounds.width, height: cell.scrollView.bounds.height))
        overviewTableView.frame = CGRect(x: cell.scrollView.bounds.origin.x, y: cell.scrollView.bounds.origin.y, width: cell.scrollView.bounds.width, height: cell.scrollView.bounds.height)
        overviewTableView.tableFooterView = UIView()
        overviewTableViewDataSource = CourseOverviewTableViewDataSource(tableView: overviewTableView, course: course!)
        overviewTableView.dataSource = overviewTableViewDataSource
        overviewTableView.allowsSelection = false
       
        overviewTableView.estimatedRowHeight = 100
        overviewTableView.rowHeight = UITableViewAutomaticDimension
        
        let detailedTableView = UITableView(frame: CGRect(x: cell.scrollView.bounds.width, y: cell.scrollView.bounds.origin.y, width: cell.scrollView.bounds.width, height: cell.scrollView.bounds.height))
        detailedTableView.tableFooterView = UIView()
        detailedTableViewDataSource = CourseDetailedTableViewDataSource(tableView: detailedTableView, course: course!)
        detailedTableView.dataSource = detailedTableViewDataSource
        detailedTableView.reloadData()
        detailedTableView.allowsSelection = false
        
        detailedTableView.estimatedRowHeight = 100
        detailedTableView.rowHeight = UITableViewAutomaticDimension
        
        cell.scrollView.addSubview(overviewTableView)
        cell.scrollView.addSubview(detailedTableView)
        
        return cell
    }

}

// MARK: - UITableViewDelegate
extension CourseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.size.height - videoView.bounds.size.height - headerHeight - self.navigationController!.navigationBar.bounds.height - UIApplication.shared.statusBarFrame.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableViewCourseInfo.dequeueReusableHeaderFooterView(withIdentifier: "CourseTableViewSectionHeader") as! CourseTableViewSectionHeader
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
        
        if let header = tableViewHeader {
            header.sectionIndicator.frame = CGRect(x: (header.bounds.origin.x + scrollView.contentOffset.x) / 3,
                                                   y: header.bounds.size.height - header.sectionIndicator.bounds.size.height,
                                                   width: header.sectionIndicator.bounds.size.width,
                                                   height: header.sectionIndicator.bounds.size.height)
        }
        
        let pageWidth = scrollView.bounds.width
        let page = Int(scrollView.contentOffset.x / pageWidth + 1 / 2)
        
        if currentPage != page {
            
            if let header = tableViewHeader {
                UIView.animate(withDuration: 0.3, animations: {
                    header.sectionIndicator.frame = CGRect(x: CGFloat(page) * header.bounds.size.width / 3,
                                                           y: header.bounds.size.height - header.sectionIndicator.bounds.size.height,
                                                           width: header.sectionIndicator.bounds.size.width,
                                                           height: header.sectionIndicator.bounds.size.height)
                    
                })
                
                tabs?[currentPage].setTitleColor(.darkGray, for: .normal)
                tabs?[page].setTitleColor(UIColor.stepikBlueColor, for: .normal)
            }
            currentPage = page
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

