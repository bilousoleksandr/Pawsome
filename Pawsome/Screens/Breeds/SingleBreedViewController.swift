//
//  SingleBreedViewController.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SingleBreedViewController : UIViewController {
    private let breedViewModel : BreedViewModel
    private let headerView = BreedHeaderView()
    private let tableView = UITableView()
    private let textLabel = Label.makeTextLabel()
    private let averageInfoView = UIView()
    private let lifeSpanView = HeaderDetailsView()
    private let weightView = HeaderDetailsView()
    private let scrollView = UIScrollView()
    
    private lazy var breedFeachuresView : [BreedFeatureView] = {
        var array = [BreedFeatureView]()
        for _ in 0..<breedViewModel.breedFeatures.count {
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

    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(BreedDetailsCollectionViewCell.self, forCellWithReuseIdentifier: "id")
        view.dataSource = self
        view.delegate = self
        return view
    } ()
    
    init(breedViewModel : BreedViewModel) {
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
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        [headerView, averageInfoView, textLabel, collectionView].forEach { stackView.addArrangedSubview($0) }
        setupConstrains()
        configureAverageView()
        configureBreedFeachures()
        stackView.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 0, height: StyleGuide.Spaces.double * 1.5)))
        
        headerView.configure(name: breedViewModel.breedName, origin: breedViewModel.origin, friendlyText: breedViewModel.strangerFriendly)
        lifeSpanView.configure()
        weightView.configure()
        textLabel.text = breedViewModel.breedDescription
        
        for (index, view) in breedFeachuresView.enumerated() {
            let source = breedViewModel.breedFeatures[index]
            view.configure(with: source.featureName, amount: source.index, commonImage: source.commonImage, highlightedImage: source.highlightedImage)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = view.bounds
    }
    
    private func configureBreedFeachures () {
        breedFeachuresView.forEach{
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            let constrains = [
                $0.heightAnchor.constraint(equalToConstant: 50),
                $0.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: StyleGuide.Spaces.double),
                $0.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -StyleGuide.Spaces.double)
            ]
            NSLayoutConstraint.activate(constrains)
        }
    }
    
    private func configureAverageView () {
        averageInfoView.translatesAutoresizingMaskIntoConstraints                = false
        averageInfoView.heightAnchor.constraint(equalToConstant: 80).isActive    = true
        
        [lifeSpanView, weightView].forEach {
            averageInfoView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            lifeSpanView.leadingAnchor.constraint(equalTo: averageInfoView.leadingAnchor, constant: 0),
            lifeSpanView.widthAnchor.constraint(equalTo: weightView.widthAnchor),
            lifeSpanView.heightAnchor.constraint(equalTo: weightView.heightAnchor),
            lifeSpanView.topAnchor.constraint(equalTo: averageInfoView.topAnchor, constant: 0),
            
            weightView.leadingAnchor.constraint(equalTo: averageInfoView.centerXAnchor, constant: StyleGuide.Spaces.single),
            weightView.trailingAnchor.constraint(equalTo: averageInfoView.trailingAnchor, constant: -StyleGuide.Spaces.double),
            weightView.heightAnchor.constraint(equalTo: averageInfoView.heightAnchor),
            weightView.topAnchor.constraint(equalTo: averageInfoView.topAnchor, constant: 0)
        ])
    }
    
    private func setupConstrains() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let constrains = [
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            collectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: StyleGuide.Spaces.double),
            collectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -StyleGuide.Spaces.double),
            
            textLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -StyleGuide.Spaces.double)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! BreedDetailsCollectionViewCell
        print(breedViewModel.temperament[indexPath.row])
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

// MARK: - UICollectionViewDelegate -
extension SingleBreedViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedViewModel.temperament.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = breedViewModel.temperament(for: indexPath.row)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
}



