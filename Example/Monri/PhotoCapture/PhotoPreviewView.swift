//
//  PhotoPreviewView.swift
//  Monri
//
//  Created by Karolina Škunca on 03.02.2026..
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit

// MARK: - Photo Preview View Delegate
protocol PhotoPreviewViewDelegate: AnyObject {
    func didTapRetakePhoto()
    func didTapSendForValidation()
}

// MARK: - Photo Preview View
final class PhotoPreviewView: UIView {
    
    // MARK: - Delegate
    weak var delegate: PhotoPreviewViewDelegate?
    
    // MARK: - UI Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Is this image clear?"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var retakeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retake", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(retakeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send for Validation", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .black
        
        addSubview(imageView)
        addSubview(questionLabel)
        addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(retakeButton)
        buttonStackView.addArrangedSubview(sendButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image View
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: questionLabel.topAnchor, constant: -30),
            
            // Question Label
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            questionLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -20),
            
            // Button Stack View
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Public Methods
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    // MARK: - Actions
    @objc private func retakeButtonTapped() {
        delegate?.didTapRetakePhoto()
    }
    
    @objc private func sendButtonTapped() {
        delegate?.didTapSendForValidation()
    }
}
