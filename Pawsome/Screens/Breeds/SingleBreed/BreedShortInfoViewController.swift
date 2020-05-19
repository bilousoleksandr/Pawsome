//
//  BreedShortInfoViewController.swift
//  Pawsome
//
//  Created by Marentilo on 05.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class BreedShortInfoViewController : UIViewController {
    private let breedViewModel : SingleBreeViewModel
    private let shortInfoView = BreedShortInfoView()
    
    init(breedMViewModel : SingleBreeViewModel) {
        self.breedViewModel = breedMViewModel
        super.init(nibName: nil, bundle : nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        shortInfoView.configure(image: UIImage(named: breedViewModel.breedName),
                                breedName: breedViewModel.breedName,
                                description: breedViewModel.breedDescription,
                                origin: breedViewModel.origin,
                                weight: breedViewModel.averageWeight,
                                lifespan: breedViewModel.averageLifeSpan)
    }
    
    private func setupView() {
        view.makeBlur()
        view.addSubview(shortInfoView)
        shortInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shortInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: StyleGuide.Spaces.single),
            shortInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -StyleGuide.Spaces.single),
            shortInfoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }
}
