//
//  CategoryCollectionViewCell.swift
//  Pawsome
//
//  Created by Marentilo on 18.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    private let textLabel = Label.makeSubtitleLabel().alignment(.center)
    private let textView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
    }
    
    private func setupView() {
        textView.makeBorders(radius: StyleGuide.CornersRadius.mediumView, width: 2, color: UIColor.blus)
        contentView.addSubview(textView)
        contentView.backgroundColor = UIColor.lightBlue
        textView.addSubview(textLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        [textView, textLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StyleGuide.Spaces.single / 2),
            textView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            textView.widthAnchor.constraint(equalToConstant: contentView.bounds.width - StyleGuide.Spaces.single),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StyleGuide.Spaces.single / 2),
            
            textLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: StyleGuide.Spaces.single / 2),
            textLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -StyleGuide.Spaces.single / 2),
            textLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            textLabel.heightAnchor.constraint(equalTo: textView.heightAnchor)
        ])
    }
    
    func configure (with category : String) {
        textLabel.text = category
    }
}
