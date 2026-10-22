//
//  ApplePayTokenRequest.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import Foundation

struct ApplePayTokenRequest: Encodable {
    let paymentData: String
    let amount: String
    let currency: String
}
