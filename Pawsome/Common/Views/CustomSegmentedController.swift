//
//  CustomSegmentedController.swift
//  Pawsome
//
//  Created by Marentilo on 14.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SegmentedController : UIStackView {
    private let titles : [String]
    private let valueChangedAction : (String) -> Void
    private let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 4))
    private var selectedSection : Int {
        didSet {
            sectionSelectionHandler()
        }
    }
    
    init(titles : [String], selectedSection : Int, valueChangedAction : @escaping (String) -> Void) {
        self.titles = titles
        self.selectedSection = selectedSection
        self.valueChangedAction = valueChangedAction
        super.init(frame: .zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        titles.forEach { title in
            let button = Button.makeButton(title)
            button.addTarget(self, action: #selector(segmentedButtonPressed(sender:)), for: .touchUpInside)
            addArrangedSubview(button)
        }
        separatorView.backgroundColor = UIColor.salmon
        addSubview(separatorView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        subviews.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth() / CGFloat(titles.count))
            ])
        })
    }
    
    private func sectionSelectionHandler () {
        
    }
}

// MARK: - Actions
private extension SegmentedController {
    @objc func segmentedButtonPressed(sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text, let senderIndex = titles.firstIndex(of: buttonTitle) else { fatalError() }
        selectedSection = senderIndex
        valueChangedAction(buttonTitle)
    }
}
