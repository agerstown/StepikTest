//
//  CoursesViewController.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/1/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CoursesViewController: UIViewController {
    
    @IBOutlet weak var tableViewCourses: UITableView!
    @IBOutlet weak var activityIndicatorTableViewBottom: UIActivityIndicatorView!
    
    let activityIndicatorInitialLoading = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let refreshControl = UIRefreshControl()
    
    // Я гружу новые курсы, когда юзер доскроллил до 5й ячейки с конца (делаю запрос на сервер с указанием страницы X). 
    // Перед тем, как делать запрос, нужно проверить, получен ли ответ на предыдущий (loading = false),
    // чтобы не загрузить курсы с одной и той же страницы X несколько раз.
    // Так может получиться, если сначала отобразится пятая ячейка с конца, затем юзер прокрутит экран наверх так,
    // что эту ячейку уже не станет видно, а потом прокрутит опять вниз, в то время как новые данные еще не загрузились.
    // Вызовется метод ... cellForRowAt ... и получится, что эта ячейка опять пятая с конца и запрос на сервер 
    // уйдет еще раз, хотя этого не нужно делать.
    var loading = false
    
    var courses: [Course] = []
    
    var lastLoadedPageNumber = 1
    
    var hasNextPage = false
    
    var selectedCourse: Course?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewCourses.dataSource = self
        tableViewCourses.delegate = self
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        tableViewCourses.refreshControl = refreshControl
        
        startSpinning()
        reloadCoursesTable() {
            self.stopSpinning()
        }

    }
    
    // MARK: Courses update
    func reloadCoursesTable(completion: @escaping () -> Void) {
        ApiManager.shared.getCourses(page: lastLoadedPageNumber) { courses, hasNextPage in
            completion()
            if let courses = courses {
                self.courses = courses
                self.tableViewCourses.reloadData()
            }
            if let hasNextPage = hasNextPage {
                self.hasNextPage = hasNextPage
            }
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        lastLoadedPageNumber = 1
        reloadCoursesTable() {
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Spinner for initial courses loading
    func startSpinning() {
        tableViewCourses.isHidden = true
    
        activityIndicatorInitialLoading.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        self.view.addSubview(activityIndicatorInitialLoading)
        activityIndicatorInitialLoading.startAnimating()
    }
    
    func stopSpinning() {
        activityIndicatorInitialLoading.stopAnimating()
        activityIndicatorInitialLoading.removeFromSuperview()
        tableViewCourses.isHidden = false
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? CourseViewController {
            controller.course = selectedCourse
        }
    }
}

// MARK: - UITableViewDataSource
extension CoursesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCourses.dequeueReusableCell(withIdentifier: "CourseCell") as! CourseCell
        let course = courses[indexPath.row]
        
        cell.labelTitle.text = course.title
        cell.labelSummary.text = course.summary
        cell.labelDate.text = course.stringDate
        
        if let coverUrl = course.coverUrl {
            ApiManager.shared.getCourseCover(url: coverUrl, imageView: cell.imageViewCover)
        } else {
            cell.imageViewCover.image = UIImage(named: "stepik_grey")
        }
        
        loadMoreCoursesIfNecessary(row: indexPath.row)
        
        return cell
    }

    // Если сейчас станет видна 5-я ячейка с конца - пора грузить новые курсы.
    // Так юзеру придется меньше ждать, когда они подгрузятся.
    // (Чем если проверять, когда таблицу доскролят до конца и только потом начинать грузить.)
    func loadMoreCoursesIfNecessary(row: Int) {
        if hasNextPage {
            if loading == false {
                if row == courses.count - 5 {
                    activityIndicatorTableViewBottom.isHidden = false
                    activityIndicatorTableViewBottom.startAnimating()
                    
                    loading = true
                    
                    ApiManager.shared.getCourses(page: lastLoadedPageNumber + 1) { courses, hasNextPage in
                        
                        self.activityIndicatorTableViewBottom.stopAnimating()
                        self.activityIndicatorTableViewBottom.isHidden = true
                        
                        if let courses = courses {
                            self.lastLoadedPageNumber += 1
                            self.courses.append(contentsOf: courses)
                            self.tableViewCourses.reloadData()
                        }
                        
                        if let hasNextPage = hasNextPage {
                            self.hasNextPage = hasNextPage
                        }
                        
                        self.loading = false
                    }
                }
            }
        }
    }
    
}

// MARK: - UITableViewDelegate
extension CoursesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewCourses.deselectRow(at: indexPath, animated: true)
        selectedCourse = courses[indexPath.row]
        performSegue(withIdentifier: "segueToCourseInfo", sender: nil)
    }
    
}
