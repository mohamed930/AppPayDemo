//
//  AlertStatus.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import Foundation

enum AlertStatus {
    case success
    case tokenReceived
    case failure

    var img: ImageResource {
        switch self {
        case .success, .tokenReceived:
            return .success
        case .failure:
            return .failure
        }
    }
    
    var color: ColorResource {
        switch self {
        case .success, .tokenReceived:
            return .success
        case .failure:
            return .failure
        }
    }
    
    var paymentStatusMessage: String {
        switch self {
        case .success:
            return "Payment Successful"
        case .tokenReceived:
            return "Apple Pay token received"
        case .failure:
            return "Payment failed"
        }
    }
}

struct AlertParams {
    let amount: String
    let reference: String
    let date: String
    let status: AlertStatus
}
