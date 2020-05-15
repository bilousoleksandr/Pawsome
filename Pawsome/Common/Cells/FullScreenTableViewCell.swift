//
//  FullScreenTableViewCell.swift
//  Pawsome
//
//  Created by Marentilo on 07.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class FullScreenTableViewCell : UITableViewCell {
    private let catImageView = UIImageView()
    private let scrollView = UIScrollView()
    private let likeButton = Button.makeButton(#imageLiteral(resourceName: "loveCommon"), #imageLiteral(resourceName: "love"))
    private let savedButton = Button.makeButton(#imageLiteral(resourceName: "bookmark"), #imageLiteral(resourceName: "bookmark_selected"))
    private var savedAction : (() -> Void)?
    private var likedAction : (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        catImageView.image = nil
        likeButton.isSelected = false
        savedButton.isSelected = false
    }
    
    private func setupView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.5
        
        catImageView.isUserInteractionEnabled = true
        savedButton.addTarget(self, action: #selector(savedButtonPressed(sender:)), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonPressed(sender:)), for: .touchUpInside)
        
        [scrollView, likeButton, savedButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.addSubview(catImageView)
        catImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StyleGuide.Spaces.double),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: UIScreen.screenWidth()),
            scrollView.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth()),
            
            catImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            catImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            catImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            catImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            catImageView.heightAnchor.constraint(equalToConstant: UIScreen.screenWidth()),
            catImageView.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth()),
            
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StyleGuide.Spaces.double),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleGuide.Spaces.double),
            likeButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: StyleGuide.Spaces.double),
            
            savedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StyleGuide.Spaces.double),
            savedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -StyleGuide.Spaces.double),
            savedButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: StyleGuide.Spaces.double)
        ])
    }
    
    func setImage(_ image : UIImage?, _ isSaved: Bool, isLiked: Bool, saveAction : @escaping () -> Void, likeAction : @escaping () -> Void) {
        catImageView.image = image
        savedButton.isSelected = isSaved
        likeButton.isSelected = isLiked
        likedAction = likeAction
        savedAction = saveAction
    }
}

// MARK: - UIScrollViewDelegate
extension FullScreenTableViewCell : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return catImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.zoomScale = 1.0
    }
}

// MARK: - Actions
@objc
private extension FullScreenTableViewCell {
    func likeButtonPressed(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        likedButtonHandler()
    }
    
    func savedButtonPressed(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        savedButtonHandler()
    }
}

// MARK: - Actions Handler
private extension FullScreenTableViewCell {
    func likedButtonHandler() {
        likeButton.isSelected ? likeButton.layer.removeAnimation(forKey: "position") : likeButton.layer.removeAnimation(forKey: "transform.scale")
        likeButton.isSelected ? likeButton.makePulse() : likeButton.makeShake()
        if let action = likedAction {
            action()
        }
    }
    
    func savedButtonHandler() {
        if !savedButton.isSelected {
            savedButton.layer.removeAllAnimations()
            savedButton.makeShake()
        }
        if let action = savedAction {
            action()
        }
    }
}
