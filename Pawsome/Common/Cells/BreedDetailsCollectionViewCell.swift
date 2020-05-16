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
    private let textLabel = Label.makeBreedDetailsLabel()
    
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
        let space = StyleGuide.Spaces.single / 2
        let constrains = [
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StyleGuide.Spaces.single),
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            iconView.heightAnchor.constraint(equalToConstant: 64),
            iconView.widthAnchor.constraint(equalToConstant: 64),
            
            textLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: space),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: space),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: space),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -space)
        ]
        NSLayoutConstraint.activate(constrains)
    }
    
    func configureCell(with name : String) {
        iconView.image = UIImage(named: name)
        textLabel.text = name.capitalizedFirst
    }
}
