//
//  UICollectionView+Cell.swift
//  Pawsome
//
//  Created by Marentilo on 08.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerReusableCell<T : UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.description())
    }
    
    func dequeueReusableCell<T : UICollectionViewCell> (_ cellType: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: cellType.description(), for: indexPath) as? T
    }
}
