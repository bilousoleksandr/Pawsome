//
//  SingleBreedViewController.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SingleBreedViewController : UIViewController {
    private let breedViewModel : SingleBreedViewModel
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: StyleGuide.Spaces.double, bottom: 0, right: StyleGuide.Spaces.double)
        view.registerReusableCell(BreedDetailsCollectionViewCell.self)
        view.dataSource = self
        view.delegate = self
        return view
    } ()
    
    private lazy var scrollView : BreedScrollView = {
        let view = BreedScrollView(collectionView: self.collectionView)
        return view
    } ()
    
    init(breedViewModel : SingleBreedViewModel) {
        self.breedViewModel = breedViewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = breedViewModel.breedName
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupView()
        scrollView.configureBreedView(name: breedViewModel.breedName,
                                      origin: breedViewModel.origin,
                                      weight: breedViewModel.averageWeight,
                                      lifeSpan: breedViewModel.averageLifeSpan,
                                      breedText: breedViewModel.breedDescription,
                                      breedFeatures: breedViewModel.breedFeatures,
                                      rare: breedViewModel.rare,
                                      experimental: breedViewModel.experimental,
                                      natural: breedViewModel.natural)
    }

    private func setupView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let constrains = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constrains)
    }
}

// MARK: - UICollectionViewDataSource -
extension SingleBreedViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedViewModel.temperament.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(BreedDetailsCollectionViewCell.self, for: indexPath) else { fatalError() }
        cell.configureCell(with: breedViewModel.temperament[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate -
extension SingleBreedViewController : UICollectionViewDelegateFlowLayout {
    private var itemSize : CGFloat {
        return collectionView.bounds.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return StyleGuide.Spaces.double
    }
}


