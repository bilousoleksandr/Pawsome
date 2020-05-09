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
        navigationItem.title = Strings.feed
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.delegate = self
        collectionView.registerReusableCell(SingleViewFeedCell.self)
        
        feedViewModel.imagesListDidChange = { [weak self] (feedViewModel) in
            guard let self = self else { fatalError() }
            UIView.transition(with: self.collectionView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { self.collectionView.reloadData() })
            self.updateRefreshControl()
        }
        
        feedViewModel.imageForIndexDidLoad = { [weak self] (indexPath) in
            guard let self = self else { fatalError() }
            if self.collectionView.numberOfSections - 1 >= indexPath.section && self.collectionView.numberOfItems(inSection: indexPath.section) >= indexPath.row {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self,
                                            action: #selector(refreshPage(sender:)),
                                            for: .valueChanged)
    }
    
    private func indexPathToIndex(indexPath : IndexPath) -> Int {
        if indexPath.section == 0 {
            return indexPath.row
        }
        let sectionIndex = Array(0..<indexPath.section).map({ $0 % 2 == 0 ? 3 : 6 }).reduce(0, +)
        return sectionIndex + indexPath.row
    }
    
    private func updateRefreshControl() {
        if let _ = collectionView.refreshControl?.isRefreshing {
            collectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Actions -
extension FeedCollectionViewController {
    @objc
    func refreshPage(sender: UIRefreshControl) {
        feedViewModel.removeAllImages()
        collectionView.reloadData()
        feedViewModel.showNewImages()
    }
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
        guard let cell = collectionView.dequeueReusableCell(SingleViewFeedCell.self, for: indexPath) else { fatalError() }
        feedViewModel.getImage(for: indexPathToIndex(indexPath: indexPath), with: indexPath, complition: { (image) in
            cell.configure(with: image)
        })
        return cell
    }
    
}

// MARK: - UICollectionViewFlowlayoutDelegate -
extension FeedCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let maxSection = collectionView.numberOfSections
        if indexPath.section == maxSection - 2 {
            feedViewModel.showNewImages()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        feedViewModel.getImage(for: indexPathToIndex(indexPath: indexPath), with: indexPath) { (image) in
            let imageURL = self.feedViewModel.urlForPressedImage(at: self.indexPathToIndex(indexPath: indexPath))
            let vc = FullScreenViewController(fullScreenViewModel: FullScrenViewModel(imageURL))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


