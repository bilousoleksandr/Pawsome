//
//  FeedCollectionViewController.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class FeedCollectionViewController : UICollectionViewController {
    private var images : [UIImage] = [#imageLiteral(resourceName: "s1200")]
    private var feedViewModel = FeedViewModel(feed: Feed())
    
    init() {
        let flowLayout = CatFeedLayout()
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.delegate = self
        collectionView.register(SingleViewFeedCell.self, forCellWithReuseIdentifier: "id")
        
        feedViewModel.imagesListDidChange = { [weak self] (feedViewModel) in
            guard let self = self else { fatalError() }
            print("reloaddata")
            self.collectionView.reloadData()
        }
        
        feedViewModel.imageForIndexDidLoad = { [weak self] (indexPath) in
            guard let self = self else { fatalError() }
            if self.collectionView.numberOfSections - 1 >= indexPath.section && self.collectionView.numberOfItems(inSection: indexPath.section) >= indexPath.row {
                UIView.animate(withDuration: 0) {
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
        }
    }
    
    private func indexPathToIndex(indexPath : IndexPath) -> Int {
        if indexPath.section == 0 {
            return indexPath.row
        }
        let sectionIndex = Array(0..<indexPath.section).map({ $0 % 2 == 0 ? 3 : 6 }).reduce(0, +)
        return sectionIndex + indexPath.row
    }
}

// MARK: - Actions -
extension FeedCollectionViewController {
    
}

// MARK: - UICollectionViewDataSource -
extension FeedCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
            return feedViewModel.urls.count  / 9 * 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section % 2 == 0 ? 3 : 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! SingleViewFeedCell
        cell.configure(with: feedViewModel.image(for: indexPathToIndex(indexPath: indexPath), with : indexPath))
        return cell
    }
    
}

// MARK: - UICollectionViewFlowlayoutDelegate -
extension FeedCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let maxSection = collectionView.numberOfSections - 1
        if indexPath.section == maxSection && indexPath.row == collectionView.numberOfItems(inSection: maxSection) - 1 {
            feedViewModel.showNewImages()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}


