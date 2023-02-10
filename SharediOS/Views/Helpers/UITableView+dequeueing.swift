//
//  UITableView+dequeueing.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 10/02/23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
