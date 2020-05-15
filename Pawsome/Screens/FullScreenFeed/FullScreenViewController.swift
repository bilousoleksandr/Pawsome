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
        tableView.registerReusableCell(FullScreenTableViewCell.self)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonPressed(sender:)))
        
        fullScreenViewModel.imagesListDidChange = { [weak self] _ in
            guard let self = self else { fatalError() }
            let currentIndex = self.tableView.numberOfRows(inSection: 0)
            let newIndexes = self.fullScreenViewModel.itemsCount - 1
            if currentIndex < newIndexes {
                let indexes = Array(currentIndex...newIndexes).map({ IndexPath(row: $0, section: 0)})
                self.tableView.performBatchUpdates({
                    self.tableView.insertRows(at: indexes, with: .none)
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

// MARK: - UITableViewDelegate
extension FullScreenViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath)
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 2 {
            fullScreenViewModel.showNewImages()
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

// MARK: - Actions
@objc
private extension FullScreenViewController {
    func backButtonPressed(sender: UIBarButtonItem) {
        fullScreenViewModel.removeAllImages()
        self.navigationController?.popViewController(animated: true)
    }
}
