//
//  ApplePayButton.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 21/10/2026.
//

import SwiftUI
import PassKit

struct ApplePayButton: UIViewRepresentable {
    let action: () -> Void

    func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(
            paymentButtonType: .buy,
            paymentButtonStyle: .black
        )

        button.addTarget(
            context.coordinator,
            action: #selector(Coordinator.didTap),
            for: .touchUpInside
        )

        return button
    }

    func updateUIView(
        _ uiView: PKPaymentButton,
        context: Context
    ) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

    final class Coordinator: NSObject {
        let action: () -> Void

        init(action: @escaping () -> Void) {
            self.action = action
        }

        @objc func didTap() {
            action()
        }
    }
}
