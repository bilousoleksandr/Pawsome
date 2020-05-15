//
//  SavedImagesViewController.swift
//  Pawsome
//
//  Created by Marentilo on 08.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SavedImagesViewController : UICollectionViewController {
    private var savedImagesModel : SavedImagesViewModelProtocol
    private let segmentedController = SegmentedController(titles: ["Liked", "Saved"], selectedSection: 0) { (value) in
        print(value)
    }
    
    init(savedImagesModel : SavedImagesViewModelProtocol = SavedImagesViewModel()) {
        self.savedImagesModel = savedImagesModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        navigationController?.navigationBar.backgroundColor = UIColor.lightBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.delegate = self
        collectionView.registerReusableCell(SingleViewFeedCell.self)
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        savedImagesModel.urlsArrayDidUpdate = { [weak self] _ in
            self?.collectionView.reloadData()
        }
        view.addSubview(segmentedController)
        setupConstraints()
    }
    
    private func setupConstraints() {
        [segmentedController, collectionView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            segmentedController.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            segmentedController.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            segmentedController.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension SavedImagesViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedImagesModel.imagesCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SingleViewFeedCell.self, for: indexPath) else {
            fatalError()
        }
        savedImagesModel.imageForItem(at: indexPath.row) { (image) in
            cell.configure(with: image)
        }
        cell.contentView.backgroundColor = UIColor.salmon
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SavedImagesViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.width - 6) / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
