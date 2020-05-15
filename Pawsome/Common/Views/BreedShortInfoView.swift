//
//  BreedShortInfoView.swift
//  Pawsome
//
//  Created by Marentilo on 08.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class BreedShortInfoView : UIView {
    private let catImageView = UIImageView()
    private let breedDescriptionLabel = Label.makeBreedDescriptionLabel()
    private let breedNameLabel = Label.makeTitleLabel()
    private let originLabel = Label.makeSubtitleLabel(with: Strings.origin)
    private let originDetailLabel = Label.makeTitleLabel()
    private let intelligenceLabel = Label.makeSubtitleLabel(with: Strings.intelligence)
    private let intelligenceDetailLabel = Label.makeTitleLabel()
    private let socialNeedsLabel = Label.makeSubtitleLabel(with: Strings.socialNeeds)
    private let socialNeedsDetailLabel = Label.makeTitleLabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        roundCorners(radius: StyleGuide.CornersRadius.largeView)
        makeShadow()
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        translatesAutoresizingMaskIntoConstraints = false
        breedDescriptionLabel.font = breedDescriptionLabel.font.withSize(18)
        
        [
            catImageView,
            breedDescriptionLabel,
            breedNameLabel,
            originLabel,
            originDetailLabel,
            socialNeedsLabel,
            socialNeedsDetailLabel,
            intelligenceLabel,
            intelligenceDetailLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        [originDetailLabel, socialNeedsDetailLabel, intelligenceDetailLabel].forEach { $0.font = UIFont.boldSystemFont(ofSize: 20) }
        setupConstrains()
    }
    
    private func setupConstrains() {
        let viewWidth = UIScreen.screenWidth() - StyleGuide.Spaces.single * 2
        let imageHeight = viewWidth / 2
        
        let constrains = [
            catImageView.topAnchor.constraint(equalTo: topAnchor, constant: StyleGuide.Spaces.single),
            catImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -StyleGuide.Spaces.single),
            catImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            catImageView.widthAnchor.constraint(equalToConstant: imageHeight),
            
            breedNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: StyleGuide.Spaces.double),
            breedNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: StyleGuide.Spaces.double),
            breedNameLabel.trailingAnchor.constraint(equalTo: catImageView.leadingAnchor, constant: -StyleGuide.Spaces.single),
            
            originLabel.topAnchor.constraint(equalTo: breedNameLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            originLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor, constant: 0),
            
            originDetailLabel.bottomAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 0),
            originDetailLabel.leadingAnchor.constraint(equalTo: originLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            
            intelligenceLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            intelligenceLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor, constant: 0),
            
            intelligenceDetailLabel.bottomAnchor.constraint(equalTo: intelligenceLabel.bottomAnchor, constant: 0),
            intelligenceDetailLabel.leadingAnchor.constraint(equalTo: intelligenceLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            
            socialNeedsLabel.topAnchor.constraint(equalTo: intelligenceLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            socialNeedsLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor, constant: 0),
            
            socialNeedsDetailLabel.bottomAnchor.constraint(equalTo: socialNeedsLabel.bottomAnchor, constant: 0),
            socialNeedsDetailLabel.leadingAnchor.constraint(equalTo: socialNeedsLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            
            breedDescriptionLabel.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: StyleGuide.Spaces.single),
            breedDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: StyleGuide.Spaces.double),
            breedDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -StyleGuide.Spaces.double),
            breedDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -StyleGuide.Spaces.double)
        ]
        NSLayoutConstraint.activate(constrains)
    }
    
    func configure(image : UIImage?, breedName : String, description : String, origin : String, intelligence: String, socialNeeds: String) {
        catImageView.image = image
        breedNameLabel.text = breedName
        breedDescriptionLabel.text = description
        originDetailLabel.text = origin
        intelligenceDetailLabel.text = intelligence
        socialNeedsDetailLabel.text = socialNeeds
    }
}
