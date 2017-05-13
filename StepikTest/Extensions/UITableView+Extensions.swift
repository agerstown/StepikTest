//
//  UITableView+Extensions.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/13/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeue<T: UITableViewCell>(_ type: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: type)) as! T
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) as! T
    }
    
    func registerNib<T: UITableViewCell>(_ type: T.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil), forCellReuseIdentifier: String(describing: type))
    }
    
    func registerClass<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: String(describing: type))
    }
    
    func registerHeaderFooterNib<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: type))
    }
    
    func registerHeaderFooterClass<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: String(describing: type))
    }
}
