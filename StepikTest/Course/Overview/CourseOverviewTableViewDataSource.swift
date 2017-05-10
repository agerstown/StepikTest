//
//  CourseOverviewTableViewDataSource.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/9/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

class CourseOverviewTableViewDataSource: NSObject, UITableViewDataSource {
    
    var tableView: UITableView
    
    var course: Course
    
    let summaryCell = UINib(nibName: "DefaultCourseInfoItemCell", bundle: nil)
    let instructorsCell = UINib(nibName: "InstructorsCell", bundle: nil)
    
    init(tableView: UITableView, course: Course) {
        
        self.tableView = tableView
        self.course = course
        
        tableView.register(summaryCell, forCellReuseIdentifier: "DefaultCourseInfoItemCell")
        tableView.register(instructorsCell, forCellReuseIdentifier: "InstructorsCell")
        
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch(indexPath.row) {
        case 0:
            let summaryCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCourseInfoItemCell") as! DefaultCourseInfoItemCell
            summaryCell.labelTitle.text = "Summary"
            summaryCell.labelText.text = course.summary
            return summaryCell
        case 1:
            let instructorsCell = tableView.dequeueReusableCell(withIdentifier: "InstructorsCell") as! InstructorsCell
            instructorsCell.collectionViewInstructors.dataSource = self
            setInstructorsCollectionViewInsets(cell: instructorsCell)
            return instructorsCell
        default:
            return UITableViewCell()
        }
    }
    
    func setInstructorsCollectionViewInsets(cell: InstructorsCell) {
        if let flowLayout = cell.collectionViewInstructors.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let numberOfCells = CGFloat(course.instructorsIDs.count)
            let collectionViewWidth = cell.collectionViewInstructors.bounds.size.width
            let cellWidth = flowLayout.itemSize.width
            let spacing = flowLayout.minimumLineSpacing
            
            var edgeInsets: CGFloat = 0
            if numberOfCells < 4 {
                edgeInsets = (collectionViewWidth - numberOfCells * cellWidth - (numberOfCells - 1) * spacing) / (numberOfCells > 1 ? numberOfCells : 2)
            }
            
            flowLayout.sectionInset = UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets)
        }
    }
    
}

extension CourseOverviewTableViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return course.instructorsIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstructorCell", for: indexPath)
        cell.backgroundColor = UIColor.black
        return cell;
    }
   
}
