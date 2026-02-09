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

        whiteNavigationBarAppearance()
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


