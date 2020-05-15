//
//  UIView+Animation.swift
//  Pawsome
//
//  Created by Marentilo on 14.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

extension UIView {
    /// Make pulsing button for 0.3 seconds
    func makePulse () {
       let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 1.0
        pulse.toValue = 1.2
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.2
        layer.add(pulse, forKey: nil)
    }
    
    /// Make button shaping from left to right for 0.2 seconds
    func makeShake() {
        let shake = CABasicAnimation(keyPath: "position")
        let startPoint = CGPoint(x: center.x - 3, y: center.y)
        let startValue = NSValue(cgPoint: startPoint)
        let endPoint = CGPoint(x: center.x + 3, y: center.y)
        let endValue = NSValue(cgPoint: endPoint)
        
        shake.fromValue = startValue
        shake.toValue = endValue
        shake.repeatCount = 3
        shake.duration = 0.2
        shake.autoreverses = true
        layer.add(shake, forKey: nil)
    }
}
