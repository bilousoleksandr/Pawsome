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
    
    init(savedImagesModel : SavedImagesViewModelProtocol = SavedImagesViewModel()) {
        self.savedImagesModel = savedImagesModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.registerReusableCell(SingleViewFeedCell.self)
        savedImagesModel.urlsArrayDidUpdate = { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
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
