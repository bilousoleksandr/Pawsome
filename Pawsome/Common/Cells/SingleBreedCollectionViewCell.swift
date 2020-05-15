//
//  SingleBreedCollectionViewCell.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SingleBreedCollectionViewCell : UICollectionViewCell {
    private let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "mark"))
    private let iconView = UIImageView()
    private let infoLabel = Label.makeBreedTitleLabel()
    private let originLabel = Label.makeSubtitleLabel()
    private let originIconView = UIImageView(image: #imageLiteral(resourceName: "origin"))
    private var size : CGFloat { return contentView.bounds.width - StyleGuide.Spaces.double * 2}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        infoLabel.text = nil
        originLabel.text = nil
    }
    
    private func setupView() {
        iconView.contentMode = .scaleToFill
        [backgroundImageView, iconView, infoLabel, originIconView, originLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstrains()
    }
    
    private func setupConstrains() {
        let constrains = [
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconView.heightAnchor.constraint(equalToConstant: size),
            iconView.widthAnchor.constraint(equalToConstant: size),
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StyleGuide.Spaces.single),
            
            infoLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: StyleGuide.Spaces.single / 2),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleGuide.Spaces.single),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -StyleGuide.Spaces.single / 2),
            
            originIconView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            originIconView.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor, constant: 0),
            originIconView.widthAnchor.constraint(equalToConstant: 24),
            
            originLabel.centerYAnchor.constraint(equalTo: originIconView.centerYAnchor, constant: 0),
            originLabel.leadingAnchor.constraint(equalTo: originIconView.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            originLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -StyleGuide.Spaces.single),
        ]
        NSLayoutConstraint.activate(constrains)
    }
    
    func configure(with name : String, and origin: String? = nil) {
        iconView.image = UIImage.catImage(for: name)
        infoLabel.text = name
        originLabel.text = origin
    }
}

