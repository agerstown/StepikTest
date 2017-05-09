//
//  CourseOverviewTableViewDataSource.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/9/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

class CourseOverviewTableViewDataSource: NSObject, UITableViewDataSource {
    
    var course: Course
    
    let summaryCell = Bundle.main.loadNibNamed("DefaultCourseInfoItemCell", owner: nil, options: nil)![0] as! DefaultCourseInfoItemCell
    let instructorsCell = Bundle.main.loadNibNamed("InstructorsCell", owner: nil, options: nil)![0] as! InstructorsCell
    
    init(course: Course) {
        self.course = course
        
        summaryCell.labelTitle.text = "Summary"
        summaryCell.labelText.text = course.summary
        
        instructorsCell.collectionViewInstructors.register(InstructorCell.self, forCellWithReuseIdentifier: "InstructorCell")
        
        super.init()
        
        instructorsCell.collectionViewInstructors.dataSource = self
//        instructorsCell.collectionViewInstructors.delegate = self
        
        setInstructorsCollectionViewInsets()
    }
    
    func setInstructorsCollectionViewInsets() {
        if let flowLayout = instructorsCell.collectionViewInstructors.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let numberOfCells = CGFloat(course.instructors.count)
            let collectionViewWidth = instructorsCell.collectionViewInstructors.bounds.size.width
            let cellWidth = flowLayout.itemSize.width
            let spacing = flowLayout.minimumLineSpacing
            
            var edgeInsets: CGFloat = 0
            if numberOfCells < 4 {
                edgeInsets = (collectionViewWidth - numberOfCells * cellWidth - (numberOfCells - 1) * spacing) / (numberOfCells > 1 ? numberOfCells : 2)
            }
            
            flowLayout.sectionInset = UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch(indexPath.row) {
        case 0:
            return summaryCell
        case 1:
            return instructorsCell
        default:
            return UITableViewCell()
        }
    }
    
}

extension CourseOverviewTableViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return course.instructors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstructorCell", for: indexPath)
        cell.backgroundColor = UIColor.black
        return cell;
    }
   
}
