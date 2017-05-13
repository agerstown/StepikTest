//
//  StatusBarManager.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/4/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import Foundation
import CWStatusBarNotification

class StatusBarManager {
    
    static let shared = StatusBarManager()
    
    func showCustomStatusBarError(text: String) {
        let notification = CWStatusBarNotification()
        notification.notificationAnimationType = .overlay
        notification.notificationAnimationInStyle = .top
        notification.notificationLabelBackgroundColor = UIColor.red
        notification.display(withMessage: text, forDuration: TimeInterval(3))
    }
}
