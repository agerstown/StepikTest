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
    
    let summaryCellNib = UINib(nibName: "DefaultCourseInfoItemCell", bundle: nil)
    let instructorsCellNib = UINib(nibName: "InstructorsCell", bundle: nil)
    
    init(tableView: UITableView, course: Course) {
        
        self.tableView = tableView
        self.course = course
        
        tableView.register(summaryCellNib, forCellReuseIdentifier: "DefaultCourseInfoItemCell")
        tableView.register(instructorsCellNib, forCellReuseIdentifier: "InstructorsCell")
        
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
            //instructorsCell.collectionViewInstructors.reloadData()
            
            let nib = UINib(nibName: "InstructorCell", bundle: nil)
            instructorsCell.collectionViewInstructors.register(nib, forCellWithReuseIdentifier: "InstructorCell")
            
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
        return course.instructors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstructorCell", for: indexPath) as! InstructorCell
        
        let instructor = course.instructors[indexPath.row]
        cell.labelName.text = instructor.firstName + " " + instructor.secondName
        if let bio = instructor.bio {
            cell.labelBio.text = bio
        }
        
        ApiManager.shared.getImage(url: instructor.avatarLink, putInto: cell.imageViewPhoto)
        
        //cell.imageViewPhoto.image = course.instructors[indexPath.row].bio
        return cell;
    }
   
}
