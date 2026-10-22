//
//  PaymentUseCases.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import Foundation
import Combine

final class PaymentUseCases {
    
    private let respotery: PaymentRespoteryProtocol
    
    init(respotery: PaymentRespoteryProtocol) {
        self.respotery = respotery
    }
    
    func makePayment(amount: Double,currency: String = "EGP") -> Future<Bool,NSError> {
        return respotery.makeApplePayment(amount: amount, Currency: currency)
    }
}
