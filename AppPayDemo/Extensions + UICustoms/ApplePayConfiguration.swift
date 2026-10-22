//
//  ApplePayConfiguration.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import Foundation

enum ApplePayConfiguration {

    private static let merchantIdentifierKey =
        "ApplePayMerchantIdentifier"

    static var merchantIdentifier: String {
        guard
            let identifier = Bundle.main.object(
                forInfoDictionaryKey: merchantIdentifierKey
            ) as? String,
            !identifier.isEmpty
        else {
            fatalError(
                "Missing \(merchantIdentifierKey) in Info.plist"
            )
        }

        return identifier
    }
}
