//
//  BreedFeatureView.swift
//  Pawsome
//
//  Created by Marentilo on 05.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class BreedFeatureView : UIView {
    private var images : [UIImageView] = []
    private var textLabel = Label.makeSubtitleLabel()
    private var imagesStackView : UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .horizontal
        return stack
    } ()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        backgroundColor = UIColor.lightLightGrey.withAlphaComponent(0.3)
        roundCorners(radius: StyleGuide.CornersRadius.mediumView)
        [textLabel, imagesStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: StyleGuide.Spaces.single),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: StyleGuide.Spaces.single),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -StyleGuide.Spaces.single),
            
            imagesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -StyleGuide.Spaces.single),
            imagesStackView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor, constant: 0),
        ])
        setupImages()
    }
    
    private func setupImages() {
        for _ in 0..<5 {
            let image = UIImageView()
            images.append(image)
            imagesStackView.addArrangedSubview(image)
        }
    }
    
    func configure (with text : String, amount : Int, commonImage : UIImage?, highlightedImage : UIImage?) {
        textLabel.text = text
        for i in 0..<images.count {
            images[i].image = i < amount ? highlightedImage : commonImage
        }
    }
}
