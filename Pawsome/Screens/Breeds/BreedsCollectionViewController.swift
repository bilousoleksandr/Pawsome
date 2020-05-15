//
//  BreedsCollectionViewController.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class BreedsCollectionViewController : UICollectionViewController {
    private var allBreeds : [Breed] = []
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        navigationItem.title = Strings.breeds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.registerReusableCell(SingleBreedCollectionViewCell.self)
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapPressed(sender:)))
        collectionView.addGestureRecognizer(longTapGesture)
        
        let network = NetworkServiceImplementation()
        network.allBreeds(onSuccess: { [weak self] (breeds) in
            guard let self = self else { fatalError() }
            self.allBreeds = breeds
            self.collectionView.reloadData()
        })
    }
    
    private func longPressStartedHandler (at point : CGPoint) {
        if let indexPath = collectionView.indexPathForItem(at: point) {
            let breedAtIndex = BreedViewModel(breed: allBreeds[indexPath.row])
            let vc = BreedShortInfoViewController(breedMViewModel: breedAtIndex)
            showFullScreen(vc)
        }
    }
    
    private func longPressEndedHandler() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Actions -
@objc
extension BreedsCollectionViewController : UIPopoverPresentationControllerDelegate{
    func longTapPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            longPressStartedHandler(at: sender.location(in: collectionView))
        } else if sender.state == .ended || sender.state == .cancelled {
            longPressEndedHandler()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension BreedsCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allBreeds.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SingleBreedCollectionViewCell.self, for: indexPath) else { fatalError() }
        cell.configure(with: allBreeds[indexPath.row].breedName, and: allBreeds[indexPath.row].origin)
        return cell
    }
}

// MARK: - UICollectionFlowLayoutDelegate
extension BreedsCollectionViewController : UICollectionViewDelegateFlowLayout {
    private var smallItemSize : CGFloat {
        return (collectionView.bounds.width - 15) / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: smallItemSize, height: smallItemSize * 1.5)
                                                                                                                              
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SingleBreedViewController(breedViewModel: BreedViewModel(breed: allBreeds[indexPath.row]))
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
