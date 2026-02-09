//
//  CardImageFooterView.swift
//  Monri
//
//  Created by Karolina Škunca on 03.02.2026..
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit

final class CardImageFooterView: UIView {

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])

        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    func configure(image: UIImage?) {
        imageView.image = image
    }
}
