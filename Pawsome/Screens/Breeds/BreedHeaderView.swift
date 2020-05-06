//
//  BreedHeaderView.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class BreedHeaderView : UIView {
    private let catImageView = UIImageView()
    private let strangerFriendlyLabel = Label.makeSubtitleLabel(with: Strings.strangerFriendly)
    private let originLabel = Label.makeSubtitleLabel()
    
    private let friendlyDetailsLabel : UILabel = {
        let label = Label.makeSubtitleLabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        return label
    } ()
    
    private let originDetailsLabel : UILabel = {
        let label = Label.makeSubtitleLabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        return label
    } ()
    
    private let breedTitleLabel = Label.makeTitleLabel()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        [catImageView, breedTitleLabel, strangerFriendlyLabel, friendlyDetailsLabel, originLabel, originDetailsLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstrains()
    }
    
    private func setupConstrains() {
        let constrains = [
            catImageView.topAnchor.constraint(equalTo: topAnchor, constant: StyleGuide.Spaces.double),
            catImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            catImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            catImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            catImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            
            breedTitleLabel.topAnchor.constraint(equalTo: catImageView.topAnchor, constant: StyleGuide.Spaces.double * 2),
            breedTitleLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -StyleGuide.Spaces.single),
            breedTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            
            originLabel.topAnchor.constraint(equalTo: breedTitleLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            originLabel.leadingAnchor.constraint(equalTo: breedTitleLabel.leadingAnchor, constant: 0),
            
            originDetailsLabel.leadingAnchor.constraint(equalTo: originLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            originDetailsLabel.centerYAnchor.constraint(equalTo: originLabel.centerYAnchor, constant: 0),
            
            strangerFriendlyLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            strangerFriendlyLabel.leadingAnchor.constraint(equalTo: originLabel.leadingAnchor, constant: 0),
            
            friendlyDetailsLabel.leadingAnchor.constraint(equalTo: strangerFriendlyLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            friendlyDetailsLabel.centerYAnchor.constraint(equalTo: strangerFriendlyLabel.centerYAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constrains)
    }
    
    /// configure view according to given breed ViewModel
    func configure(name : String, origin: String, friendlyText : String) {
        catImageView.image = UIImage(named: name)
        breedTitleLabel.text = name
        friendlyDetailsLabel.text = friendlyText
        originLabel.text = Strings.origin
        originDetailsLabel.text = origin
    }
}
