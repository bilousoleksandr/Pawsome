//
//  BreedShortInfoViewController.swift
//  Pawsome
//
//  Created by Marentilo on 05.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class BreedShortInfoViewController : UIViewController {
    private let breedViewModel : BreedViewModel
    private let shortInfoView = BreedShortInfoView()
    
    init(breedMViewModel : BreedViewModel) {
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
                                intelligence: breedViewModel.intelligence,
                                socialNeeds: breedViewModel.socialNeeds)
    }
    
    private func setupView() {
        view.makeBlur()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(screenDidTap(sender:))))
        view.addSubview(shortInfoView)
        shortInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shortInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: StyleGuide.Spaces.single),
            shortInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -StyleGuide.Spaces.single),
            shortInfoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }
}

// MARK: - Actions -
extension BreedShortInfoViewController {
    @objc func screenDidTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
