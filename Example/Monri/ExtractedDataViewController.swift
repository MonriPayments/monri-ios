//
//  ExtractedDataViewController.swift
//  Monri
//
//  Created by Karolina Škunca on 30.01.2026..
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit
import Monri

final class ExtractedDataViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let viewModel: ExtractedDataViewModel

    init(data: ExtractionResponse) {
        self.viewModel = ExtractedDataViewModel(data: data)
        super.init(nibName: nil, bundle: nil)
        self.title = "Extracted data"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addCardImageFooter(image: imageFromBase64(viewModel.imageBase64!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    func imageFromBase64(_ base64: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64,
                              options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: data)
    }

    private func setupUI() {
        
        title = "Extraction Data"
        view.backgroundColor = .white

        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ExtractedDataCell.self,
                           forCellReuseIdentifier: ExtractedDataCell.reuseId)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func addCardImageFooter(image: UIImage?) {
        let footer = CardImageFooterView(frame: CGRect(
            x: 0,
            y: 0,
            width: tableView.bounds.width,
            height: 260
        ))

        footer.configure(image: image)
        tableView.tableFooterView = footer
    }

}

extension ExtractedDataViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: ExtractedDataCell.reuseId,
            for: indexPath
        ) as! ExtractedDataCell

        cell.configure(with: viewModel.rows[indexPath.row])
        return cell
    }
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

struct ExtractedDataRow {
    let title: String
    let value: String
}

final class ExtractedDataViewModel {

    private let data: ExtractionResponse

    init(data: ExtractionResponse) {
        self.data = data
    }

    var rows: [ExtractedDataRow] {
        [
            row("Holder name", data.data?.holdersName),
            row("IBAN", data.data?.iban),
            row("Issued date", data.data?.issuedDate),
            row("Card number", data.data?.cardNumber),
            row("Expiry date", data.data?.expiryDate),
            row("Luhn check", data.data?.luhnCheck),
            row("Extracted texts", data.data?.extractedTexts)
        ].compactMap { $0 }
    }

    private func row(_ title: String, _ value: String?) -> ExtractedDataRow? {
        guard let text = value, !text.isEmpty else { return nil }
        return ExtractedDataRow(title: title, value: text)
    }
    
    var imageBase64: String? {
        data.imageData?.creditCardImage
    }
}

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


