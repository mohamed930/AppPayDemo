//
//  PaymentUseCases.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import Foundation
import Combine

final class PaymentUseCases {
    
    weak var respotery: PaymentRespoteryProtocol?
    
    init(respotery: PaymentRespoteryProtocol) {
        self.respotery = respotery
    }
    
    func makePayment(amount: Double,currency: String = "EGP") -> Future<Bool,NSError> {
        guard let respotery else { fatalError("Respotery is nil") }
    
        return respotery.makeApplePayment(amount: amount, Currency: currency)
    }
}
