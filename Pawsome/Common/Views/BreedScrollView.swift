//
//  BreedCollectionView.swift
//  Pawsome
//
//  Created by Marentilo on 08.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class BreedScrollView : UIScrollView {
    private let headerView = BreedHeaderView()
    private let topView = UIView()
    private let averageInfoView = UIView()
    private let textView = UIView()
    private let bottomView = UIView()
    private let screenWidth = UIScreen.screenWidth()
    private let lifeSpanView = HeaderDetailsView()
    private let weightView = HeaderDetailsView()
    private let textLabel = Label.makeBreedDescriptionLabel()
    private let collectionView : UICollectionView
    private var temperamentCount = 7
    
    private lazy var breedFeachuresView : [BreedFeatureView] = {
        var array = [BreedFeatureView]()
        for _ in 0..<7 {
            array.append(BreedFeatureView())
        }
        return array
    } ()
    
    private let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.alignment = .fill
        return stack
    } ()
    
    init(collectionView : UICollectionView) {
        self.collectionView = collectionView
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        addSubview(stackView)
        setupConstrains()
        [topView, averageInfoView, textView, collectionView, bottomView].forEach {
            stackView.addArrangedSubview($0)
        }
        setupHeaderView()
        setupAverageView()
        setupTextView()
        setupBottomView()
    }
    
    private func setupHeaderView() {
        topView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -StyleGuide.Spaces.double),
            headerView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: StyleGuide.Spaces.double),
            headerView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupConstrains() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let constrains = [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -StyleGuide.Spaces.double),
            stackView.widthAnchor.constraint(equalToConstant: screenWidth),
            
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(constrains)
    }
    
    private func setupAverageView () {
        averageInfoView.translatesAutoresizingMaskIntoConstraints                = false
        averageInfoView.heightAnchor.constraint(equalToConstant: 80).isActive    = true
        
        [lifeSpanView, weightView].forEach {
            averageInfoView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            lifeSpanView.leadingAnchor.constraint(equalTo: averageInfoView.leadingAnchor, constant: StyleGuide.Spaces.double),
            lifeSpanView.topAnchor.constraint(equalTo: averageInfoView.topAnchor, constant: 0),
            lifeSpanView.heightAnchor.constraint(equalTo: averageInfoView.heightAnchor),
            lifeSpanView.trailingAnchor.constraint(equalTo: averageInfoView.centerXAnchor, constant: -StyleGuide.Spaces.double),
            
            weightView.leadingAnchor.constraint(equalTo: averageInfoView.centerXAnchor, constant: StyleGuide.Spaces.single),
            weightView.trailingAnchor.constraint(equalTo: averageInfoView.trailingAnchor, constant: -StyleGuide.Spaces.double),
            weightView.heightAnchor.constraint(equalTo: averageInfoView.heightAnchor),
            weightView.topAnchor.constraint(equalTo: averageInfoView.topAnchor, constant: 0)
        ])
    }
    
    private func setupTextView() {
        textView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 0),
            textLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: StyleGuide.Spaces.double),
            textLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -StyleGuide.Spaces.double),
            textLabel.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0),
        ])
    }
    
    private func setupBottomView() {
        var constraints : [NSLayoutConstraint] = []
        breedFeachuresView.forEach { featureView in
            featureView.translatesAutoresizingMaskIntoConstraints = false
            guard let index = breedFeachuresView.firstIndex(of: featureView) else { fatalError() }
            bottomView.addSubview(featureView)
            constraints.append(featureView.topAnchor.constraint(equalTo: index == 0 ? bottomView.topAnchor : breedFeachuresView[index - 1].bottomAnchor, constant: StyleGuide.Spaces.single))
            constraints.append(featureView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: StyleGuide.Spaces.double))
            constraints.append(featureView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -StyleGuide.Spaces.double))
            constraints.append(featureView.heightAnchor.constraint(equalToConstant: 50))
            
            if let last = breedFeachuresView.last, last == featureView {
                constraints.append(featureView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -StyleGuide.Spaces.single))
            }
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureBreedView(name: String, origin: String, friendlyText : String,
                            weight : String, lifeSpan : String,
                            breedText: String, breedFeatures : [BreedFeature],
                            rare : Int, experimental : Int, natural : Int) {
        
        headerView.configure(name: name, origin: origin, friendlyText: friendlyText, rare: rare, experimental: experimental, natural: natural)
        lifeSpanView.configure(value: weight, details: .weight)
        weightView.configure(value: lifeSpan, details: .lifeSpan)
        textLabel.text = breedText
        for (index, feature) in breedFeatures.enumerated() {
            breedFeachuresView[index].configure(with: feature.featureName,
                                                amount: feature.index,
                                                commonImage: feature.commonImage,
                                                highlightedImage: feature.highlightedImage)
        }
    }
}
