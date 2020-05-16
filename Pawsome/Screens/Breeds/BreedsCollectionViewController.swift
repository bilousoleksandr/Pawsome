//
//  BreedsCollectionViewController.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class BreedsCollectionViewController : UICollectionViewController {
    private let breedViewModel : BreedViewModel
    
    init(collectionViewLayout layout: UICollectionViewLayout, breedViewModel : BreedViewModel = BreedViewModel()) {
        self.breedViewModel = breedViewModel
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
        setupBreedModel()
        setStandartBackButton()
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapPressed(sender:)))
        collectionView.addGestureRecognizer(longTapGesture)
    }
    
    private func setupBreedModel () {
        breedViewModel.breedsDidLoad = { [weak self] in
            self?.collectionView.reloadData()
            (0..<self!.breedViewModel.breedsCount).forEach {
                print(self!.breedViewModel.breedDetails(for: $0))
            }
        }
        breedViewModel.breeadsFailedLoad = {
            let alert = UIAlertController(title: "fdh", message: "fghfhg", preferredStyle: .actionSheet)
            self.present(alert, animated: true, completion: nil)
            print("failed")
        }
        breedViewModel.fetchBreedsList()
    }
    
    private func longPressStartedHandler (at point : CGPoint) {
        if let indexPath = collectionView.indexPathForItem(at: point) {
            let singleBreed = SingleBreeViewModel(breed: breedViewModel.singleBreed(for: indexPath.row))
            let vc = BreedShortInfoViewController(breedMViewModel: singleBreed)
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
        return breedViewModel.breedsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SingleBreedCollectionViewCell.self, for: indexPath) else { fatalError() }
        let source = breedViewModel.breedDetails(for: indexPath.row)
        cell.configure(with: source.name, and: source.origin)
        return cell
    }
}

// MARK: - UICollectionFlowLayoutDelegate
extension BreedsCollectionViewController : UICollectionViewDelegateFlowLayout {
    private var smallItemSize : CGFloat {
        return (collectionView.bounds.width - 15) / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: smallItemSize, height: smallItemSize * 1.3)
                                                                                                                              
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SingleBreedViewController(breedViewModel: SingleBreeViewModel(breed: breedViewModel.singleBreed(for: indexPath.row)))
        self.navigationController?.pushViewController(vc, animated: true)
    }
}