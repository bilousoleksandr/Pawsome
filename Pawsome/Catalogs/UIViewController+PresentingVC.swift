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
        viewController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(screenDidTap(sender:))))
        present(viewController, animated: animated, completion: competition)
    }
    
    /// Present given image over full screen
    func showLagreImage(_ image : UIImage?) {
        let vc = UIViewController()
        vc.view.makeBlur()
        let imageView = UIImageView(image: image)
        
        vc.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth() - StyleGuide.Spaces.double).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.screenWidth() - StyleGuide.Spaces.double).isActive = true
        imageView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        imageView.roundCorners(radius: StyleGuide.CornersRadius.largeView)
        imageView.makeRounded(radius: StyleGuide.CornersRadius.largeView)
        imageView.makeShadow()
        showFullScreen(vc)
    }
}

// MARK: - Actions
extension UIViewController {
    @objc func screenDidTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - BackButtons
extension UIViewController {
    func setStandartBackButton() {
        navigationItem.backBarButtonItem = BarButtonItem.makeBackButton()
        navigationItem.backBarButtonItem?.tintColor = UIColor.blus
    }
}
