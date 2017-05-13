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
                        
                        let title = courseJSON["title"].stringValue
                        let summary = courseJSON["summary"].stringValue.decodedFromHtml()
                        let course = Course(title: title, summary: summary)
                        
                        if let beginDate = courseJSON["begin_date_source"].string {
                            course.beginDate = dateFormatter.date(from: beginDate)
                        }
                        if let endDate = courseJSON["last_deadline"].string {
                            course.endDate = dateFormatter.date(from: endDate)
                        }
                        
                        course.coverUrl = courseJSON["cover"].stringValue
                        
                        let instructorsIDs = courseJSON["instructors"]
                        course.instructorsIDs = instructorsIDs.map { $0.1.intValue }
                        
                        let sectionsIDs = courseJSON["sections"]
                        course.sectionsIDs = sectionsIDs.map { $0.1.intValue }
                        
                        let description = courseJSON["description"].stringValue.decodedFromHtml()
                        course.description = self.valueOrNil(description)
                        
                        let workload = courseJSON["workload"].stringValue.decodedFromHtml()
                        course.workload = self.valueOrNil(workload)
                        
                        let certificate = courseJSON["certificate"].stringValue.decodedFromHtml()
                        course.certificate = self.valueOrNil(certificate)
                        
                        let audience = courseJSON["target_audience"].stringValue.decodedFromHtml()
                        course.audience = self.valueOrNil(audience)
                        
                        let format = courseJSON["course_format"].stringValue.decodedFromHtml()
                        course.format = self.valueOrNil(format)
                        
                        let requirements = courseJSON["requirements"].stringValue.decodedFromHtml()
                        course.requirements = self.valueOrNil(requirements)
                        
                        if courseJSON["intro_video"].null == nil {
                            let introVideoThumbnailLink = courseJSON["intro_video"]["thumbnail"].stringValue
                            course.introVideoThumbnailLink = introVideoThumbnailLink
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
    
    func valueOrNil(_ string: String) -> String? {
        if string.isEmpty {
            return nil
        } else {
            return string
        }
    }
    
    func getImage(url: String, putInto imageView: UIImageView) {
        if let url = URL(string: url) {
            imageView.image = UIImage(named: "stepik_grey")
            Nuke.loadImage(with: url, into: imageView)
        }
    }
    
    func getCourseCover(coverUrl: String, cell: CourseCell) {
        getImage(url: host + coverUrl, putInto: cell.imageViewCover)
    }
    
    func getCourseVideoThumbnail(url: String, imageView: UIImageView) {
        if let url = URL(string: url) {
            imageView.image = UIImage(named: "stepik_grey")
            Nuke.loadImage(with: url, into: imageView)
        }
    }
    
    func getInstructors(IDs: [Int], completion: @escaping (_ instructors: [User]) -> Void) {
        var instructors: [User] = []
        let downloadGroup = DispatchGroup()
        for id in IDs {
            downloadGroup.enter()
            getInstructor(id: id) { instructor in
                instructors.append(instructor)
                downloadGroup.leave()
            }
        }
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            completion(instructors)
        }
    }
    
    func getInstructor(id: Int, completion: @escaping (_ instructor: User) -> Void) {
        
        Alamofire.request(host + "/api/users/\(id)").responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                if let userJSON = json["users"].first?.1 {
                    let firstName = userJSON["first_name"].stringValue
                    let secondName = userJSON["last_name"].stringValue
                    let avatarLink = userJSON["avatar"].stringValue
                    let bio = userJSON["short_bio"].stringValue
                    
                    let instructor = User(firstName: firstName, secondName: secondName, avatarLink: avatarLink)
                    if !bio.isEmpty {
                        instructor.bio = bio
                    }
                    
                    completion(instructor)
                }
            }
        }
    }
    
    func getSections(IDs: [Int], completion: @escaping (_ sections: [Section]) -> Void) {
        var sections: [Section] = []
        let downloadGroup = DispatchGroup()
        for id in IDs {
            downloadGroup.enter()
            getSection(id: id) { section in
                sections.append(section)
                downloadGroup.leave()
            }
        }
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            completion(sections)
        }
    }
    
    func getSection(id: Int, completion: @escaping (_ section: Section) -> Void) {
        
        Alamofire.request(host + "/api/sections/\(id)").responseJSON { response in
            if let value = response.result.value {
                print(value)
                let json = JSON(value)
                if let sectionJSON = json["sections"].first?.1 {
                    let position = sectionJSON["position"].intValue
                    let title = sectionJSON["title"].stringValue
                    let section = Section(index: position, title: title)
                    completion(section)
                }
            }
        }
    }
    
}
