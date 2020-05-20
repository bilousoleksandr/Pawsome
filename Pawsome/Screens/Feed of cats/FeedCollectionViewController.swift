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
    private var categoriesCollectionView : ImageCategoriesCollectionView
    private let networkErrorView = NetworkErrorView()
    private let loadingIndicator = UIActivityIndicatorView(style: .gray)
    
    init(feedViewModel : FeedViewModel = FeedViewModelImplementation()) {
        self.feedViewModel = feedViewModel
        self.categoriesCollectionView = ImageCategoriesCollectionView()
        let flowLayout = CatFeedLayout()
        super.init(collectionViewLayout: flowLayout)
        navigationItem.title = Strings.feed
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(categoriesCollectionView)
        view.addSubview(loadingIndicator)
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        collectionView.registerReusableCell(SingleViewFeedCell.self)
        setStandartBackButton()
        setupCallbacks()
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTapAction(sender:))))
        setupConstrains()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        feedViewModel.saveImagesOnDisk()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if collectionView.numberOfSections == 0 {
            updateData()
        }
    }
    
    private func setupCallbacks() {
        feedViewModel.categoriesListDidChange = { [weak self] (viewModel) in
            self?.categoriesCollectionView.allCategories = viewModel.imageCategories
        }
        feedViewModel.listDidFailLoading = { [weak self] in
            guard let sections = self?.collectionView.numberOfSections, sections == 0 else { return }
            self?.setupErrorView()
            self?.loadingIndicator.stopAnimating()
        }
        feedViewModel.imagesListDidChange = { [weak self] (feedViewModel) in
            guard let self = self else { fatalError() }
            self.collectionView.performBatchUpdates({
                let indexSet = IndexSet(self.collectionView.numberOfSections..<(self.feedViewModel.imagesCount / 9 * 2))
                self.collectionView.insertSections(indexSet)
            }, completion: nil)
            self.loadingIndicator.stopAnimating()
            self.networkErrorView.removeFromSuperview()
        }
        categoriesCollectionView.callbackAction = { [weak self] selectedName in
            guard let self = self  else { return }
            let category = self.feedViewModel.selectedCategory(name: selectedName)
            self.feedViewModel.presentFullScreenFeed(withImageIndex: nil, and: category)
        }
        networkErrorView.requestAction = { [weak self] in
            self?.updateData()
        }
    }
    
    private func updateData() {
        feedViewModel.showNewImages()
        feedViewModel.loadCategories()
        loadingIndicator.startAnimating()
    }
    
    private func setupErrorView() {
        view.addSubview(networkErrorView)
        networkErrorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            networkErrorView.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth()),
            networkErrorView.heightAnchor.constraint(equalToConstant: UIScreen.screenWidth()),
            networkErrorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            networkErrorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -StyleGuide.Spaces.double)
        ])
    }
    
    private func setupConstrains() {
        [categoriesCollectionView, collectionView, loadingIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loadingIndicator.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: StyleGuide.Spaces.single),
        ])
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
            feedViewModel.showLargeImage(at: indexPathToIndex(indexPath: indexPath))
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
            return feedViewModel.imagesCount  / 9 * 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section % 2 == 0 ? 3 : 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SingleViewFeedCell.self, for: indexPath) else { fatalError() }
        feedViewModel.getImage(for: indexPathToIndex(indexPath: indexPath), complition: { (image) in
            cell.configure(with: image)
        })
        return cell
    }
}

// MARK: -
extension FeedCollectionViewController : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let maxSections = collectionView.numberOfSections
        let targetIndexPath = IndexPath(row: 0, section: maxSections - 2)
        let cells = collectionView.visibleCells.map({ collectionView.indexPath(for: $0) }).compactMap({ $0 })
        if cells.contains(targetIndexPath) {
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
        self.feedViewModel.presentFullScreenFeed(withImageIndex: indexPathToIndex(indexPath: indexPath), and: nil)
    }
}


