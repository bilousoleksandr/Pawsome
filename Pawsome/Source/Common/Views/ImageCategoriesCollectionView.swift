//
//  ImageCategoriesCollectionView.swift
//  Pawsome
//
//  Created by Marentilo on 18.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class ImageCategoriesCollectionView: UICollectionView {
    private let viewWidth : CGFloat = 120
    private var itemDidPressAction : ((String) -> Void)?
    
    private var items : [String] = [] {
        didSet {
            reloadData()
        }
    }
    
    var callbackAction : ((String) -> Void)? {
        get { return itemDidPressAction}
        set { itemDidPressAction = newValue}
    }
    
    var allCategories : [String] {
        get { return items }
        set { items = newValue }
    }
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        delegate = self
        dataSource = self
        backgroundColor = UIColor.lightBlue
        registerReusableCell(CategoryCollectionViewCell.self)
        showsHorizontalScrollIndicator = false
    }
}

// MARK: - ImageCategoriesCollectionView
extension ImageCategoriesCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewWidth, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let callbackAction = itemDidPressAction {
            callbackAction(items[indexPath.row])
        }
    }
}

extension ImageCategoriesCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(CategoryCollectionViewCell.self, for: indexPath) else { fatalError() }
        cell.configure(with: items[indexPath.row])
        return cell
    }
}


