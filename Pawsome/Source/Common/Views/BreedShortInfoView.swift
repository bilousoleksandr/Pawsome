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
    private let originDetailLabel = Label.makeBreedDetailsTitleLabel()
    private let weightLabel = Label.makeSubtitleLabel(with: "\(Strings.weight):")
    private let weightDetailLabel = Label.makeBreedDetailsTitleLabel()
    private let lifespanLabel = Label.makeSubtitleLabel(with: "\(Strings.lifeSpan):")
    private let lifespanDetailLabel = Label.makeBreedDetailsTitleLabel()
    private let yearsLabel = Label.makeSubtitleLabel(with: Strings.years)
    private let kgLabel = Label.makeSubtitleLabel(with: Strings.kg)
    
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
            weightLabel,
            weightDetailLabel,
            lifespanLabel,
            lifespanDetailLabel,
            yearsLabel,
            kgLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
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
            
            originLabel.topAnchor.constraint(equalTo: breedNameLabel.bottomAnchor, constant: StyleGuide.Spaces.single * 1.5),
            originLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor, constant: 0),
            
            originDetailLabel.bottomAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 0),
            originDetailLabel.leadingAnchor.constraint(equalTo: originLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            
            weightLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: StyleGuide.Spaces.single * 1.5),
            weightLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor, constant: 0),
            
            weightDetailLabel.bottomAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 0),
            weightDetailLabel.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            
            kgLabel.leadingAnchor.constraint(equalTo: weightDetailLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            kgLabel.bottomAnchor.constraint(equalTo: weightDetailLabel.bottomAnchor, constant: 0),
            
            lifespanLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: StyleGuide.Spaces.single * 1.5),
            lifespanLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor, constant: 0),
            
            lifespanDetailLabel.bottomAnchor.constraint(equalTo: lifespanLabel.bottomAnchor, constant: 0),
            lifespanDetailLabel.leadingAnchor.constraint(equalTo: lifespanLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            
            yearsLabel.leadingAnchor.constraint(equalTo: lifespanDetailLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            yearsLabel.bottomAnchor.constraint(equalTo: lifespanDetailLabel.bottomAnchor, constant: 0),
            
            breedDescriptionLabel.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: StyleGuide.Spaces.single),
            breedDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: StyleGuide.Spaces.double),
            breedDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -StyleGuide.Spaces.double),
            breedDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -StyleGuide.Spaces.double)
        ]
        NSLayoutConstraint.activate(constrains)
    }
    
    func configure(image : UIImage?, breedName : String, description : String, origin : String, weight: String, lifespan: String) {
        catImageView.image = image
        breedNameLabel.text = breedName
        breedDescriptionLabel.text = description
        originDetailLabel.text = origin
        weightDetailLabel.text = weight
        lifespanDetailLabel.text = lifespan
    }
}
