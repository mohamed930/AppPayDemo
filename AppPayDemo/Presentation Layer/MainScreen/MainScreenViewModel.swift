//
//  MainScreenViewModel.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 21/10/2026.
//

import Foundation
import Combine

class MainScreenViewModel: ObservableObject {
    @Published var txt: String = ""
    private var amount: Double = 0.0
    @Published var isVoilatedValidation: Bool = false
    
    func addPrefixPriceAndCurrncy() {
        guard let price = Double(txt) else {
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
        guard !txt.isEmpty else {
            txt = "0.0 EGP"
            isVoilatedValidation = true
            return
        }
        
        if txt.contains("0.0 EGP") || txt.isEmpty {
            isVoilatedValidation = true
        }
        else {
            isVoilatedValidation = false
        }
    }
}
