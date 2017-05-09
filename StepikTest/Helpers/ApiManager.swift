//
//  ApiManager.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/1/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Nuke

class ApiManager {
    
    static let shared = ApiManager()
    
    let host = "https://stepik.org"
    
    func getCourses(page: Int, completion: @escaping (_ courses: [Course]?, _ hasNextPage: Bool?) -> Void) {
        
        var courses: [Course] = []
        
        let parameters: Parameters = [
            "is_public": true,
            "page": page,
            "order": "-activity"
        ]
        
        Alamofire.request(host + "/api/courses", parameters: parameters).responseJSON { response in
            if response.response?.statusCode == 200 {
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    let coursesJSON = json["courses"]
                    
                    let hasNextPage = json["meta"]["has_next"].boolValue
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    
                    for courseJSON in coursesJSON {
                        let courseJSON = courseJSON.1
                        //print(courseJSON)
                        let title = courseJSON["title"].stringValue
                        let summary = courseJSON["summary"].stringValue.decodedFromHtml()
                        let course = Course(title: title, summary: summary)
                        
                        if let beginDate = courseJSON["begin_date_source"].string {
                            course.beginDate = dateFormatter.date(from: beginDate)
                        }
                        if let endDate = courseJSON["last_deadline"].string {
                            course.endDate = dateFormatter.date(from: endDate)
                        }
                        if let coverUrl = courseJSON["cover"].string {
                            course.coverUrl = coverUrl
                        }
                        
                        let instructorsIDs = courseJSON["instructors"]
                        for id in instructorsIDs {
                            self.getInstructor(course: course, id: id.1.stringValue)
                        }
                        
                        courses.append(course)
                    }
                    completion(courses, hasNextPage)
                }
            } else {
                StatusBarManager.shared.showCustomStatusBarError(text: "Error! Please check your Internet connection.")
                completion(nil, nil)
            }
        }
    }
    
    func getCourseCover(coverUrl: String, cell: CourseCell) {
        if let url = URL(string: host + coverUrl) {
            cell.imageViewCover.image = UIImage(named: "stepik_grey")
            Nuke.loadImage(with: url, into: cell.imageViewCover)
        }
    }
    
    func getInstructor(course: Course, id: String) {
        
        Alamofire.request(host + "/api/users/" + id).responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                if let userJSON = json["users"].first?.1 {
                    let firstName = userJSON["first_name"].stringValue
                    let secondName = userJSON["second_name"].stringValue
                    let bio = userJSON["short_bio"].stringValue
                    
                    let instructor = User(firstName: firstName, secondName: secondName)
                    if !bio.isEmpty {
                        instructor.bio = bio
                    }
                    
                    course.instructors.append(instructor)
                }
            }
        }
    }
    
}
