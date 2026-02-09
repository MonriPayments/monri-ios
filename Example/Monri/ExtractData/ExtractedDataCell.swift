//
//  ExtractedDataCell.swift
//  Monri
//
//  Created by Karolina Škunca on 03.02.2026..
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit

struct ExtractedDataRow {
    let title: String
    let value: String
}

final class ExtractedDataCell: UITableViewCell {

    static let reuseId = "ExtractedDataCell"

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        
        backgroundColor = .white
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .lightGray

        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.textColor = .black
        valueLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with row: ExtractedDataRow) {
        titleLabel.text = row.title
        valueLabel.text = row.value
    }
}
