//
//  SingleBreedCollectionViewCell.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SingleBreedCollectionViewCell : UICollectionViewCell {
    private let iconView = UIImageView()
    private let infoLabel = Label.makeTitleLabel()
    private var size : CGFloat { return contentView.bounds.height * 0.75}
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        infoLabel.text = nil
    }
    
    private func setupView() {
        infoLabel.font = UIFont.boldSystemFont(ofSize: 20)
        [iconView, infoLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstrains()
    }
    
    private func setupConstrains() {
        let constrains = [
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StyleGuide.Spaces.single),
            infoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0),
            
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0),
            iconView.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -StyleGuide.Spaces.single)
        ]
        
        NSLayoutConstraint.activate(constrains)
    }
    
    func configure(with name : String) {
        iconView.image = UIImage.catImage(for: name).resizeImage(targetWidth: size)
        infoLabel.text = name
    }
}

