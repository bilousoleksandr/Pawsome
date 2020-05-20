//
//  NetworkErrorView.swift
//  Pawsome
//
//  Created by Marentilo on 19.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class NetworkErrorView : UIView {
    private let imageView = UIImageView(image: #imageLiteral(resourceName: "cryCat"))
    private let textLabel = Label.makeTitleLabel(with: Strings.cantLoad)
    private let newRequestButton = Button.makeRoundedButton(Strings.tryAgain, backgroundColor: UIColor.salmon)
    private var requestCallback : (() -> ())?
    
    var requestAction : (() -> ())? {
        get { return requestCallback }
        set { requestCallback = newValue }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        [imageView, textLabel, newRequestButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        newRequestButton.addTarget(self, action: #selector(newRequestButtonDidPress(sender:)), for: .touchUpInside)
        newRequestButton.makeShadow()
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant:  UIScreen.screenWidth() / 2.0),
            imageView.heightAnchor.constraint(equalToConstant: UIScreen.screenWidth() / 2.0),
            
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: StyleGuide.Spaces.double),
            textLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            newRequestButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: StyleGuide.Spaces.double),
            newRequestButton.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth() - StyleGuide.Spaces.double * 2),
            newRequestButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: - Actions
@objc private extension NetworkErrorView {
    func newRequestButtonDidPress(sender : UIButton) {
        if let callback = requestCallback {
            sender.makePulse()
            callback()
        }
    }
}
 
