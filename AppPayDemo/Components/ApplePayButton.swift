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

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)

        button.backgroundColor = .black
        button.layer.cornerRadius = 7
        button.clipsToBounds = true

        var config = UIButton.Configuration.plain()
        config.title = "Pay with  Pay"
        config.baseForegroundColor = .white
        config.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer { attributes in
                var updated = attributes
                updated.font = UIFont(name: "Quicksand-Bold", size: 24)
                return updated
            }

        button.configuration = config
        button.accessibilityLabel = "Pay with Apple Pay"

        button.addTarget(
            context.coordinator,
            action: #selector(Coordinator.didTap),
            for: .touchUpInside
        )

        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) {}

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

#Preview {
    ApplePayButton {}
        .frame(height: 50)
        .padding(.horizontal)
}
