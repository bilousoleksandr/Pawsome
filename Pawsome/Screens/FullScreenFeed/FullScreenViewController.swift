//
//  FullScreenViewController.swift
//  Pawsome
//
//  Created by Marentilo on 07.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class FullScreenViewController : UITableViewController {
    private var fullScreenViewModel : FullScrenViewModel
    private var visibleCellIndexPath : IndexPath?
    
    init(fullScreenViewModel : FullScrenViewModel) {
        self.fullScreenViewModel = fullScreenViewModel
        super.init(style: .plain)
        navigationItem.title = Strings.similarCats
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        tableView.registerReusableCell(FullScreenTableViewCell.self)
        
        fullScreenViewModel.imagesListDidChange = { [weak self] _ in
            guard let self = self else { fatalError() }
            let currentIndex = self.tableView.numberOfRows(inSection: 0)
            let newIndexes = self.fullScreenViewModel.itemsCount - 1
            if currentIndex < newIndexes  {
                let indexes = Array(currentIndex...newIndexes).map({ IndexPath(row: $0, section: 0)})
                self.tableView.performBatchUpdates({
                    self.tableView.insertRows(at: indexes, with: .fade)
                }, completion: nil)
            }
        }
        fullScreenViewModel.showNewImages()
    }
    
    private func savedButtonDidPress(_ image: UIImage?, at cell : UITableViewCell, isSaved : Bool) {
        guard isSaved else { return }
        let startPoint = cell.frame.origin
        let savedImageView = UIImageView(frame: CGRect(origin: startPoint,
                                                       size: CGSize(width: UIScreen.screenWidth(),
                                                                    height: UIScreen.screenWidth())))
        
        savedImageView.contentMode = .scaleAspectFit
        savedImageView.image = image
        self.view.addSubview(savedImageView)
        if let endPoint = tabBarController?.tabBar.subviews.last?.frame,
            let frame = tabBarController?.tabBar.convert(endPoint, to: view) {
            UIView.animateKeyframes(withDuration: 0.45, delay: 0, options: .calculationModeCubicPaced, animations: {
                savedImageView.center = CGPoint(x: frame.midX, y: frame.midY)
                savedImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { (_) in
                savedImageView.removeFromSuperview()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension FullScreenViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullScreenViewModel.itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(FullScreenTableViewCell.self) else { fatalError() }
        fullScreenViewModel.getImage(for: indexPath.row) { [weak self] (image) in
            guard let self = self else { fatalError() }
            itemCell.setImage(image,
                              self.fullScreenViewModel.isSavedImage(for: indexPath.row),
                              isLiked: self.fullScreenViewModel.isLikedImage(for: indexPath.row),
                              saveAction: {
                                    self.fullScreenViewModel.saveImage(at: indexPath.row)
                                    self.savedButtonDidPress(image, at: itemCell, isSaved: self.fullScreenViewModel.isSavedImage(for: indexPath.row))
                              }, likeAction: {
                                    self.fullScreenViewModel.likeImage(at: indexPath.row)
                              })
        }
        itemCell.selectionStyle = .none
        return itemCell
    }
}

extension FullScreenViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let cell = tableView.visibleCells.last,
            let lastIndexPath = tableView.indexPath(for: cell),
            lastIndexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            fullScreenViewModel.showNewImages()
        }
    }
}

// MARK: - Actions
@objc
private extension FullScreenViewController {
    func backButtonPressed(sender: UIBarButtonItem) {
        fullScreenViewModel.removeAllImages()
        self.navigationController?.popViewController(animated: true)
    }
}
