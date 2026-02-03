//
//  ExtractedDataViewModel.swift
//  Monri
//
//  Created by Karolina Škunca on 03.02.2026..
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import Foundation
import Monri

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
