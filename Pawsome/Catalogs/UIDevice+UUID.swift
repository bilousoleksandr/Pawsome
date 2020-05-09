//
//  UIDevice+UUID.swift
//  Pawsome
//
//  Created by Marentilo on 09.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

extension UIDevice {
    /// Create uniq ID for current device.
    /// Note : if user reinstall app, the value will change
    static func uniqID() -> String {
        guard let uuid = UIDevice.current.identifierForVendor?.uuid else {
            fatalError()
        }
        return "\(uuid)".replacingOccurrences(of: ", ", with: "")
    }
}
