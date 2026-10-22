//
//  PaymentRespotery.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import Foundation
import Combine

final class PaymentRespotery: NSObject,PaymentRespoteryProtocol {
    
    private var applePayManager: ApplePayManager
    
    init(applePayManager: ApplePayManager = ApplePayManager()) {
        self.applePayManager = applePayManager
    }
    
    func makeApplePayment(amount: Double, Currency: String) -> Future<Bool, NSError> {
        // Token capture demo: true means a nonempty token was received, not that funds were charged.
        Future { [applePayManager] promise in
            DispatchQueue.main.async {
                guard #available(iOS 17.4, *) else {
                    promise(.failure(NSError(
                        domain: "PaymentRespotery",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Apple Pay requires iOS 17.4 or later."]
                    )))
                    return
                }

                guard amount.isFinite, amount > 0 else {
                    promise(.failure(NSError(
                        domain: "PaymentRespotery",
                        code: -2,
                        userInfo: [NSLocalizedDescriptionKey: "Payment amount must be a positive, finite number."]
                    )))
                    return
                }

                let paymentAmount = Decimal(amount)
                var paymentError: NSError?

                applePayManager.onPaymentToken = { [weak applePayManager] paymentData, completion in
                    guard !paymentData.isEmpty else {
                        let error = NSError(
                            domain: "ApplePayTokenCapture",
                            code: -3,
                            userInfo: [NSLocalizedDescriptionKey: "Apple Pay returned empty paymentData (0 bytes). No usable token was received."]
                        )
                        paymentError = error
                        applePayManager?.logError(error, context: "Apple Pay token capture failed")
                        completion(false)
                        return
                    }

                    paymentError = nil
                    completion(true)
                }

                applePayManager.startPayment(amount: paymentAmount, currency: Currency) { [weak applePayManager] success in
                    applePayManager?.onPaymentToken = { _, completion in completion(false) }

                    if let paymentError {
                        promise(.failure(paymentError))
                    } else {
                        promise(.success(success))
                    }
                }
            }
        }
    }
}
