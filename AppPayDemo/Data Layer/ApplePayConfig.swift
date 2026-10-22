//
//  ApplePayConfig.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//


import Foundation
import PassKit

enum ApplePayConfig {
    static let merchantIdentifier = ApplePayConfiguration.merchantIdentifier

    static let countryCode = "EG"
    static let currencyCode = "EGP"

    @available(iOS 17.4, *)
    static let supportedNetworks: [PKPaymentNetwork] = [
        .visa,
        .masterCard,
        .amex,
        .meeza,
        .mada
    ]
}
