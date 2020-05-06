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
    private var longTapPressed = false
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        navigationItem.title = Strings.breeds
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.delegate = self
        collectionView.register(SingleBreedCollectionViewCell.self, forCellWithReuseIdentifier: "id")
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapPressed(sender:)))
        collectionView.addGestureRecognizer(longTapGesture)
        
        let network = NetworkServiceImplementation()
        network.allBreeds(onSuccess: { [weak self] (breeds) in
            guard let self = self else { fatalError() }
            self.allBreeds = breeds
            print(breeds.map({$0.breedName}))
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
}

// MARK: - Actions -
extension BreedsCollectionViewController : UIPopoverPresentationControllerDelegate{
    @objc func longTapPressed(sender: UILongPressGestureRecognizer) {
        if !longTapPressed {
            let tapLocation = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: tapLocation) {
                let breedAtIndex = BreedViewModel(breed: allBreeds[indexPath.row])
                let vc = BreedShortInfoViewController(breedMViewModel: breedAtIndex)
                showFullScreen(vc)
            }
            longTapPressed = !longTapPressed
        }
        if sender.state == .ended {
            presentedViewController?.dismiss(animated: true, completion: nil)
            longTapPressed = false
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! SingleBreedCollectionViewCell
        cell.configure(with: allBreeds[indexPath.row].breedName)
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.blus.cgColor
        return cell
    }
}

// MARK: - UICollectionFlowLayoutDelegate
extension BreedsCollectionViewController : UICollectionViewDelegateFlowLayout {
    private var smallItemSize : CGFloat {
        return (view.bounds.width - 1) / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size : CGSize
        if indexPath.row % 7 == 0 || indexPath.row == (collectionView.numberOfItems(inSection: indexPath.section) - 1) && indexPath.row % 2 == 0 {
            size = CGSize(width: view.bounds.width, height: view.bounds.width / 2)
        } else {
            size = CGSize(width: smallItemSize, height: smallItemSize)
        }
        return size
                                                                                                                              
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SingleBreedViewController(breedViewModel: BreedViewModel(breed: allBreeds[indexPath.row]))
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
