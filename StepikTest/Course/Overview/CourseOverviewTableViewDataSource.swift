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
    
    let instructorCellIdentifier = String(describing: InstructorCell.self)
    
    init(tableView: UITableView, course: Course) {
        
        self.tableView = tableView
        self.course = course
        
        tableView.registerNib(DefaultCourseInfoItemCell.self)
        tableView.registerNib(InstructorsCell.self)
        
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course.instructors.count > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch(indexPath.row) {
        case 0:
            let summaryCell = tableView.dequeue(DefaultCourseInfoItemCell.self)
            summaryCell.labelTitle.text = "Summary"
            summaryCell.labelText.text = course.summary
            return summaryCell
        case 1:
            let instructorsCell = tableView.dequeue(InstructorsCell.self)
            instructorsCell.collectionViewInstructors.dataSource = self
            
            let nib = UINib(nibName: instructorCellIdentifier, bundle: nil)
            instructorsCell.collectionViewInstructors.register(nib, forCellWithReuseIdentifier: instructorCellIdentifier)
            
            setInstructorsCollectionViewInsets(cell: instructorsCell)
            return instructorsCell
        default:
            return UITableViewCell()
        }
    }
    
    func setInstructorsCollectionViewInsets(cell: InstructorsCell) {
        if let flowLayout = cell.collectionViewInstructors.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let numberOfCells = CGFloat(course.instructorsIDs.count)
            let collectionViewWidth = tableView.bounds.size.width - 32
            let cellWidth = flowLayout.itemSize.width
            let spacing = flowLayout.minimumLineSpacing
            
            var edgeInsets: CGFloat = 0
            let cellsPlusSpacingWidth = numberOfCells * cellWidth + (numberOfCells - 1) * spacing
            if cell.collectionViewInstructors.bounds.size.width > cellsPlusSpacingWidth {
                edgeInsets = (collectionViewWidth - cellsPlusSpacingWidth) / (numberOfCells > 1 ? numberOfCells : 2)
            }
            
            flowLayout.sectionInset = UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets)
        }
    }
    
}

extension CourseOverviewTableViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return course.instructors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: instructorCellIdentifier, for: indexPath) as! InstructorCell
        
        let instructor = course.instructors[indexPath.row]
        cell.labelName.text = instructor.firstName + " " + instructor.secondName
        if let bio = instructor.bio {
            cell.labelBio.text = bio
        }
        
        ApiManager.shared.getImage(url: instructor.avatarLink, putInto: cell.imageViewPhoto)
        
        return cell;
    }
   
}
