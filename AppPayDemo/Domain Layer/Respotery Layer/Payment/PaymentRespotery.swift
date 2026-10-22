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
    private var apiService: ApplePayAPIService
    
    init(applePayManager: ApplePayManager = ApplePayManager(),
         apiService: ApplePayAPIService = ApplePayAPIService()) {
        self.applePayManager = applePayManager
        self.apiService = apiService
    }
    
    func makeApplePayment(amount: Double, Currency: String) -> Future<Bool, NSError> {
        Future { [applePayManager, apiService] promise in
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

                applePayManager.onPaymentToken = { paymentData, completion in
                    apiService.submitPaymentToken(
                        paymentData: paymentData,
                        amount: paymentAmount,
                        currency: Currency
                    ) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                paymentError = nil
                                completion(true)
                            case .failure(let error):
                                paymentError = error as NSError
                                completion(false)
                            }
                        }
                    }
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
