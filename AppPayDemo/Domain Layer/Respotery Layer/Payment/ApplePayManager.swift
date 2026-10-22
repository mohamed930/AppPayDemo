//
//  ApplePayManager.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import Foundation
import Combine
import PassKit
import OSLog

final class ApplePayManager: NSObject,
                             ObservableObject,
                             PKPaymentAuthorizationControllerDelegate {

    private var paymentController: PKPaymentAuthorizationController?
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "AppPayDemo",
        category: "ApplePay"
    )

    private func logMessage(_ message: String, level: OSLogType = .error) {
        logger.log(level: level, "\(message, privacy: .public)")
        print("[ApplePay] \(message)")
    }

    private func logConfiguration() {
        logMessage("Bundle ID: \(Bundle.main.bundleIdentifier ?? "unknown")", level: .info)
        #if targetEnvironment(simulator)
        logMessage("Running on Simulator. Use a physical iPhone to verify encrypted token generation.", level: .info)
        #else
        logMessage("Running on a physical device.", level: .info)
        // Inspect the embedded development profile, not just the source entitlements file.
        if let url = Bundle.main.url(forResource: "embedded", withExtension: "mobileprovision"),
           let data = try? Data(contentsOf: url),
           let start = data.range(of: Data("<?xml".utf8)),
           let end = data.range(of: Data("</plist>".utf8)),
           start.lowerBound < end.upperBound,
           let profile = (try? PropertyListSerialization.propertyList(
               from: data.subdata(in: start.lowerBound..<end.upperBound),
               options: [], format: nil
           )) as? [String: Any],
           let entitlements = profile["Entitlements"] as? [String: Any] {
            let merchants = entitlements["com.apple.developer.in-app-payments"] as? [String] ?? []
            logMessage("Provisioning profile allowed merchants: \(merchants)", level: .info)
            if !merchants.contains(ApplePayConfig.merchantIdentifier) {
                logMessage("The embedded provisioning profile does not list the configured merchant. Verify Apple Pay capability and regenerate the profile.")
            }
        } else {
            logMessage("Embedded provisioning profile could not be inspected. Verify signing and Apple Pay capability in Xcode.", level: .info)
        }
        #endif
    }

    func logError(_ error: Error, context: String) {
        let error = error as NSError
        logMessage("\(context): domain=\(error.domain), code=\(error.code), description=\(error.localizedDescription)")

        if let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError {
            logMessage("Underlying error: domain=\(underlyingError.domain), code=\(underlyingError.code), description=\(underlyingError.localizedDescription)")
        }
    }

    // Token handling hook. The current repository validates token capture without charging funds.
    var onPaymentToken: (
        _ paymentData: Data,
        _ completion: @escaping (Bool) -> Void
    ) -> Void = { _, completion in
        // Fail safely until the real API is integrated.
        completion(false)
    }

    @available(iOS 17.4, *)
    func canMakePayment() -> Bool {
        guard PKPaymentAuthorizationController.canMakePayments() else {
            logMessage("Apple Pay is unavailable on this device or restricted by device settings.")
            return false
        }

        let canPay = PKPaymentAuthorizationController.canMakePayments(
            usingNetworks: ApplePayConfig.supportedNetworks
        )
        if !canPay {
            logMessage("Apple Pay has no eligible card for the configured payment networks.")
        }
        return canPay
    }

    @available(iOS 17.4, *)
    func startPayment(
        amount: Decimal,
        currency: String = ApplePayConfig.currencyCode,
        completion: @escaping (Bool) -> Void
    ) {
        logMessage("Starting payment: amount=\(amount), currency=\(currency), merchant=\(ApplePayConfig.merchantIdentifier)", level: .info)
        logConfiguration()
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
            self?.logMessage("Payment sheet presented: \(presented)", level: .info)
            if !presented {
                self?.logMessage("Apple Pay sheet presentation failed. PassKit did not provide an error object. Check the merchant identifier, Apple Pay entitlement, and payment request configuration.")
                self?.paymentController = nil
                self?.onFinished = nil
                completion(false)
            }
        }
    }

    private var onFinished: ((Bool) -> Void)?
    private var didCompleteAuthorization = false

    func paymentAuthorizationControllerWillAuthorizePayment(
        _ controller: PKPaymentAuthorizationController
    ) {
        logMessage("Apple Pay will authorize payment; waiting for encrypted token.", level: .info)
    }

    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        // This is the encrypted Apple Pay paymentData.
        let paymentData = payment.token.paymentData
        logMessage("Apple Pay authorization received. Token size: \(paymentData.count) bytes.", level: .info)

        #if DEBUG
        // Print the encrypted token for local integration debugging.
        let token = String(data: paymentData, encoding: .utf8)
            ?? paymentData.base64EncodedString()
        logMessage("Payment token (paymentData): \(token)", level: .info)
        #endif

        onPaymentToken(paymentData) { [weak self] success in
            DispatchQueue.main.async {
                self?.didCompleteAuthorization = success
                self?.logMessage("Payment token processing completed: success=\(success)", level: .info)

                if !success {
                    self?.logMessage("Apple Pay token handling failed. See the token capture error log for details.")
                }

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
        logMessage("Apple Pay requested dismissal. Authorized successfully: \(didCompleteAuthorization)", level: .info)
        controller.dismiss {
            let success = self.didCompleteAuthorization
            if !success {
                self.logMessage("Apple Pay sheet dismissed without a successful payment (cancelled or authorization failed).", level: .info)
            }
            self.onFinished?(success)

            self.onFinished = nil
            self.paymentController = nil
            self.didCompleteAuthorization = false
        }
    }
}
