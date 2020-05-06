//
//  HeaderDetailsView.swift
//  Pawsome
//
//  Created by Marentilo on 04.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class HeaderDetailsView : UIView {
    private let iconView = UIImageView()
    private let infoLabel = Label.makeSubtitleLabel()
    private let valueLabel = Label.makeTitleLabel()
    private let valueDetailsLabel = Label.makeSubtitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        valueLabel.font = valueLabel.font.withSize(24)
        [iconView, infoLabel, valueLabel, valueDetailsLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        backgroundColor = UIColor.lightBlue
        layer.cornerRadius = 10
        layer.masksToBounds = true
        setupConstrains()
    }
    
    private func setupConstrains() {
        let constrains = [
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: StyleGuide.Spaces.single),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -StyleGuide.Spaces.single),
                   
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -StyleGuide.Spaces.single),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: StyleGuide.Spaces.single),
                   
            valueDetailsLabel.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 0),
            valueDetailsLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 4),
                   
            infoLabel.bottomAnchor.constraint(equalTo: valueLabel.topAnchor, constant: -StyleGuide.Spaces.single / 4),
            infoLabel.leadingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constrains)
    }
    
    func configure () {
        iconView.image = #imageLiteral(resourceName: "business")
       if Int.random(in: 0...10) < 4 {
           infoLabel.text = "Weight"
           valueLabel.text = "5-10"
           valueDetailsLabel.text = "kg"
       } else if Int.random(in: 0...10) < 4 {
           infoLabel.text = "Life span"
           valueLabel.text = "12-10"
           valueDetailsLabel.text = "yr"
       } else {
           infoLabel.text = "Energy level"
           valueLabel.text = "3"
           valueDetailsLabel.text = "lvl"
       }
    }
    
    
}
