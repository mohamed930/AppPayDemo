//
//  PaymentRespoteryProtocol.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import Foundation
import Combine

protocol PaymentRespoteryProtocol: NSObject {
    func makeApplePayment(amount: Double,Currency: String) -> Future<Bool,NSError>
}
