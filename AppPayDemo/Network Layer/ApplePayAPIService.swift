//
//  ApplePayAPIService.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import Foundation

final class ApplePayAPIService {

    func submitPaymentToken(
        paymentData: Data,
        amount: Decimal,
        currency: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Apple Pay paymentData is serialized JSON.
        // Base64 encoding here is a transport representation;
        // confirm the exact field format required by your
        // CyberSource backend integration.
        let encodedPaymentData = paymentData.base64EncodedString()

        let body = ApplePayTokenRequest(
            paymentData: encodedPaymentData,
            amount: NSDecimalNumber(decimal: amount).stringValue,
            currency: currency
        )

        // TODO:
        // 1. Build URLRequest using your real backend URL.
        // 2. Set POST and Content-Type: application/json.
        // 3. Encode `body` with JSONEncoder.
        // 4. Send using URLSession.
        // 5. Validate the backend's payment status.
        //
        // Do not call completion(.success(())) until the
        // backend confirms the payment was authorized.

        completion(
            .failure(
                NSError(
                    domain: "ApplePayAPIService",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Backend API is not configured yet."
                    ]
                )
            )
        )
    }
}
