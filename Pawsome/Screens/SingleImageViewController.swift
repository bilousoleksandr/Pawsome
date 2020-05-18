//
//  SingleImageViewController.swift
//  Pawsome
//
//  Created by Marentilo on 16.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SingleImageViewController : UIViewController {
    private let largeImageView = UIImageView()
    private let likeButton = Button.makeButton(#imageLiteral(resourceName: "loveCommon"), #imageLiteral(resourceName: "love"))
    private let savedButton = Button.makeButton(#imageLiteral(resourceName: "bookmark"), #imageLiteral(resourceName: "bookmark_selected"))
    private let singleImageViewModel : SingleImageViewModel
    
    
    init(sinleImageViewModel : SingleImageViewModel) {
        self.singleImageViewModel = sinleImageViewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = Strings.singleImage
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        [likeButton, savedButton, largeImageView].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        setupConstrains()
        setupImageGestures()
        likeButton.addTarget(self, action: #selector(likeButtonDidPress(sender:)), for: .touchUpInside)
        savedButton.addTarget(self, action: #selector(savedButtonDidPress(sender:)), for: .touchUpInside)
        likeButton.isSelected = singleImageViewModel.isLiked
        savedButton.isSelected = singleImageViewModel.isSaved
        
        singleImageViewModel.fechImage { [weak self] (image) in
            self?.largeImageView.image = image
        }
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            largeImageView.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth()),
            largeImageView.heightAnchor.constraint(equalToConstant: UIScreen.screenWidth()),
            largeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            largeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            likeButton.topAnchor.constraint(equalTo: largeImageView.bottomAnchor, constant: StyleGuide.Spaces.double),
            likeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: StyleGuide.Spaces.double),
            
            savedButton.topAnchor.constraint(equalTo: largeImageView.bottomAnchor, constant: StyleGuide.Spaces.double),
            savedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -StyleGuide.Spaces.double)
        ])
    }
    
    private func setupImageGestures() {
        largeImageView.isUserInteractionEnabled = true
        let pinGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureAction(sender:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGectureAction(sender:)))
        [pinGesture, panGesture].forEach {
            largeImageView.addGestureRecognizer($0)
            $0.delegate = self
        }
    }
    
    private func pinchDidEnd() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.largeImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    private func panGestureDidEnd() {
        let center = view.center
        UIView.animate(withDuration: 0.3, animations: {
            self.largeImageView.center = center
        }, completion: nil)
    }
    
    private func panGestureChangedHadler(center : CGPoint) {
        UIView.animate(withDuration: 0.3, animations: {
            self.largeImageView.center = center
        }, completion: nil)
    }
    
    private func pinchChangedHadler(scale : CGFloat) {
        let finalScale = largeImageView.frame.width * scale < UIScreen.screenWidth() ? 1.0 : scale
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.largeImageView.transform = CGAffineTransform(scaleX: finalScale, y: finalScale)
        }, completion: nil)
    }
    
    private func likedButtonHandler() {
        singleImageViewModel.likeImage(isSelected: likeButton.isSelected)
        likeButton.isSelected ? likeButton.layer.removeAnimation(forKey: "position") : likeButton.layer.removeAnimation(forKey: "transform.scale")
        likeButton.isSelected ? likeButton.makePulse() : likeButton.makeShake()
    }
    
    private func savedButtonHandler() {
        singleImageViewModel.saveImage()
        if !savedButton.isSelected {
            savedButton.layer.removeAllAnimations()
            savedButton.makeShake()
        }
    }
}

// MARK: - Actions
@objc private extension SingleImageViewController {
    func pinchGestureAction (sender : UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            pinchChangedHadler(scale: sender.scale)
        } else if sender.state == .ended || sender.state == .cancelled {
            pinchDidEnd()
        }
    }
    
    func panGectureAction(sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            panGestureChangedHadler(center: sender.location(in: view))
        } else if sender.state == .ended || sender.state == .cancelled {
            panGestureDidEnd()
        }
    }
    
    func likeButtonDidPress(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        likedButtonHandler()
    }
    
    func savedButtonDidPress(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        savedButtonHandler()
    }
}

// MARK: UIGestureRecognizerDelegate
extension SingleImageViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
