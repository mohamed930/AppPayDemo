//
//  ApplePayManager.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import Foundation
import Combine
import PassKit

final class ApplePayManager: NSObject,
                             ObservableObject,
                             PKPaymentAuthorizationControllerDelegate {

    private var paymentController: PKPaymentAuthorizationController?

    // API integration hook: implement this with your backend.
    var onPaymentToken: (
        _ paymentData: Data,
        _ completion: @escaping (Bool) -> Void
    ) -> Void = { _, completion in
        // Fail safely until the real API is integrated.
        completion(false)
    }

    @available(iOS 17.4, *)
    func canMakePayment() -> Bool {
        PKPaymentAuthorizationController.canMakePayments(
            usingNetworks: ApplePayConfig.supportedNetworks
        )
    }

    @available(iOS 17.4, *)
    func startPayment(
        amount: Decimal,
        currency: String = ApplePayConfig.currencyCode,
        completion: @escaping (Bool) -> Void
    ) {
        guard canMakePayment() else {
            completion(false)
            return
        }

        let request = PKPaymentRequest()
        request.merchantIdentifier =
            ApplePayConfig.merchantIdentifier
        request.countryCode = ApplePayConfig.countryCode
        request.currencyCode = currency
        request.supportedNetworks =
            ApplePayConfig.supportedNetworks
        request.merchantCapabilities = .capability3DS

        request.paymentSummaryItems = [
            PKPaymentSummaryItem(
                label: "Recharge",
                amount: NSDecimalNumber(decimal: amount)
            )
        ]

        let controller = PKPaymentAuthorizationController(
            paymentRequest: request
        )

        self.paymentController = controller
        self.onFinished = completion
        controller.delegate = self

        controller.present { [weak self] presented in
            if !presented {
                self?.paymentController = nil
                self?.onFinished = nil
                completion(false)
            }
        }
    }

    private var onFinished: ((Bool) -> Void)?
    private var didCompleteAuthorization = false

    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        // This is the encrypted Apple Pay paymentData.
        let paymentData = payment.token.paymentData

        onPaymentToken(paymentData) { [weak self] success in
            DispatchQueue.main.async {
                self?.didCompleteAuthorization = success

                handler(
                    PKPaymentAuthorizationResult(
                        status: success
                            ? .success
                            : .failure,
                        errors: nil
                    )
                )
            }
        }
    }

    func paymentAuthorizationControllerDidFinish(
        _ controller: PKPaymentAuthorizationController
    ) {
        controller.dismiss {
            let success = self.didCompleteAuthorization
            self.onFinished?(success)

            self.onFinished = nil
            self.paymentController = nil
            self.didCompleteAuthorization = false
        }
    }
}
