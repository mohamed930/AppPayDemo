//
//  MainScreenViewModel.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 21/10/2026.
//

import Foundation
import Combine

@MainActor
class MainScreenViewModel: ObservableObject {
    @Published var txt: String = ""
    @Published var isVoilatedValidation: Bool = false
    @Published private(set) var isProcessingPayment = false

    let alertPresenter = AlertPresenter()
    
    var useCases: PaymentUseCases
    private var amount: Double = 0.0
    private var cancellables = Set<AnyCancellable>()
    
    init(useCases: PaymentUseCases) {
        self.useCases = useCases
    }
    
    func addPrefixPriceAndCurrncy() {
        let input = txt.replacingOccurrences(of: "EGP", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard let price = Double(input), price.isFinite else {
            amount = 0
            txt = "0.0 EGP"
            return
        }
        
        amount = price
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.minimumFractionDigits = price < 1000 ? 1 : 0
        formatter.maximumFractionDigits = 2

        let formattedPrice = formatter.string(from: NSNumber(value: price)) ?? "0.0"

        txt = "\(formattedPrice) EGP"
    }
    
    func validateApplePayButtonAction() {
        guard !isProcessingPayment else { return }
        addPrefixPriceAndCurrncy()
        isVoilatedValidation = amount <= 0
        guard !isVoilatedValidation else { return }

        isProcessingPayment = true
        let paymentAmount = txt

        useCases.makePayment(amount: amount)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                self.isProcessingPayment = false

                if case .failure = completion {
                    self.showPaymentAlert(amount: paymentAmount, status: .failure)
                }
            }, receiveValue: { [weak self] success in
                self?.showPaymentAlert(amount: paymentAmount, status: success ? .tokenReceived : .failure)
            })
            .store(in: &cancellables)
    }

    private func showPaymentAlert(amount: String, status: AlertStatus) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"

        alertPresenter.show(AlertParams(
            amount: amount,
            reference: "—",
            date: formatter.string(from: Date()),
            status: status
        ))
    }
}
