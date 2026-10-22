//
//  AlertPresenter.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import SwiftUI
import Combine

@MainActor
final class AlertPresenter: ObservableObject {

    @Published var isPresented = false
    @Published var params: AlertParams?

    func show(_ params: AlertParams) {
        self.params = params

        withAnimation(.spring(
            response: 0.4,
            dampingFraction: 0.82
        )) {
            isPresented = true
        }
    }

    func dismiss() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isPresented = false
        }
    }
}

struct AlertPresenterModifier: ViewModifier {

    @ObservedObject var presenter: AlertPresenter

    func body(content: Content) -> some View {
        content
            .overlay {
                if presenter.isPresented,
                   let params = presenter.params {

                    ZStack {
                        Color.black.opacity(0.35)
                            .ignoresSafeArea()
                            .onTapGesture {
                                presenter.dismiss()
                            }
                            .transition(.opacity)

                        AlertView(params: params) {
                            presenter.dismiss()
                        }
                        .frame(maxWidth: 420)
                        .transition(
                            .asymmetric(
                                insertion: .scale(scale: 0.85)
                                    .combined(with: .opacity),
                                removal: .scale(scale: 0.9)
                                    .combined(with: .opacity)
                            )
                        )
                    }
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
                    .zIndex(1)
                }
            }
            .animation(
                .spring(response: 0.4, dampingFraction: 0.82),
                value: presenter.isPresented
            )
    }
}

extension View {
    func customAlert(
        presenter: AlertPresenter
    ) -> some View {
        modifier(
            AlertPresenterModifier(presenter: presenter)
        )
    }
}
