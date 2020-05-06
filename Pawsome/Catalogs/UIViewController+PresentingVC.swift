//
//  UIViewController+PresentingVC.swift
//  Pawsome
//
//  Created by Marentilo on 05.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Present sended viewController over full screen
    func showFullScreen (_ viewController : UIViewController,
                         animated: Bool = true,
                         competition : (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: animated, completion: competition)
    }
}
