//
//  BreedDetailsCollectionViewCell.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class BreedDetailsCollectionViewCell : UICollectionViewCell {
    private let iconView = UIImageView()
    private let textLabel = Label.makeSubtitleLabel()
    
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
        textLabel.text = nil
    }
    
    private func setupView() {
        [iconView, textLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.backgroundColor = UIColor.lightBlue
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        textLabel.textAlignment = .center
        setupConstrains()
    }
    
    private func setupConstrains() {
        let constrains = [
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StyleGuide.Spaces.single),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleGuide.Spaces.single / 2),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -StyleGuide.Spaces.single / 2)
        ]
        NSLayoutConstraint.activate(constrains)
    }
    
    func configureCell(with name : String) {
        iconView.image = #imageLiteral(resourceName: "cat (1)")
        textLabel.text = name
    }
}
