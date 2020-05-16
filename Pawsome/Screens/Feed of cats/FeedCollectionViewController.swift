//
//  FeedCollectionViewController.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class FeedCollectionViewController : UICollectionViewController {
    private var feedViewModel : FeedViewModel
    
    init(feedViewModel : FeedViewModel = FeedViewModel()) {
        self.feedViewModel = feedViewModel
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
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        collectionView.registerReusableCell(SingleViewFeedCell.self)
        setStandartBackButton()
        
        feedViewModel.imagesListDidChange = { [weak self] (feedViewModel) in
            guard let self = self else { fatalError() }
            print(self.collectionView.numberOfSections)
            self.collectionView.performBatchUpdates({
                let indexSet = IndexSet(self.collectionView.numberOfSections..<(self.feedViewModel.urls.count / 9 * 2))
                self.collectionView.insertSections(indexSet)
            }, completion: nil)
        }
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTapAction(sender:))))
    }
    
    private func indexPathToIndex(indexPath : IndexPath) -> Int {
        if indexPath.section == 0 {
            return indexPath.row
        }
        let sectionIndex = Array(0..<indexPath.section).map({ $0 % 2 == 0 ? 3 : 6 }).reduce(0, +)
        return sectionIndex + indexPath.row
    }
    
    private func longPressDidBeganHandler(at point : CGPoint) {
        if let indexPath = collectionView.indexPathForItem(at: point) {
            feedViewModel.getImage(for: indexPathToIndex(indexPath: indexPath), with: indexPath) { [weak self] (image) in
                self?.showLagreImage(image)
            }
        }
    }
    
    private func longPressDidEndHandler() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Actions -
@objc
extension FeedCollectionViewController {
    func longTapAction(sender : UILongPressGestureRecognizer) {
        if sender.state == .ended || sender.state == .cancelled {
            longPressDidEndHandler()
        } else if sender.state == .began {
            longPressDidBeganHandler(at: sender.location(in: collectionView))
        }
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

// MARK: -
extension FeedCollectionViewController : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let maxSections = collectionView.numberOfSections
        let targetIndexPath = IndexPath(row: 0, section: maxSections - 3)
        let cells = collectionView.visibleCells.map({ collectionView.indexPath(for: $0) }).compactMap({ $0 })
        if feedViewModel.canPrefetchMoreItems, cells.contains(targetIndexPath) {
            feedViewModel.showNewImages()
        }
    }
}

// MARK: - UICollectionViewFlowlayoutDelegate -
extension FeedCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        feedViewModel.getImage(for: indexPathToIndex(indexPath: indexPath), with: indexPath) { (image) in
            let imageURL = self.feedViewModel.urlForPressedImage(at: self.indexPathToIndex(indexPath: indexPath))
            let vc = FullScreenViewController(fullScreenViewModel: FullScrenViewModel(imageURL))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


