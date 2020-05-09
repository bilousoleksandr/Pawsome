//
//  UITableView+CellRegistration.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

extension UITableView {
    func registerReusableCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.description())
    }

    func registerReusableCells<T: UITableViewCell>(_ cellTypes: T.Type...) {
        cellTypes.forEach(registerReusableCell)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: cellType.description()) as? T
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, at indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: cellType.description(), for: indexPath) as! T
    }
}
