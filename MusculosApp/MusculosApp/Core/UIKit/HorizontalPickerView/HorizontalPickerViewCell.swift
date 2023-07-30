//
//  HorizontalPickerViewCell.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.07.2023.
//

import Foundation
import UIKit

class HorizontalPickerViewCell: UICollectionViewCell {
    static let identifier = String(describing: HorizontalPickerViewCell.self)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.alpha = 0.7
        view.layer.borderColor = CGColor(gray: 0, alpha: 0)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(circleView)

        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 90),
            circleView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        sendSubviewToBack(circleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
    }
    
    public func configure(with title: String, isSelected: Bool = false) {
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: isSelected ? 25 : 23, weight: .regular)
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.backgroundColor = isSelected ? .gray : .clear
        circleView.layer.borderWidth = isSelected ? 0 : 2
    }
}
