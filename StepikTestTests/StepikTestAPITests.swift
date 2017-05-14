//
//  StepikTestAPITests.swift
//  StepikTestTests
//
//  Created by Natalia Nikitina on 5/1/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import XCTest
@testable import StepikTest
import Nimble

class StepikTestAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func getRandomInt(from: Int = 0, to: Int) -> Int {
        return Int(arc4random_uniform(UInt32(to))) + from
    }
    
    func testGetCoursesFirstPage() {
        var courses: [Course]?
        var hasNextPage: Bool?
        let page = getRandomInt(from: 1, to: 30)
        ApiManager.shared.getCourses(page: page) { coursesResult, hasNextPageResult in
            courses = coursesResult
            hasNextPage = hasNextPageResult
        }
        expect(courses).toEventuallyNot(beNil(), timeout: 10)
        expect(courses?.count).toEventually(beGreaterThan(0), timeout: 10)
        expect(hasNextPage).toEventually(beTrue())

    }
    
    func testGetCoursesTooLargePage() {
        var courses: [Course]?
        var hasNextPage: Bool?
        ApiManager.shared.getCourses(page: 1000) { coursesResult, hasNextPageResult in
            courses = coursesResult
            hasNextPage = hasNextPageResult
        }
        expect(courses).toEventually(beNil(), timeout: 10)
        expect(hasNextPage).toEventually(beNil())
    }
    
    func testGetCourseCover() {
        var course: Course?
        let imageView = UIImageView()
        var coverUrl: String?
        
        ApiManager.shared.getCourses(page: 1) { courses, _ in
            let index = self.getRandomInt(to: courses!.count)
            course = courses?[index]
            if let url = course?.coverUrl {
                coverUrl = url
                ApiManager.shared.getCourseCover(url: url, imageView: imageView)
            }
        }
        
        if coverUrl != nil {
            expect(imageView.image).toEventuallyNot(beNil(), timeout: 10)
        }
    }
    
    func testGetVideoThambnail() {
        var course: Course?
        let imageView = UIImageView()
        var thumbnailUrl: String?
        
        ApiManager.shared.getCourses(page: 1) { courses, _ in
            let index = self.getRandomInt(to: courses!.count)
            course = courses?[index]
            if let url = course?.coverUrl {
                thumbnailUrl = url
                ApiManager.shared.getCourseVideoThumbnail(url: url, imageView: imageView)
            }
        }
        
        if thumbnailUrl != nil {
            expect(imageView.image).toEventuallyNot(beNil(), timeout: 10)
        }
    }
    
    func testGetInstructors() {
        var course: Course?
        var instructorsIDs: [Int]?
        var instructors: [User]?
        
        ApiManager.shared.getCourses(page: 1) { courses, _ in
            let index = self.getRandomInt(to: courses!.count)
            course = courses?[index]
            if let IDs = course?.instructorsIDs {
                instructorsIDs = IDs
                ApiManager.shared.getInstructors(IDs: IDs) { instructorsResult in
                    instructors = instructorsResult
                }
            }
        }
        
        expect(instructorsIDs).toEventuallyNot(beNil(), timeout: 10)
        if let IDs = instructorsIDs {
            if IDs.count > 0 {
                expect(instructors).toEventuallyNot(beNil(), timeout: 10)
                expect(instructors?.count).toEventually(equal(instructorsIDs?.count), timeout: 10)
            }
        }
    }
    
    func testGetSections() {
        var course: Course?
        var sectionsIDs: [Int]?
        var sections: [Section]?
        
        ApiManager.shared.getCourses(page: 1) { courses, _ in
            let index = self.getRandomInt(to: courses!.count)
            course = courses?[index]
            if let IDs = course?.sectionsIDs {
                sectionsIDs = IDs
                ApiManager.shared.getSections(IDs: IDs) { sectionsResult in
                    sections = sectionsResult
                }
            }
        }
        
        expect(sectionsIDs).toEventuallyNot(beNil(), timeout: 10)
        if let IDs = sectionsIDs {
            if IDs.count > 0 {
                expect(sections).toEventuallyNot(beNil(), timeout: 10)
                expect(sections?.count).toEventually(equal(sectionsIDs?.count), timeout: 10)
            }
        }
    }
    
}
