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
        savedButton.addTarget(self, action: #selector(savedButtonPressed(sender:)), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonPressed(sender:)), for: .touchUpInside)
        
        [catImageView, likeButton, savedButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            catImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StyleGuide.Spaces.double),
            catImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            catImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            catImageView.heightAnchor.constraint(equalToConstant: 400),
            
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StyleGuide.Spaces.double),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleGuide.Spaces.double),
            likeButton.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: StyleGuide.Spaces.double),
            
            savedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StyleGuide.Spaces.double),
            savedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -StyleGuide.Spaces.double),
            savedButton.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: StyleGuide.Spaces.double)
        ])
    }
    
    func setImage(_ image : UIImage?, _ isSaved: Bool, isLiked: Bool, saveAction : @escaping () -> Void, likeAction : @escaping () -> Void) {
        catImageView.image = image
        savedButton.isSelected = isSaved
        likeButton.isSelected = isLiked
        likedAction = likeAction
//            .resizeImage(targetWidth: contentView.bounds.width)
        savedAction = saveAction
    }
    
    
}

// MARK: - Actions
@objc
extension FullScreenTableViewCell {
    func likeButtonPressed(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print("Like")
        if let action = likedAction {
            action()
        }
    }
    
    func savedButtonPressed(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let action = savedAction {
            action()
        }
    }
}
