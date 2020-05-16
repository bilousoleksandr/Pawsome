//
//  BreedHeaderView.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class BreedHeaderView : UIView {
    private let catImageView = UIImageView()
    private let originLabel = Label.makeSubtitleLabel()
    private let rareLabel = Label.makeSubtitleLabel(with: Strings.rare)
    private let experimentalLabel = Label.makeSubtitleLabel(with: Strings.experimental)
    private let naturalLabel = Label.makeSubtitleLabel(with: Strings.natural)
    private let rareImageView = UIImageView()
    private let experimentalImageView = UIImageView()
    private let naturalImageView = UIImageView()
    
    private let originDetailsLabel : UILabel = {
        let label = Label.makeSubtitleLabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        return label
    } ()
    
    private let breedTitleLabel = Label.makeTitleLabel()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        [
            catImageView,
            breedTitleLabel,
            rareLabel,
            naturalLabel,
            experimentalLabel,
            rareImageView,
            naturalImageView,
            experimentalImageView,
            originLabel,
            originDetailsLabel
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstrains()
    }
    
    private func setupConstrains() {
        let constrains = [
            catImageView.topAnchor.constraint(equalTo: topAnchor, constant: StyleGuide.Spaces.double),
            catImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            catImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            catImageView.heightAnchor.constraint(equalToConstant: UIScreen.screenWidth() / 2),
            catImageView.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth() / 2),
            
            breedTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: StyleGuide.Spaces.double),
            breedTitleLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -StyleGuide.Spaces.single),
            breedTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            
            originLabel.topAnchor.constraint(equalTo: breedTitleLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            originLabel.leadingAnchor.constraint(equalTo: breedTitleLabel.leadingAnchor, constant: 0),
            
            originDetailsLabel.leadingAnchor.constraint(equalTo: originLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            originDetailsLabel.centerYAnchor.constraint(equalTo: originLabel.centerYAnchor, constant: 0),
            
            rareLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            rareLabel.leadingAnchor.constraint(equalTo: originLabel.leadingAnchor, constant: 0),
            
            rareImageView.leadingAnchor.constraint(equalTo: rareLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            rareImageView.centerYAnchor.constraint(equalTo: rareLabel.centerYAnchor, constant: 0),
            
            naturalLabel.topAnchor.constraint(equalTo: rareLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            naturalLabel.leadingAnchor.constraint(equalTo: rareLabel.leadingAnchor, constant: 0),
            
            naturalImageView.leadingAnchor.constraint(equalTo: naturalLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            naturalImageView.centerYAnchor.constraint(equalTo: naturalLabel.centerYAnchor, constant: 0),
            
            experimentalLabel.topAnchor.constraint(equalTo: naturalLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            experimentalLabel.leadingAnchor.constraint(equalTo: naturalLabel.leadingAnchor, constant: 0),
            
            experimentalImageView.leadingAnchor.constraint(equalTo: experimentalLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            experimentalImageView.centerYAnchor.constraint(equalTo: experimentalLabel.centerYAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constrains)
    }
    
    /// configure view according to given breed ViewModel
    func configure(name : String, origin: String, friendlyText : String, rare : Int, experimental : Int, natural : Int) {
        catImageView.image = UIImage(named: name)
        breedTitleLabel.text = name
        originLabel.text = Strings.origin
        originDetailsLabel.text = origin
        rareImageView.image = rare == 0 ? #imageLiteral(resourceName: "signs") : #imageLiteral(resourceName: "star")
        experimentalImageView.image = experimental == 0 ? #imageLiteral(resourceName: "animal-kingdom") : #imageLiteral(resourceName: "cat (5)")
        naturalImageView.image = natural == 0 ? #imageLiteral(resourceName: "naturalCommon") : #imageLiteral(resourceName: "natural")
    }
}
