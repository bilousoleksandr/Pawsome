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
        print(UIDevice.uniqID())
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
        
        tableView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureIsActive(sender:))))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        fullScreenViewModel.imagesListDidChange = { [weak self] _ in
            guard let self = self else { fatalError() }
            let currentIndex = self.tableView.numberOfRows(inSection: 0)
            let newIndexes = self.fullScreenViewModel.itemsCount - 1
            if currentIndex < newIndexes {
                let indexes = Array(currentIndex...newIndexes).map({ IndexPath(row: $0, section: 0)})
                self.tableView.performBatchUpdates({
                    self.tableView.insertRows(at: indexes, with: .fade)
                }, completion: nil)
            }
        }
        fullScreenViewModel.showNewImages()
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
    
    func pinchGestureIsActive(sender : UIPinchGestureRecognizer) {
        print(sender)
        if let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) {
            let rect = tableView.rectForRow(at: indexPath)
            print(indexPath)
        }
    }
}
