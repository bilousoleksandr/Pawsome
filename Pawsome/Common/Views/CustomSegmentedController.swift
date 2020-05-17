//
//  CustomSegmentedController.swift
//  Pawsome
//
//  Created by Marentilo on 14.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SegmentedController : UIView {
    private let titles : [String]
    private var buttons : [UIButton]
    private let valueChangedAction : (Int) -> Void
    private let separatorView = UIView()
    private let viewHeight : CGFloat = 60

    private let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        return stack
    } ()
    
    private var selectedSection : Int {
        didSet {
            sectionSelectionHandler(selectedSection)
        }
    }
    
    init(titles : [String], selectedSection : Int, valueChangedAction : @escaping (Int) -> Void) {
        self.titles = titles
        self.selectedSection = selectedSection
        self.valueChangedAction = valueChangedAction
        self.buttons = [UIButton]()
        super.init(frame: .zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        addSubview(stackView)
        titles.forEach { title in
            let button = Button.makeButton(title)
            button.addTarget(self, action: #selector(segmentedButtonPressed(sender:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        setupConstraints()
        
        separatorView.backgroundColor = UIColor.salmon
        addSubview(separatorView)
        let separatoHeight : CGFloat = 4
        separatorView.frame = CGRect(x: 0,
                                     y: viewHeight - separatoHeight,
                                     width: UIScreen.screenWidth() / CGFloat(titles.count),
                                     height: separatoHeight)
        segmentedButtonPressed(sender: buttons[selectedSection])
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalToConstant: viewHeight)
        ])
        
        stackView.arrangedSubviews.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth() / CGFloat(titles.count))
            ])
        })
    }
    
    private func sectionSelectionHandler (_ index : Int) {
        let zeroXPosition = UIScreen.screenWidth() / CGFloat(titles.count * 2)
        let sectionSize = UIScreen.screenWidth() / CGFloat(titles.count)
        let newXPosition = zeroXPosition + sectionSize * CGFloat(index)
        let newCenter = CGPoint(x: newXPosition, y: separatorView.center.y)
        UIView.animate(withDuration: 0.3) {
            self.separatorView.center = newCenter
        }
    }
}

// MARK: - Actions
private extension SegmentedController {
    @objc func segmentedButtonPressed(sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text, let senderIndex = titles.firstIndex(of: buttonTitle) else { fatalError() }
        buttons.forEach({ $0.isSelected = false })
        sender.isSelected = true
        selectedSection = senderIndex
        valueChangedAction(senderIndex)
    }
}
